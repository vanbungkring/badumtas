//
//  CircleProgress.m
//  FLASHiZ
//
//  Created by Matthieu Barile on 18/06/13.
//  Copyright (c) 2013 Mobey S.A. All rights reserved.
//

#import "CircleProgress.h"

@interface CircleProgress () {
    
}

//private properties
@property (retain,nonatomic) UIColor* fillColor_;
@property (retain,nonatomic) UIColor* strokeColor_;
@property (nonatomic) CGFloat lineWidth_;
@property (nonatomic) CGFloat radius_;
@property (nonatomic) BOOL revertDirection_;

@end

@implementation CircleProgress
@synthesize delegate;

#pragma mark - Init

- (id)initWithFillColor:(UIColor*)fillColor strokeColor:(UIColor*)strokeColor radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth {
    self = [super init];
    if(self!=nil) {
        self.fillColor_ = fillColor;
        self.strokeColor_ = strokeColor;
        self.radius_ = radius;
        self.lineWidth_ = lineWidth;
        self.revertDirection_ = NO;
    }
    return self;
}

#pragma mark - Draw circle methods


- (void)drawCircleFromAngle:(int)degreStart toAngle:(int)degreEnd withDuration:(CFTimeInterval)animationDuration inLayer:(CALayer*)layer {

    CGRect bounds = [layer bounds];
    CGPoint center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    
    [self drawCircleAtPosition:center fromAngle:degreStart toAngle:degreEnd withDuration:animationDuration];
    [layer addSublayer:self];
}

- (void) drawCircleAtPosition:(CGPoint)center fromAngle:(int)degreStart toAngle:(int)degreEnd withDuration:(CFTimeInterval)animationDuration{
    
    
    [self setFrame:CGRectMake(center.x-_radius_, center.y-_radius_, _radius_*2.0, _radius_*2.0)];
    
    // Make a circular shape
    self.path = [UIBezierPath bezierPathWithArcCenter: CGPointMake(_radius_, _radius_) radius:_radius_ startAngle:M_PI*degreStart/180.0 endAngle:M_PI*degreEnd/180.0 clockwise:!_revertDirection_].CGPath;
    
    // Configure the apperence of the circle
    self.fillColor = _fillColor_.CGColor;
    self.strokeColor = _strokeColor_.CGColor;
    self.lineWidth = _lineWidth_;
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = animationDuration; // "animate over 10 seconds or so.."
    drawAnimation.repeatCount         = 1.0;  // Animate only once..
    drawAnimation.removedOnCompletion = NO;   // Remain stroked after the animation..
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [drawAnimation setDelegate:self];
    
    // Add the animation to the circle
    if(animationDuration > 0){
        
        [self addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    }
}

#pragma mark - Custom parameters

- (void)revertDirection:(BOOL)revert{
    self.revertDirection_ = revert;
}

#pragma mark - Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self progressBarDidLoad];
}

- (void)progressBarDidLoad {
    if([delegate respondsToSelector:@selector(progressBarDidLoad)]) {
        [delegate progressBarDidLoad];
    }
}

@end