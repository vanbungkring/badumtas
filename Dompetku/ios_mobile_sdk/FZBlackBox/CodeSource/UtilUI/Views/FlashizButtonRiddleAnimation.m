//
//  FlashizButtonRiddleAnimation.m
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 19/12/13.
//  Copyright (c) 2013 Flashiz. All rights reserved.
//

#import "FlashizButtonRiddleAnimation.h"

static CGFloat const duration = 3.0f;
static CGFloat const scaleFactor = 2.0f;

@implementation FlashizButtonRiddleAnimation {
    NSMutableArray *circleLayers_;
}

+ (void)forceLinkerLoad_ {
    
}

- (void)startWithNumberOfRiddles:(NSInteger)numberOfRiddles direction:(kFlashizRiddleAnimationDirection)direction color:(UIColor *)color{
    // ensure all animations are off
    [self stopRiddles];
    
    BOOL contracting = (direction==kFlashizRiddleAnimationDirectionContract);
    
    
    CFTimeInterval cti = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    for (int i = 0; i < numberOfRiddles; i++) {
        [self startRiddleWithParams:[NSArray arrayWithObjects:[NSNumber numberWithBool:contracting],color,[NSNumber numberWithDouble:(cti + i*duration/numberOfRiddles)],nil]];
    }
}

- (void)stopRiddles{
    
    [circleLayers_ enumerateObjectsUsingBlock:^(CALayer *circleLayer, NSUInteger idx, BOOL *stop) {
        [circleLayer removeAllAnimations];
        [circleLayer removeFromSuperlayer];
    }];
    
    [circleLayers_ removeAllObjects];
}

- (void)startRiddleWithParams:(NSArray *)params{
    
    // read params from call
    NSNumber *contracting = [params objectAtIndex:0];
    UIColor *color = [params objectAtIndex:1];
    CFTimeInterval delay = [[params objectAtIndex:2] doubleValue];
    
    // set direction based on boolean
    kFlashizRiddleAnimationDirection direction;
    if ([contracting boolValue]){
        direction = kFlashizRiddleAnimationDirectionContract;
    } else {
        direction = kFlashizRiddleAnimationDirectionExpand;
    }
    
    // create circle
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    
    CGPoint circleAnchor = CGPointMake(CGRectGetMidX(self.bounds) / CGRectGetMaxX(self.bounds),
                                       CGRectGetMidY(self.bounds) / CGRectGetMaxY(self.bounds));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    circleLayer.path = [path CGPath];
    circleLayer.strokeColor = [color CGColor];
    circleLayer.fillColor = [[UIColor colorWithWhite:1.0 alpha:0.2] CGColor];
    circleLayer.lineWidth = 1.0;
    circleLayer.anchorPoint = circleAnchor;
    circleLayer.frame = self.bounds;
    circleLayer.name = @"circle";
    
    if(nil==circleLayers_) {
        circleLayers_ = [[NSMutableArray alloc] init];
    }

    [circleLayers_ addObject:circleLayer];
    
    [[self layer] insertSublayer:circleLayer atIndex:0];
    
    // Configure animations
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.beginTime = delay;
    animationGroup.duration = duration;
    animationGroup.repeatCount = HUGE_VALF;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    // scale animation
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    switch (direction) {
        case kFlashizRiddleAnimationDirectionExpand:
            scale.fromValue = [circleLayer valueForKeyPath:@"transform.scale"];
            scale.toValue   = @(scaleFactor);
            break;
        case kFlashizRiddleAnimationDirectionContract:
            scale.toValue = [circleLayer valueForKeyPath:@"transform.scale"];
            scale.fromValue   = @(scaleFactor);
            break;
        default:
            break;
    }
    
    [circleLayer setValue:scale.toValue forKeyPath:scale.keyPath];
    
    // preserve line width animation
    CABasicAnimation *width = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    
    switch (direction) {
        case kFlashizRiddleAnimationDirectionExpand:
            width.fromValue = @(1.0f);
            width.toValue   = @(0.01f);
            break;
        case kFlashizRiddleAnimationDirectionContract:
            width.fromValue = @(0.01f);
            width.toValue   = @(1.0f);
            break;
        default:
            break;
    }
    
    [circleLayer setValue:width.toValue forKeyPath:width.keyPath];
    
    // fade animation
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    switch (direction) {
        case kFlashizRiddleAnimationDirectionExpand:
            fade.fromValue = @(0.8f);
            fade.toValue   = @(0.0f);
            break;
        case kFlashizRiddleAnimationDirectionContract:
            fade.fromValue = @(0.0f);
            fade.toValue   = @(0.8f);
            break;
        default:
            break;
    }
    
    [circleLayer setValue:fade.toValue forKeyPath:fade.keyPath];
    
    [animationGroup setAnimations:[NSArray arrayWithObjects:scale, width, fade, nil]];
    
    // Add the animations to the circle
    [circleLayer addAnimation:animationGroup forKey:@"animateCircles1234"];
}

- (void)dealloc {
    
    [circleLayers_ release];
    circleLayers_ = nil;
    
    [super dealloc];
}

@end
