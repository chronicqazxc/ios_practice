//
//  ViewController.m
//  CalculatorDemo
//
//  Created by Wayne on 1/27/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ViewController.h"
#import "Calculator.h"

@interface ViewController ()

@end

@implementation ViewController{
    char            op;
    int             currentNumber;
    BOOL            firstOperand, isNumerator;
    Calculator      *myCalculator;
    NSMutableString *displayString;
    NSString        *identify;
    NSArray         *buttonArray;
    AVAudioPlayer   *buttonBeep;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    buttonArray = @[_button0,
                    _button1,
                    _button2,
                    _button3,
                    _button4,
                    _button5,
                    _button6,
                    _button7,
                    _button8,
                    _button9,
                    _button10,
                    _button11,
                    _button12,
                    _button13,
                    _button14,
                    _button15,
                    _button16];
    int i;
    for (i=0; i<buttonArray.count; i++){
        [buttonArray[i] layer].masksToBounds = YES;
        [buttonArray[i] layer].cornerRadius = 11;
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tile.png"]];
    _display.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"glass.png"]];
    
    buttonBeep = [self setupAudioPlayerWithFile: @"ButtonTap" ofType:@"wav"];
    _display.lineBreakMode = UILineBreakModeWordWrap;
    firstOperand = YES;
    isNumerator = YES;
    displayString = [NSMutableString stringWithCapacity: 40];
    myCalculator = [[Calculator alloc] init];
}

-(IBAction) clickDigit: (UIButton *) sender{
    NSLog(@"sender:%@",sender);
    [self beepPlay];
    int digit = sender.tag;
    [self processDigit: digit];
}

-(void) processDigit: (int) digit{
    currentNumber = currentNumber * 10 + digit;
    [displayString appendString: [NSString stringWithFormat: @"%i", digit]];
    _display.text = displayString;
}

-(void) processOp: (char) theOp{
    [self beepPlay];
    NSString *opStr;
    op = theOp;
    
    switch(theOp){
        case '+':
            opStr = @"+";
            break;
        case '-':
            opStr = @"-";
            break;
        case '*':
            opStr = @"*";
            break;
        case '/':
            opStr = @"÷";
            break;
    }
    
    [self storeFracPart];
    firstOperand = NO;
    isNumerator = YES;
    
    [displayString appendString: opStr];
    _display.text = displayString;
}

-(void) storeFracPart{
    if (firstOperand){
        if (isNumerator){
            myCalculator.operand1.numerator = currentNumber;
            myCalculator.operand1.denominator = 1;
        }else{
            myCalculator.operand1.denominator = currentNumber;
        }
    }else if(isNumerator){
        myCalculator.operand2.numerator = currentNumber;
        myCalculator.operand2.denominator = 1;
    }else{
        myCalculator.operand2.denominator = currentNumber;
        firstOperand = YES;
    }
    currentNumber = 0;
}

-(IBAction) clickOver{
    [self beepPlay];
    [self storeFracPart];
    isNumerator = NO;
    [displayString appendString: @"/"];
    _display.text = displayString;
}

// Arithmetic Operation keys
-(IBAction) clickPlus{
    [self beepPlay];
    [self processOp: '+'];
}

-(IBAction) clickMinus{
    [self beepPlay];
    [self processOp: '-'];
}

-(IBAction) clickMultiply{
    [self beepPlay];
    [self processOp: '*'];
}

-(IBAction) clickDivide{
    [self beepPlay];
    [self processOp: '/'];
}

// Misc. keys
-(IBAction) clickEquals{
    [self beepPlay];
    if(firstOperand == NO){
        [self storeFracPart];
        [myCalculator performOperation: op];
        
        [displayString appendString: @"="];
        [displayString appendString: [myCalculator.accumulator convertToString]];
        _display.text = displayString;
        
        currentNumber = 0;
        isNumerator = YES;
        firstOperand = YES;
        [displayString setString: @""];
    }
}

-(IBAction) clickClear{
    [self beepPlay];
    isNumerator = YES;
    firstOperand = YES;
    currentNumber = 0;
    [myCalculator clear];
    
    [displayString setString: @""];
    _display.text = displayString;
}

-(AVAudioPlayer *)setupAudioPlayerWithFile: (NSString *) file ofType: (NSString *) type{
    NSString *path = [[NSBundle mainBundle] pathForResource: file ofType: type];
    NSURL *url = [NSURL fileURLWithPath: path];
    
    NSError *error;
    
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: url error: &error];
    return audioPlayer;
}

-(void) beepPlay{
    [buttonBeep play];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
