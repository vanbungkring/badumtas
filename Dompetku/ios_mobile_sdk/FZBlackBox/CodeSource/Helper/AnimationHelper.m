//
//  AnimationHelper.m
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 19/02/14.
//  Copyright (c) 2014 Flashiz. All rights reserved.
//

#import "AnimationHelper.h"

#import <UIKit/UIKit.h>

@implementation AnimationHelper

+ (CAAnimation *)shakeAnimationForTextField:(UITextField *)textField {
    CGPoint position = [[textField layer] position];
    
    NSMutableArray *animationValues = [[NSMutableArray alloc] init];
    
    for(CGFloat i=12.0;i>=0;i-=3.0) {
        [animationValues addObject:[NSNumber numberWithFloat:position.x-i]];
        [animationValues addObject:[NSNumber numberWithFloat:position.x+i]];
    }
    
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    [keyFrameAnimation setDuration:0.8];
    [keyFrameAnimation setValues:animationValues];
    
    [animationValues release];
    
    return keyFrameAnimation;
}

@end
