//
//  PopUpCalculator.m
//  Chinatrust
//
//  Created by Wayne on 6/12/14.
//
//

#import "PopUpCalculator.h"

#define ButtonPosition CGRectMake(28, 600, 275, 293)
#define CenterPosition CGRectMake(28, 166, 275, 293)
#define setStringOnScreen(string) self.stringOnScreen = [NSMutableString stringWithString:string]
#define setStringForCalculate(string) self.stringForCalculate = [NSMutableString stringWithString:string]
#define setCurrentNumeric(string) self.currentNumeric = [NSMutableString stringWithString:string]
#define setCurrentOperator(string) self.currentOperator = [NSMutableString stringWithString:string]
#define setTextField self.textField.text = self.stringOnScreen
#define showShadow 0

static int numericMaxValue = 14;
static double resultMaxValue = 999999999999999;

@interface PopUpCalculator()
@property (retain, nonatomic) NSMutableString *stringOnScreen;
@property (retain, nonatomic) NSMutableString *stringForCalculate;
@property (retain, nonatomic) NSMutableString *currentNumeric;
@property (retain, nonatomic) NSMutableString *currentOperator;
@property (nonatomic) BOOL isReset;
@end

@implementation PopUpCalculator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.isReset = YES;
        self.currentNumeric = [NSMutableString string];
        self.currentOperator = [NSMutableString string];
    }
    return self;
}

- (void)setOpaque:(BOOL)newIsOpaque
{
    // Ignore attempt to set opaque to YES.
}

- (void)drawRect:(CGRect)rect
{
    if([self.delegate isKindOfClass:[UIView class]])
    {
        
    }
    else
    {
        
    }
    for (UIButton *button in self.numerics) {
        [button setTitleColor:UIColorFromRGB(0x545454) forState:UIControlStateNormal];
        UIImage *normalImage = [self imageWithColor:UIColorFromRGB(0xefefef)];
        UIImage *highlightedImage = [self imageWithColor:UIColorFromRGB(0xc1c1c1)];
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
        [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
#if showShadow
        [self addSadhowToView:button withRadius:1.0 andSize:CGSizeMake(0,1)];
#endif

        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
    }
    for (UIButton *button in self.operators) {
        [button setTitleColor:UIColorFromRGB(0x545454) forState:UIControlStateNormal];
        UIImage *normalImage = [self imageWithColor:UIColorFromRGB(0xefefef)];
        UIImage *highlightedImage = [self imageWithColor:UIColorFromRGB(0xc1c1c1)];
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
        [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
#if showShadow
        [self addSadhowToView:button withRadius:1.0 andSize:CGSizeMake(0,1)];
#endif
    }
    
#if showShadow
    [self addSadhowToView:self.backButton withRadius:1.0 andSize:CGSizeMake(0,1)];
    [self addSadhowToView:self.cancelButton withRadius:1.0 andSize:CGSizeMake(0,1)];
    [self addSadhowToView:self.dotButton withRadius:1.0 andSize:CGSizeMake(0,1)];
    [self addSadhowToView:self.answerButton withRadius:1.0 andSize:CGSizeMake(0,1)];
    [self addSadhowToView:self.textField withRadius:1.0 andSize:CGSizeMake(0,1)];
#endif
    
    [self.backButton setTitleColor:UIColorFromRGB(0x545454) forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:UIColorFromRGB(0x545454) forState:UIControlStateNormal];
    [self.dotButton setTitleColor:UIColorFromRGB(0x545454) forState:UIControlStateNormal];
    [self.answerButton setTitleColor:UIColorFromRGB(0x545454) forState:UIControlStateNormal];
    
    UIImage *normalImage = [self imageWithColor:UIColorFromRGB(0xefefef)];
    UIImage *highlightedImage = [self imageWithColor:UIColorFromRGB(0xc1c1c1)];
    [self.backButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self.backButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [self.cancelButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [self.dotButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self.dotButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    
    UIImage *answerNormalImage = [self imageWithColor:UIColorFromRGB(0xed6060)];
    UIImage *answerHighlightedImage = [self imageWithColor:UIColorFromRGB(0xdb4d4d)];
    [self.answerButton setBackgroundImage:answerNormalImage forState:UIControlStateNormal];
    [self.answerButton setBackgroundImage:answerHighlightedImage forState:UIControlStateHighlighted];
    [self.answerButton setTitle:@"OK" forState:UIControlStateNormal];
    
    [self.calculatorView setBackgroundColor:UIColorFromRGB(0xd0d0d0)];
    [self.textField setTextColor:UIColorFromRGB(0x545454)];
    
    [self textFieldSize];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)popUpCalculator {
    if([self.delegate isKindOfClass:[UIViewController class]])
    {
        UIViewController* viewctrler = (UIViewController*)self.delegate;
        [viewctrler.view addSubview:self];
    }
    self.calculatorView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.calculatorView.alpha = 0;
//    for (UIButton *button in self.numerics) {
//        [self smoothBorderOfView:button withCornerRadius:2.0];
//    }
//    for (UIButton *button in self.operators) {
//        [self smoothBorderOfView:button withCornerRadius:2.0];
//    }
//    [self smoothBorderOfView:self.backButton withCornerRadius:2.0];
//    [self smoothBorderOfView:self.cancelButton withCornerRadius:2.0];
//    [self smoothBorderOfView:self.dotButton withCornerRadius:2.0];
//    [self smoothBorderOfView:self.answerButton withCornerRadius:2.0];
//    [self smoothBorderOfView:self.textField withCornerRadius:2.0];
//    
//    [self smoothBorderOfView:self.calculatorView withCornerRadius:2.0];
    [UIView beginAnimations:@"PopupCalculator" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    self.calculatorView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    self.calculatorView.alpha = 1;
    [UIView commitAnimations];
}

- (void)click:(UIButton *)sender {
    for (UIView *view in sender.subviews) {
        if (view.tag == 4321) {
            view.layer.masksToBounds = YES;
        }
    }
}

- (void)smoothBorderOfView:(UIView *)view withCornerRadius:(float)cornerRadius {
    UIView *cornerView = [[UIView alloc] init];
    cornerView.layer.masksToBounds = YES;
    cornerView.layer.cornerRadius = cornerRadius;
    cornerView.layer.borderColor = [UIColor redColor].CGColor;
    cornerView.layer.borderWidth = 3.0;
    cornerView.tag = 1234;
    [view addSubview:cornerView];
//    [cornerView release];
}

- (void)addSadhowToView:(UIView *)view withRadius:(float)radius andSize:(CGSize)size {
    view.layer.masksToBounds = NO;
    view.layer.shadowOffset = CGSizeMake(0, 1);
    view.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    view.layer.shadowOpacity = 1;
    view.layer.shadowRadius = radius;
}

- (void)popUpCalculatorWithCost:(NSString *)cost {
    setStringOnScreen([self thousandSeparatorFormat:[self stringToNumber:cost]]);
    setStringForCalculate(cost);
    setCurrentNumeric(cost);
    setTextField;
    [self popUpCalculator];
}

- (void)slideFromButtom{
    [self.calculatorView setFrame:ButtonPosition];
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.4];
    [self.calculatorView setFrame:CenterPosition];
    [UIView commitAnimations];
}

//- (void)dealloc {
//    [_numerics release];
//    [_operators release];
//    [_backButton release];
//    [_cancelButton release];
//    [_dotButton release];
//    [_answerButton release];
//    [_textField release];
//    [_calculatorView release];
//    [super dealloc];
//}
- (IBAction)clickNumeric:(UIButton *)sender {
    for (UIView *view in sender.subviews) {
        if (view.tag == 4321) {
            view.layer.masksToBounds = NO;
        }
    }
    if ([self.stringOnScreen isEqualToString:@"+"] ||
        [self.stringOnScreen isEqualToString:@"x"] ||
        [self.stringOnScreen isEqualToString:@"÷"]) {
        setStringOnScreen(@"");
        setStringForCalculate(@"");
        setCurrentNumeric(@"");
        setTextField;
    }
    self.isReset = NO;
    if ([self.currentNumeric isEqualToString:@""])
        [self getCurrentNumeric];
    if (self.currentNumeric.length > numericMaxValue)
        [self removeLastCharacter];
    if ([self isReachMaxFractionDigits:self.currentNumeric])
        [self removeLastCharacter];
    NSString *numberString = [NSString stringWithFormat:@"%d", sender.tag];
    if ([self.textField.text isEqualToString:@"0"]) {
        setStringOnScreen(@"");
        setStringForCalculate(@"");
        setCurrentNumeric(@"");
    }
    [self getTextSizeOnScreen];
    [self textFieldSize];
    [self.currentNumeric appendString:numberString];
    [self.stringOnScreen appendString:numberString];
    [self removeLastOperator];
    [self.stringOnScreen appendString:[self thousandSeparatorFormat:[self stringToNumber:self.currentNumeric]]];
    [self.stringForCalculate appendString:numberString];
    setCurrentOperator(@"");
    setTextField;
    [self determindAnswerButtonTitle];
}

- (BOOL)isReachMaxFractionDigits:(NSString *)digits {
    BOOL result = NO;
    for (int i = 0; i < digits.length; i++) {
        if ([[digits substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"."]) {
            for (int j = i; j < digits.length; j++) {
                if (j-i == 2)
                    result = YES;
            }
        }
    }
    return result;
}

- (NSNumber *)stringToNumber:(NSString *)stringNumber {
    NSNumberFormatter *currentNumberFormatter = [[NSNumberFormatter alloc] init];
    [currentNumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *myNumber = [currentNumberFormatter numberFromString:stringNumber];
//    [currentNumberFormatter release];
    return myNumber;
}

- (void)removeLastOperator {
    NSRange range = NSMakeRange(0, 1);
    for (int index = self.stringOnScreen.length-1; index >= 0; index--) {
        range.location = index;
        if ([[self.stringOnScreen substringWithRange:range] isEqualToString:@"+"] ||
            [[self.stringOnScreen substringWithRange:range] isEqualToString:@"-"] ||
            [[self.stringOnScreen substringWithRange:range] isEqualToString:@"x"] ||
            [[self.stringOnScreen substringWithRange:range] isEqualToString:@"÷"] ||
            index == 0) {
            if (index == 0)
                setStringOnScreen(@"");
            else
                setStringOnScreen([self.stringOnScreen substringToIndex:index+1]);
            break;
        }
    }
}

- (void)getTextSizeOnScreen {
    CGSize size = CGSizeMake(0, 0);
    NSString *requireVersion = @"7.0";
    NSString *currentVersion = [[UIDevice currentDevice] systemVersion];
    UIFont *screenTextFont = [UIFont systemFontOfSize:22.0f];
    if ([currentVersion compare:requireVersion options:NSNumericSearch] != NSOrderedAscending) {
        size = [self.stringOnScreen sizeWithAttributes:@{NSFontAttributeName: screenTextFont}];
    } else {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = [self.stringOnScreen sizeWithFont:screenTextFont];
        #pragma clang diagnostic pop
    }
    if (size.width > self.textField.frame.size.width*2 - 20) {
        [self removeLastCharacter];
    }
}

- (void)textFieldSize {
    CGSize size = CGSizeMake(0, 0);
    NSString *requireVersion = @"7.0";
    NSString *currentVersion = [[UIDevice currentDevice] systemVersion];
    UIFont *screenTextFont = [UIFont systemFontOfSize:22.0f];
    if ([currentVersion compare:requireVersion options:NSNumericSearch] != NSOrderedAscending) {
        size = [self.stringOnScreen sizeWithAttributes:@{NSFontAttributeName: screenTextFont}];
    } else {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = [self.stringOnScreen sizeWithFont:screenTextFont];
        #pragma clang diagnostic pop
    }
    if (size.width > self.textField.frame.size.width-20) {
        CGRect rect = self.textField.frame;
        self.textField.frame = CGRectMake(rect.origin.x, 8, rect.size.width, 55);
    } else {
        CGRect rect = self.textField.frame;
        self.textField.frame = CGRectMake(rect.origin.x, 18, rect.size.width, 55/2);
    }
}

- (void)removeLastCharacter {
    setStringOnScreen([self.stringOnScreen substringToIndex:self.stringOnScreen.length - 1]);
    if (self.currentNumeric.length > 0)
        setCurrentNumeric([self.currentNumeric substringToIndex:self.currentNumeric.length - 1]);
    setStringForCalculate([self.stringForCalculate substringToIndex:self.stringForCalculate.length - 1]);
}

- (IBAction)clickOperator:(UIButton *)sender {
    self.isReset = NO;
    [self.answerButton setTitle:@"=" forState:UIControlStateNormal];
    NSString *operatorOnScreen = @"";
    NSString *operatorForCalculate = @"";
    switch (sender.tag) {
        case 0:
            operatorOnScreen = @"+";
            operatorForCalculate = @"+";
            break;
        case 1:
            operatorOnScreen = @"-";
            operatorForCalculate = @"-";
            break;
        case 2:
            operatorOnScreen = @"x";
            operatorForCalculate = @"*";
            break;
        case 3:
            operatorOnScreen = @"÷";
            operatorForCalculate = @"/";
            break;
    }
    [self getTextSizeOnScreen];
    [self textFieldSize];
    //[self.currentOperator isEqualToString:@""] && [self.currentNumeric isEqualToString:@""] && [self.textField.text isEqualToString:@"0"] && [operatorOnScreen isEqualToString:@"-"]
    if (([self.stringOnScreen isEqualToString:@""] && [operatorOnScreen isEqualToString:@"-"]) ||
        ([self.stringOnScreen isEqualToString:@"0"] && [operatorOnScreen isEqualToString:@"-"]) ||
        ([self.stringOnScreen isEqualToString:@"-"] && [operatorOnScreen isEqualToString:@"-"])) {
        setStringOnScreen(@"-");
        setStringForCalculate(@"-");
    } else if ([self.currentOperator isEqualToString:@""]) {
        [self.stringOnScreen appendString:operatorOnScreen];
        [self.stringForCalculate appendString:operatorForCalculate];
    } else {
        [self clickBack:nil];
        [self.stringOnScreen appendString:operatorOnScreen];
        [self.stringForCalculate appendString:operatorForCalculate];
    }
    setCurrentNumeric(@"");
    setCurrentOperator(operatorOnScreen);
    setTextField;
}

- (void)clickOperatorInFirstCharactor:(UIButton *)sender {
    NSString *operatorOnScreen = @"";
    NSString *operatorForCalculate = @"";
    switch (sender.tag) {
        case 0:
            operatorOnScreen = @"+";
            operatorForCalculate = @"+";
            break;
        case 1:
            operatorOnScreen = @"-";
            operatorForCalculate = @"-";
            break;
        case 2:
            operatorOnScreen = @"x";
            operatorForCalculate = @"*";
            break;
        case 3:
            operatorOnScreen = @"÷";
            operatorForCalculate = @"/";
            break;
    }
}

- (IBAction)clickBack:(UIButton *)sender {
    [self.answerButton setTitle:@"=" forState:UIControlStateNormal];
    self.isReset = NO;
    if ([self.textField.text isEqualToString:@"0"]) {
        setStringOnScreen(@"");
        setCurrentNumeric(@"");
        setStringForCalculate(@"");
        setCurrentOperator(@"");
        setTextField;
        self.isReset = YES;
    } else if (self.stringOnScreen.length > 1) {
        NSString *subtrctedStringForCalculate = [self.stringForCalculate substringToIndex:self.stringForCalculate.length - 1];
        setStringForCalculate(subtrctedStringForCalculate);
        if (![self isLastCharactorEqualOperatorSymbol]) {
            if ([self.currentNumeric isEqualToString:@""]) {
                [self getCurrentNumeric];
            } else {
                setCurrentNumeric([self.currentNumeric substringToIndex:self.currentNumeric.length-1]);
            }
            if (![self.currentNumeric isEqualToString:@""]) {
                [self removeLastOperator];
//                NSLog(@"%@",[self thousandSeparatorFormat:[self stringToNumber:self.currentNumeric]]);
                if ([self thousandSeparatorFormat:[self stringToNumber:self.currentNumeric]]) {
                    [self.stringOnScreen appendString:[self thousandSeparatorFormat:[self stringToNumber:self.currentNumeric]]];
                } else {
                    [self.stringOnScreen appendString:self.currentNumeric];
                }

            } else {
                setStringOnScreen([self.stringOnScreen substringToIndex:self.stringOnScreen.length-1]);
            }
            setCurrentNumeric(@"");
        } else {
            NSString *subtractedStringOnScreen = [self.stringOnScreen substringToIndex:self.stringOnScreen.length - 1];
            setStringOnScreen(subtractedStringOnScreen);
        }
        setTextField;
    } else if (self.stringOnScreen.length == 1 && ![self.stringOnScreen isEqualToString:@"0"]) {
        setStringOnScreen(@"");
        setStringForCalculate(@"");
        setCurrentNumeric(@"");
        setCurrentOperator(@"");
        setTextField;
    }
    [self textFieldSize];
    [self determindAnswerButtonTitle];
}

- (void)getCurrentNumeric {
    NSRange range = NSMakeRange(0, 1);
    for (int index = self.stringForCalculate.length-1; index >= 0; index--) {
        range.location = index;
        if ([[self.stringForCalculate substringWithRange:range] isEqualToString:@"+"] ||
            [[self.stringForCalculate substringWithRange:range] isEqualToString:@"-"] ||
            [[self.stringForCalculate substringWithRange:range] isEqualToString:@"*"] ||
            [[self.stringForCalculate substringWithRange:range] isEqualToString:@"/"] ||
            index == 0) {
            if (index == 0) {
                setCurrentNumeric([self.stringForCalculate substringToIndex:self.stringForCalculate.length]);
            } else {
                NSString *string = [self.stringForCalculate substringFromIndex:index+1];
                if ([string isEqualToString:@""])
                    break;
                else
                    setCurrentNumeric(string);
            }
            break;
        }
    }
}

- (IBAction)clickCancel:(UIButton *)sender {
    setStringOnScreen(@"0");
    setStringForCalculate(@"0");
    setCurrentNumeric(@"");
    setCurrentOperator(@"");
    setTextField;
    [self textFieldSize];
    self.isReset = YES;
}

- (IBAction)clickDot:(UIButton *)sender {
    BOOL canAppendDot = YES;
    if ([self.textField.text isEqualToString:@""]) {
        setStringOnScreen(@"0");
        setCurrentNumeric(@"0");
        setStringForCalculate(@"0");
    }
    if ([self.textField.text isEqualToString:@"0"]) {
        setStringOnScreen(@"0");
        setCurrentNumeric(@"0");
        setStringForCalculate(@"0");
    } else if ([self isLastCharactorEqualOperatorSymbol]){
        canAppendDot = NO;
    } else {
        NSRange range = NSMakeRange(0, 1);
        for (int i = 0; i < self.currentNumeric.length; i++) {
            range.location = i;
            NSString *contentString = [self.currentNumeric substringWithRange:range];
            if ([contentString isEqualToString:@"."])
                canAppendDot = NO;
        }
    }
    if (canAppendDot) {
        [self getTextSizeOnScreen];
        [self textFieldSize];
        [self.stringOnScreen appendString:@"."];
        [self.stringForCalculate appendString:@"."];
        [self.currentNumeric appendString:@"."];
        setTextField;
    }
}

- (IBAction)clickAnswer:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"OK"]) {
        if ([self.textField.text isEqualToString:@"0"])
            setCurrentNumeric(@"0");
        [self getCurrentNumeric];
        [self.delegate getCalculatResult:[NSString stringWithFormat:@"%.0f",[self.currentNumeric doubleValue]]];
        [self removeCalculator];
    } else if ([sender.titleLabel.text isEqualToString:@"="]) {
        NSString *expressionString = @"1.0*";
        expressionString = [expressionString stringByAppendingString:[NSString stringWithString:self.stringForCalculate]];
        NSString *lastCharactor = [expressionString substringWithRange:NSMakeRange(expressionString.length-1, 1)];
        if ([lastCharactor isEqualToString:@"+"] ||
            [lastCharactor isEqualToString:@"-"] ||
            [lastCharactor isEqualToString:@"*"] ||
            [lastCharactor isEqualToString:@"/"]) {
            [self clickBack:nil];
            return;
        }
        NSExpression *expression = [NSExpression expressionWithFormat:expressionString];
        id result = [expression expressionValueWithObject:nil context:nil];
        if ([result doubleValue] > resultMaxValue) {
            [sender setTitle:@"=" forState:UIControlStateNormal];
            setStringOnScreen(@"0");
            setStringForCalculate(@"0");
            setCurrentNumeric(@"0");
            setCurrentOperator(@"");
            self.textField.text = @"Error";
            self.isReset = YES;
        } else {
            [sender setTitle:@"OK" forState:UIControlStateNormal];
            NSString *answerStringUnformat = [NSString stringWithFormat:@"%@",result];
            self.textField.text = [self thousandSeparatorFormat:[self stringToNumber:answerStringUnformat]];
            setStringOnScreen(self.textField.text);
            setStringForCalculate(answerStringUnformat);
            setCurrentNumeric(answerStringUnformat);
            setCurrentOperator(@"");
            self.isReset = YES;
        }
        [self textFieldSize];
    }
}

- (NSString *)thousandSeparatorFormat:(NSNumber *)number {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setGroupingSeparator:@","];
    [numberFormatter setGroupingSize:3];
    [numberFormatter setUsesGroupingSeparator:YES];
    [numberFormatter setDecimalSeparator:@"."];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    NSString *formatedString = [numberFormatter stringFromNumber:number];
//    [numberFormatter release];
    return formatedString;
}

- (void)removeCalculator {
    [UIView beginAnimations:@"close" context:nil];
    [UIView setAnimationDelegate:self];
    self.calculatorView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    self.calculatorView.alpha = 1;
    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"close"]) {
        if (finished) {
            [UIView beginAnimations:@"closeDone" context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelegate:self];
            self.calculatorView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.calculatorView.alpha = 0;
            [UIView commitAnimations];
        }
    } else if ([animationID isEqualToString:@"closeDone"]) {
        [self removeFromSuperview];
    }  else if ([animationID isEqualToString:@"PopupCalculator"]) {
        [UIView beginAnimations:nil context:nil];
        self.calculatorView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.calculatorView.alpha = 1;
        [UIView commitAnimations];
    }
}

- (BOOL)isLastCharactorEqualOperatorSymbol {
    BOOL result;
    NSRange range = NSMakeRange(0, 1);
    range.location = self.stringOnScreen.length-1;
    result = ([[self.stringOnScreen substringWithRange:range] isEqualToString:@"+"] ||
              [[self.stringOnScreen substringWithRange:range] isEqualToString:@"-"] ||
              [[self.stringOnScreen substringWithRange:range] isEqualToString:@"x"] ||
              [[self.stringOnScreen substringWithRange:range] isEqualToString:@"÷"]);
    return result;
}

- (void)determindAnswerButtonTitle {
    NSCharacterSet *cs= [NSCharacterSet characterSetWithCharactersInString:@"+-x÷"];
    if ([self.textField.text rangeOfCharacterFromSet:cs].location == NSNotFound) {
        [self.answerButton setTitle:@"OK" forState:UIControlStateNormal];
        return;
    }
    
    if ([self.stringOnScreen isEqualToString:@""]) {
        return;
    }
    if ([[self.stringOnScreen substringToIndex:1] isEqualToString:@"-"]) {
        [self.answerButton setTitle:@"OK" forState:UIControlStateNormal];
        for (int i=1; i<self.stringOnScreen.length; i++) {
            if ([[self.stringOnScreen substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"+"] ||
                [[self.stringOnScreen substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"-"] ||
                [[self.stringOnScreen substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"x"] ||
                [[self.stringOnScreen substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"÷"]) {
                [self.answerButton setTitle:@"=" forState:UIControlStateNormal];
            }
        }
    }
    
    
}
@end
