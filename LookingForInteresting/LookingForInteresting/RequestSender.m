//
//  RequestSender.m
//  LookingForInteresting
//
//  Created by Wayne on 2/7/15.
//  Copyright (c) 2015 Wayne. All rights reserved.
//

#import "RequestSender.h"

@interface RequestSender() <NSURLConnectionDelegate>
@property (strong, nonatomic) NSMutableArray *receivedDatas;
@property (nonatomic) FilterType type;
@end

@implementation RequestSender

- (id)init {
    self = [super init];
    if (self) {
        self.receivedDatas = [NSMutableArray array];
    }
    return self;
}

- (void)sendMenuRequest {
    self.type = FilterTypeMenu;
    [self sendRequestByParams:@{} andURL:[NSString stringWithFormat:@"%@%@",kLookingForInterestURL,kGetInitMenuURL]];
}

- (void)sendMajorRequest {
    self.type = FilterTypeMajorType;
    [self sendRequestByParams:@{} andURL:[NSString stringWithFormat:@"%@%@",kLookingForInterestURL,kGetMajorTypesURL]];
}

- (void)sendMinorRequestByMajorType:(MajorType *)majorType {
    self.type = FilterTypeMinorType;
    [self sendRequestByParams:@{@"major_type_id": majorType.typeID} andURL:[NSString stringWithFormat:@"%@%@",kLookingForInterestURL,kGetMinorTypesURL]];
}

- (void)sendStoreRequestByMajorType:(MajorType *)majorType minorType:(MinorType *)minorType {
    self.type = FilterTypeStore;
    [self sendRequestByParams:@{@"major_type_id":majorType.typeID, @"minor_type_id":minorType.typeID} andURL:[NSString stringWithFormat:@"%@%@",kLookingForInterestTestURL,kGetStoresURL]];
}

- (void)sendStoreRequestByMenuObj:(Menu *)menu andLocationCoordinate:(CLLocationCoordinate2D)location {
    self.type = SearchStores;
    [self sendRequestByParams:@{@"major_type_id":menu.majorType.typeID, @"minor_type_id":menu.minorType.typeID, @"range":[NSNumber numberWithDouble: [menu.range doubleValue]], @"latitude":[NSNumber numberWithDouble:location.latitude], @"longitude":[NSNumber numberWithDouble:location.longitude]} andURL:[NSString stringWithFormat:@"%@%@",kLookingForInterestURL,kGetStoresByLocationURL]];
}

- (void)sendRangeRequest {
    self.type = FilterTypeRange;
    [self sendRequestByParams:@{} andURL:[NSString stringWithFormat:@"%@%@",kLookingForInterestURL,kGetRangesURL]];
}

- (void)sendRequestByParams:(NSDictionary *)paramDic andURL:(NSString *)URL{
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:paramDic options:0 error:&error];
    
    NSURL *url = [NSURL URLWithString:URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}
#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSError *error = nil;
    if (error == nil) {
        [self.receivedDatas addObject:data];
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.delegate) {
        switch (self.type) {
            case FilterTypeMenu:
                if ([self.delegate respondsToSelector:@selector(initMenuBack:)]) {
                    NSArray *datas = [self parseMenuData:self.receivedDatas];
                    [self.delegate initMenuBack:datas];
                }
                break;
            case FilterTypeMajorType:
                if ([self.delegate respondsToSelector:@selector(majorsBack:)]) {
                    NSArray *datas = [self parseMajorTypeData:self.receivedDatas];
                    [self.delegate majorsBack:datas];
                }
                break;
            case FilterTypeMinorType:
                if ([self.delegate respondsToSelector:@selector(minorsBack:)]) {
                    NSArray *datas = [self parseMinorTypeData:self.receivedDatas];
                    [self.delegate minorsBack:datas];
                }
                break;
            case FilterTypeStore:
                if ([self.delegate respondsToSelector:@selector(storesBack:)]) {
                    NSArray *datas = [self parseStoreData:self.receivedDatas];
                    [self.delegate storesBack:datas];
                }
                break;
            case FilterTypeRange:
                if ([self.delegate respondsToSelector:@selector(rangesBack:)]) {
                    NSArray *datas = [self parseRangeData:self.receivedDatas];
                    [self.delegate rangesBack:datas];
                }
                break;
            case SearchStores:
                if ([self.delegate respondsToSelector:@selector(storesBack:)]) {
                    NSArray *datas = [self parseStoreData:self.receivedDatas];
                    [self.delegate storesBack:datas];
                }
                break;
            default:
                break;
        }
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

- (NSArray *)parseMenuData:(NSArray *)datas {
    NSError *error = nil;
    NSMutableArray *array = [NSMutableArray array];
    for (NSData *data in datas) {
        NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        Menu *menu = [[Menu alloc] initWithMenuDic:parsedData];
        [array addObject:menu];
    }
    return array;
}

- (NSArray *)parseMajorTypeData:(NSArray *)datas {
    NSError *error = nil;
    NSMutableArray *array = [NSMutableArray array];
    for (NSData *data in datas) {
        NSArray *majorTypesData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        for (int i=0; i<[majorTypesData count]; i++) {
            MajorType *majorType = [[MajorType alloc] initWithMajorTypeDic:[majorTypesData objectAtIndex:i]];
            [array addObject:majorType];
        }
    }
    return array;
}

- (NSArray *)parseMinorTypeData:(NSArray *)datas {
    NSError *error = nil;
    NSMutableArray *array = [NSMutableArray array];
    for (NSData *data in datas) {
        NSArray *minorTypesData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        for (int i=0; i<[minorTypesData count]; i++) {
            MinorType *minorType = [[MinorType alloc] initWithMinorTypeDic:[minorTypesData objectAtIndex:i]];
            [array addObject:minorType];
        }
    }
    return array;
}

- (NSArray *)parseStoreData:(NSArray *)datas {
    NSError *error = nil;
    NSMutableArray *array = [NSMutableArray array];
    for (NSData *data in datas) {
        NSArray *storesData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        for (int i=0; i<[storesData count]; i++) {
            Store *store = [[Store alloc] initWithStoreDic:[storesData objectAtIndex:i]];
            [array addObject:store];
        }
    }
    return array;
}

- (NSArray *)parseRangeData:(NSArray *)datas {
    NSError *error = nil;
    NSMutableArray *array = [NSMutableArray array];
    for (NSData *data in datas) {
        NSArray *rangesData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        [array addObject:rangesData];
    }
    return array;
}

@end
