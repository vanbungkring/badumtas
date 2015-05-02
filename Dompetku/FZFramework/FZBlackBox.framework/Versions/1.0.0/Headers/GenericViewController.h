//
//  GenericViewController.h
//  iMobey
//
//  Created by Yvan Moté on 30/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <UIKit/UIKit.h>

//TODO: need refactor
#import "CoreMultiTargetManager.h"

//#import "Error.h"

extern int const kAlertViewError;

typedef void(^GenericViewControllerCompletionBlock)(void);

@interface GenericViewController : UIViewController
{
    
}

@property(assign,nonatomic) BOOL canDisplayMenu;

- (UIAlertView *)displayAlertForError:(Error *)error;

- (UIAlertView *)displayAlertForError:(Error *)error completion:(GenericViewControllerCompletionBlock)completion;

- (void)showForUserNotConnectedWaitingViewWithMessage:(NSString *)message;

- (void)showWaitingViewWithMessage:(NSString *)message;

- (void)showWaitingViewWithMessage:(NSString *)message
                  inViewController:(UIViewController *)viewController;

- (void)hideWaitingView;



- (id<CoreMultiTargetManager>)multiTargetManager;

@end
