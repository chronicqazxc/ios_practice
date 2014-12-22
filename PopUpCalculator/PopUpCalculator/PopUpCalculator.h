//
//  PopUpCalculator.h
//  Chinatrust
//
//  Created by Wayne on 6/12/14.
//
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define ClearColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.0]

#define TranColorFromRGBAndAlpha(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

@protocol PopUpCalculatorDelegate;

@interface PopUpCalculator : UIView

@property (retain, nonatomic) IBOutlet UIView *calculatorView;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *numerics;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *operators;
@property (retain, nonatomic) IBOutlet UIButton *backButton;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;
@property (retain, nonatomic) IBOutlet UIButton *dotButton;
@property (retain, nonatomic) IBOutlet UIButton *answerButton;
@property (retain, nonatomic) IBOutlet UILabel *textField;
@property (retain, nonatomic) UIView *view;
@property (retain, nonatomic) id <PopUpCalculatorDelegate> delegate;

- (IBAction)clickNumeric:(UIButton *)sender;
- (IBAction)clickOperator:(UIButton *)sender;
- (IBAction)clickBack:(UIButton *)sender;
- (IBAction)clickCancel:(UIButton *)sender;
- (IBAction)clickDot:(UIButton *)sender;
- (IBAction)clickAnswer:(UIButton *)sender;
- (IBAction)removeCalculator;
- (NSNumber *)stringToNumber:(NSString *)stringNumber;
- (NSString *)thousandSeparatorFormat:(NSNumber *)number;
- (void)popUpCalculator;
- (void)popUpCalculatorWithCost:(NSString *)cost;
@end

@protocol PopUpCalculatorDelegate <NSObject>

- (void)getCalculatResult:(NSString *)result;

@end
