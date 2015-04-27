//
//  FlashizButtonRiddleAnimation.h
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 19/12/13.
//  Copyright (c) 2013 Flashiz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kFlashizRiddleAnimationDirectionExpand,
    kFlashizRiddleAnimationDirectionContract
} kFlashizRiddleAnimationDirection;

@interface FlashizButtonRiddleAnimation : UIButton

+ (void)forceLinkerLoad_;

- (void)startWithNumberOfRiddles:(NSInteger)numberOfRiddles direction:(kFlashizRiddleAnimationDirection)direction color:(UIColor *)color;
- (void)stopRiddles;

@end
