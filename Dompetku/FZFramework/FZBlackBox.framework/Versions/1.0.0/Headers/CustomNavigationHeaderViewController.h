//
//  CustomNavigationViewController.h
//  iMobey
//
//  Created by Olivier Demolliens on 09/09/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomNavigationMode.h"

#import <FZBlackBox/GenericViewController.h>

@class HeaderViewController;
@class CustomNavigationHeaderViewController;

@protocol CustomNavigationHeaderViewControllerDelegate <NSObject>

- (void)didClose:(CustomNavigationHeaderViewController *)controller;
- (void)didGoBack:(CustomNavigationHeaderViewController *)controller;

@end


@interface CustomNavigationHeaderViewController : GenericViewController
{
    
}

@property (assign, nonatomic) CustomNavigationMode mode;
@property (nonatomic, assign) id<CustomNavigationHeaderViewControllerDelegate> delegate;

- (id)initWithMode:(CustomNavigationMode)mode;

-(void)upgradeViewWithController:(HeaderViewController*)controller;

- (void)hideCloseButton;
- (void)showCloseButton;
- (IBAction)back:(id)sender;


@end
