//
//  AnimationHelper.h
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 19/02/14.
//  Copyright (c) 2014 Flashiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CAAnimation;
@class UITextField;

@interface AnimationHelper : NSObject

+ (CAAnimation *)shakeAnimationForTextField:(UITextField *)textField;

@end
