//
//  ViewController.m
//  GoogleMapDemo
//
//  Created by Wayne on 1/29/15.
//  Copyright (c) 2015 Wayne. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>


@interface ViewController () <GMSMapViewDelegate, CLLocationManagerDelegate>
@property (nonatomic) BOOL isFirstEntry;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (nonatomic) CGRect rect;
@property (strong, nonatomic) GMSMapView *googleMap;
@property (strong, nonatomic) GMSPanoramaView *panoView;
@property (strong, nonatomic) GMSGeocoder *gmsGeoCoder;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D currentLocation;
- (IBAction)showMap1:(UIButton *)sender;
- (IBAction)showMap2:(UIButton *)sender;
- (IBAction)showMap3:(UIButton *)sender;
- (IBAction)showMap4:(UIButton *)sender;
@end

@implementation ViewController

- (id)init {
    self = [super init];
    if (self) {
        self.isFirstEntry = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.isFirstEntry = YES;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isFirstEntry = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    self.currentLocation = CLLocationCoordinate2DMake(0, 0);
}

- (void)viewWillLayoutSubviews NS_AVAILABLE_IOS(5_0) {
    [super viewWillLayoutSubviews];
    self.rect = self.mapView.frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    self.currentLocation = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    if (self.isFirstEntry) {
        [self showMap1:nil];
        self.isFirstEntry = NO;
    }
}

- (void)resetView {
    for (UIView *view in [self.mapView subviews]) {
        [view removeFromSuperview];
    }
}

- (IBAction)showMap1:(UIButton *)sender {
    [self resetView];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.currentLocation.latitude
                                                            longitude:self.currentLocation.longitude
                                                                 zoom:15];
    self.googleMap = [GMSMapView mapWithFrame:CGRectMake(0,0,self.rect.size.width,self.rect.size.height) camera:camera];
    self.googleMap.settings.myLocationButton = YES;
    self.googleMap.myLocationEnabled = YES;
    self.googleMap.settings.compassButton = YES;
    self.googleMap.delegate = self;
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(41.887, -87.622);
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.icon = [UIImage imageNamed:@"flag_icon"];
    marker.map = self.googleMap;
    [self.mapView addSubview:self.googleMap];
}

- (IBAction)showMap2:(UIButton *)sender {
    [self resetView];
    CLLocationCoordinate2D panoramaNear = {self.currentLocation.latitude,self.currentLocation.longitude};
    
    self.panoView = [GMSPanoramaView panoramaWithFrame:CGRectMake(0,0,self.rect.size.width,self.rect.size.height) nearCoordinate:panoramaNear];
    
    [self.mapView addSubview:self.panoView];
}

- (IBAction)showMap3:(UIButton *)sender {
    [self resetView];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.currentLocation.latitude
                                longitude:self.currentLocation.longitude
                                     zoom:17.5
                                  bearing:30
                             viewingAngle:40];
    
    self.googleMap = [GMSMapView mapWithFrame:CGRectMake(0,0,self.rect.size.width,self.rect.size.height) camera:camera];
    self.googleMap.settings.myLocationButton = YES;
    self.googleMap.myLocationEnabled = YES;
    self.googleMap.settings.compassButton = YES;
    self.googleMap.delegate = self;
    [self.mapView addSubview:self.googleMap];
}

- (IBAction)showMap4:(UIButton *)sender {
    [self resetView];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.currentLocation.latitude
                                                            longitude:self.currentLocation.longitude
                                                                 zoom:18];
    
    self.googleMap = [GMSMapView mapWithFrame:CGRectMake(0,0,self.rect.size.width,self.rect.size.height) camera:camera];
    self.googleMap.settings.myLocationButton = YES;
    self.googleMap.myLocationEnabled = YES;
    self.googleMap.settings.compassButton = YES;
    self.googleMap.delegate = self;    
    [self.mapView addSubview:self.googleMap];
}

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture {
    [mapView clear];
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)cameraPosition {
    id handler = ^(GMSReverseGeocodeResponse *response, NSError *error) {
        if (error == nil) {
            GMSReverseGeocodeResult *result = response.firstResult;
            GMSMarker *marker = [GMSMarker markerWithPosition:cameraPosition.target];
            marker.title = result.lines[0];
            marker.snippet = result.lines[1];
            marker.map = mapView;
        }
    };
    [self.gmsGeoCoder reverseGeocodeCoordinate:cameraPosition.target completionHandler:handler];
}

- (BOOL)didTapMyLocationButtonForMapView:(GMSMapView *)mapView {
    NSLog(@"%.2f, %.2f",mapView.myLocation.coordinate.latitude, mapView.myLocation.coordinate.longitude);
    GMSCameraPosition *fancy = [GMSCameraPosition cameraWithLatitude:mapView.myLocation.coordinate.latitude longitude:mapView.myLocation.coordinate.longitude zoom:17 bearing:30 viewingAngle:45];
    [mapView setCamera:fancy];
    return YES;
}
@end
