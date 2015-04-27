//
//  CustomTabBarViewController.h
//  iMobey
//
//  Created by Olivier Demolliens on 09/09/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RewardsHomeViewController;

// Generic Controller
#import "GenericViewController.h"

static const NSInteger indexButtonTransfert = 0;
static const NSInteger indexButtonPayment = 1;
static const NSInteger indexButtonRewards = 2;

@protocol CustomTabBarViewControllerDelegate <NSObject>

- (void)didClose:(UIViewController *)viewController;

@end

@interface CustomTabBarViewController : GenericViewController
{
    
}

@property (assign, nonatomic) id<CustomTabBarViewControllerDelegate> delegate;

//TabBar custom
@property (assign, nonatomic) int lastIndex;

@property (retain, nonatomic) RewardsHomeViewController *rewardsHomeViewController;

@property (retain, nonatomic) IBOutlet UIView *viewShowed;

- (NSInteger)currentSelectedIndex;
- (void)selectTabAtIndex:(NSInteger)index;
- (void)setCustomTabBarForProfessional;
- (void)setCustomTabBarForClient;
- (void)loadRewards;
- (void)selectNewIndex:(int)index;
- (void)forceRiddles;
- (void)deallocRewards;

@end
