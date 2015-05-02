//
//  CustomNavigationViewController.h
//  iMobey
//
//  Created by Olivier Demolliens on 10/09/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <UIKit/UIKit.h>

//Util
#import "CustomNavigationHeaderViewController.h"
#import <FZBlackBox/GenericViewController.h>

@class HeaderViewController;

@interface CustomNavigationViewController : GenericViewController

@property (assign, nonatomic) BOOL manageViewCycleLife;

//Content
@property (retain, nonatomic) HeaderViewController *controller;
@property (assign, nonatomic) CustomNavigationMode mode;
@property (readonly, nonatomic) CustomNavigationHeaderViewController *navigController;

//View
@property (retain, nonatomic) IBOutlet UIView *viewContent;
@property (retain, nonatomic) IBOutlet UIView *viewHeader;

- (id)initWithController:(HeaderViewController*)controller andMode:(CustomNavigationMode)mode;

@end

@protocol CustomNavigationViewControllerAction <NSObject>

- (void)didClose:(CustomNavigationViewController *)controller;
- (void)didGoBack:(CustomNavigationViewController *)controller;

@end