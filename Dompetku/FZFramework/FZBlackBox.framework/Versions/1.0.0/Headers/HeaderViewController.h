//
//  UICustomHeaderViewController.h
//  iMobey
//
//  Created by Olivier Demolliens on 09/09/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GenericViewController.h"

//Menu
@class PPRevealSideViewController;

//Navigation
@class CustomNavigationViewController;

@interface HeaderViewController : GenericViewController
{
    
}

@property(nonatomic,retain) NSString *titleHeader;
@property(nonatomic,retain) UIColor *titleColor;
@property(nonatomic,retain) UIColor *backgroundColor;
@property(nonatomic,retain) UINavigationController *customNavigationController;

- (PPRevealSideViewController*)revealSideViewController __attribute__((deprecated));

- (void)back __attribute__((deprecated));
- (void)backToRootWithAnimation:(BOOL)animated __attribute__((deprecated));

- (void)pushFromRootController:(UIViewController*)controller  animated:(BOOL)animated __attribute__((deprecated));
- (void)popFromRootViewController __attribute__((deprecated));
- (void)pushFromSideViewController:(UIViewController*)controller  animated:(BOOL)animated __attribute__((deprecated));

- (void)pushFromRootControllerWithCustomHeaderController:(HeaderViewController*)controller andMode:(CustomNavigationMode)mode animated:(BOOL)animated __attribute__((deprecated));
- (void)pushFromSideViewControllerWithCustomHeaderController:(HeaderViewController*)controller andMode:(CustomNavigationMode)mode animated:(BOOL)animated __attribute__((deprecated));
- (void)pushFromCustomNavigationControllerWithCustomHeaderController:(HeaderViewController*)controller andMode:(CustomNavigationMode)mode animated:(BOOL)animated __attribute__((deprecated));
- (void)pushFromRootControllerWithCustomHeaderControllerAndNoManage:(HeaderViewController*)controller andMode:(CustomNavigationMode)mode animated:(BOOL)animated __attribute__((deprecated));

- (void)dismissController __attribute__((deprecated));
- (void)dismissControllerWithCustomNavigationController __attribute__((deprecated));
- (void) dismissActionViewController:(UIViewController *)aViewController __attribute__((deprecated));
- (void) dismissActionViewController:(UIViewController *)aViewController andPopToRootViewControllerAnimated:(BOOL)animated __attribute__((deprecated));

- (void) presentPopupViewController: (UIViewController *) aViewController __attribute__((deprecated));


- (void) presentActionViewControllerWithTitle:(NSString*)titleView andBackgroundColor:(UIColor *)backgroundColor andArrowImage:(UIImage *)image andDelegate:(UIViewController*)delegate withCorrectiveDelta:(CGFloat)delta __attribute__((deprecated));
-(void) presentActionViewControllerWithTitle:(NSString*)title andBackgroundColor:(UIColor *)aBackgroundColor andArrowImage:(UIImage *)image andDelegate:(UIViewController*)delegate withCorrectiveDelta:(CGFloat)delta andError:(Error *) anError __attribute__((deprecated));
- (void) presentActionViewControllerWithTitle:(NSString*)titleView andBackgroundColor:(UIColor *)aBackgroundColor andBackgroundImageName:(NSString*)bgdImageName inBundleName:(FZBundleName)aBundleName andArrowImage:(UIImage*) aImage andDelegate:(UIViewController*)delegate withCorrectiveDelta:(CGFloat)delta __attribute__((deprecated));

- (void) presentActionViewControllerWithNbOfGeneratedPoints:(NSInteger)nbOfGeneratedPoints nbOfPointsToGenerateACoupon:(NSInteger)nbOfPointsToGenerateACoupon nbOfPointsOnTheLoyaltyCard:(NSInteger)nbOfPointsOnTheLoyaltyCard amountOfACoupon:(double)amountOfACoupon andDelegate:(UIViewController*)delegate __attribute__((deprecated));
- (void) presentActionViewControllerWithNbOfGeneratedPoints:(NSInteger)nbOfGeneratedPoints nbOfPointsToGenerateACoupon:(NSInteger)nbOfPointsToGenerateACoupon nbOfPointsOnTheLoyaltyCard:(NSInteger)nbOfPointsOnTheLoyaltyCard amountOfACoupon:(double)amountOfACoupon andDelegate:(UIViewController*)delegate andCustomArrow:(NSString *)customArrow __attribute__((deprecated));

- (void)presentController:(UIViewController*)controller __attribute__((deprecated));
- (void) presentActionViewController: (UIViewController *) aViewController withCorrectiveDelta:(CGFloat)delta andNavigationController:(UINavigationController *) navController __attribute__((deprecated));

- (void)presentControllerWithNavigationController:(HeaderViewController*)controller andMode:(CustomNavigationMode)mode __attribute__((deprecated));

- (void)hideCloseButton;
- (void)showCloseButton;

- (BOOL)isPaymentViewControllerVisible;


- (void)didClose:(CustomNavigationHeaderViewController *)controller;
- (void)didGoBack:(CustomNavigationHeaderViewController *)controller;
- (void)leave3DSProcess;

@end
