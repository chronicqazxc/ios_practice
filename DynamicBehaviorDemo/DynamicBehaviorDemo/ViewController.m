//
//  ViewController.m
//  DynamicAnimationTest
//
//  Created by Wayne on 1/29/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    CALayer *buttonLayer;
    CMDeviceMotion *deviceMotion;
    CMMotionManager *motionManager;
    UIDevice *device;
    CMRotationMatrix rotationMatrix;
    CMAttitude *attitude;
}
// Store dynamic behavior
@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) UIAttachmentBehavior *attachBehavior;
@property (nonatomic) UIGravityBehavior *gravityBehavior;
@property (nonatomic) UICollisionBehavior *collisionBehavior;
@property (nonatomic) UIPushBehavior *pushBehavior;
@property (nonatomic) UISnapBehavior *snapBehavior;
-(void) initAttachment;
-(void) initGravity:(float)rotate;
-(void) initCollision;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Initialize UIDynamicAnimator and setup which view will play the animation.
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // 1.Initialize attachBehavior and change loaction by pan gesture
    [self initAttachment];
    
    // 2.Initialize gravityBehavior by CMMotionManager
    
    // 3.Initialize collisionBehavior
    [self initCollision];
    
    // 4.Initialize push behavior by touch began
    
    // 5.Initialize snap behavior by tap gesture

    // Set image of gravityItem
    UIGraphicsBeginImageContext(_gravityItem.frame.size);
    [[UIImage imageNamed:@"bball.png"]drawInRect:_gravityItem.bounds];
    UIImage *bball = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _gravityItem.backgroundColor = [[UIColor alloc] initWithPatternImage:bball];
    
    // Set image of attachmentItem
    UIGraphicsBeginImageContext(_redAnchor.frame.size);
    [[UIImage imageNamed:@"magnet.png"]drawInRect:_redAnchor.bounds];
    UIImage *anchorMagnet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _redAnchor.backgroundColor = [[UIColor alloc] initWithPatternImage:anchorMagnet];
    
    UIGraphicsBeginImageContext(_attachmentItem.frame.size);
    [[UIImage imageNamed:@"magnet.png"]drawInRect:_attachmentItem.bounds];
    UIImage *attachmentMagnet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _attachmentItem.backgroundColor = [[UIColor alloc] initWithPatternImage:attachmentMagnet];
    
    // Set image of snapItem
    UIGraphicsBeginImageContext(_snapItem.frame.size);
    [[UIImage imageNamed:@"NyanCat.png"]drawInRect:_snapItem.bounds];
    UIImage *nyanCat = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _snapItem.backgroundColor = [[UIColor alloc] initWithPatternImage:nyanCat];
    
    // Move ball by motion
    motionManager = [[CMMotionManager alloc] init];
    motionManager.deviceMotionUpdateInterval = 1.0f/60.0f;
    [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        [attitude multiplyByInverseOfAttitude:motion.attitude];
        rotationMatrix = attitude.rotationMatrix;
        [self initGravity:motion.attitude.yaw];
    }];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initAttachment{
    UIOffset hookPosition = UIOffsetMake(-25,-25);
    _attachBehavior = [[UIAttachmentBehavior alloc] initWithItem:_attachmentItem offsetFromCenter: hookPosition attachedToAnchor:CGPointMake(50,50)];
    [_animator addBehavior:_attachBehavior];
}

-(void) initGravity:(float)rotate{
    [_animator removeBehavior: _gravityBehavior];
    _gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[_gravityItem]];
    [_gravityBehavior setAngle:rotate magnitude:0.8];
    [_animator addBehavior: _gravityBehavior];
}

-(void) initCollision{
    _collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[_gravityItem]];
    // Let bound of the view that animator reference to be the boundary that gravityItem can move
    _collisionBehavior.translatesReferenceBoundsIntoBoundary = 1;
    
    [_animator addBehavior:_collisionBehavior];
}

- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)sender {
    [_attachBehavior setAnchorPoint:[sender locationInView:self.view]];
    _redAnchor.center = _attachBehavior.anchorPoint;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if(CGRectContainsPoint(_gravityItem.frame,point)){
        [_animator removeBehavior:_pushBehavior];
        _pushBehavior = [[UIPushBehavior alloc] initWithItems:@[_gravityItem] mode:UIPushBehaviorModeInstantaneous];
        _pushBehavior.magnitude = 15;
        _pushBehavior.angle = 2*M_PI;
        [_animator addBehavior:_pushBehavior];
    }
}

- (IBAction)handleTapGesture:(UITapGestureRecognizer *)sender {
    [_animator removeBehavior:_snapBehavior];
    CGPoint point = [sender locationInView:self.view];
    _snapBehavior = [[UISnapBehavior alloc] initWithItem:_snapItem snapToPoint:point];
    _snapBehavior.damping = 0.5;
    [_animator addBehavior:_snapBehavior];
}
@end
