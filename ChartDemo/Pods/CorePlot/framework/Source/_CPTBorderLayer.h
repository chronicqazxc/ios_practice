#import "CPTLayer.h"

@class CPTBorderedLayer;

@interface CPTBorderLayer : CPTLayer {
    @private
    CPTBorderedLayer *maskedLayer;
}

@property (nonatomic, readwrite, weak) CPTBorderedLayer *maskedLayer;

@end
