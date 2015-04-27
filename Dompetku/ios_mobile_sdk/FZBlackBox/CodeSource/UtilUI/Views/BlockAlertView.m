//
//  BlockAlertView.m
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 17/12/13.
//  Copyright (c) 2013 Flashiz. All rights reserved.
//

#import "BlockAlertView.h"

@interface BlockAlertView ()

@property (nonatomic, copy) UIAlertViewHandler completionHandler;

@end



@implementation BlockAlertView

/**
 * Shows the receiver alert with the given handler.
 *
 * @param handler The handler that will be invoked in user interaction.
 */
- (void)showWithHandler:(UIAlertViewHandler)handler {
    [self setCompletionHandler:handler];
    
    [self setDelegate:self];
    [self show];
}

#pragma mark - UIAlertViewDelegate

/*
 * Sent to the delegate when the user clicks a button on an alert view.
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (_completionHandler != nil) {
        
        _completionHandler(alertView, buttonIndex);
    }
}

@end
