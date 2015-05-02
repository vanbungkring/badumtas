//
//  AutoCloseWindow.h
//  FZBlackBox
//
//  Created by Matthieu Barile on 19/09/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AutoCloseWindow : UIWindow

+ (void)startCloseTimer;
+ (void)stopCloseTimer;
+ (void)startCloseTimer3DSSession;
+ (void)stopCloseTimer3DSSession;

- (void)showPinCodeController;

- (void)startTimer;
- (void)stopTimer;
- (void)startTimer3DSSession;
- (void)stopTimer3DSSession;

@end