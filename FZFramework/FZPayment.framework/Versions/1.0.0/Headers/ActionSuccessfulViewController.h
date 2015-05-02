//
//  RefillValidateViewController.h
//  iMobey
//
//  Created by Yvan Moté on 20/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <FZBlackBox/ActionSuccessfulAfterPaymentViewControllerBB.h>

//Delegate
#import <FZBlackBox/ActionSuccessfullDelegate.h>


@interface ActionSuccessfulViewController : ActionSuccessfulAfterPaymentViewControllerBB
{
    
}


- (id)initWithTitle:(NSString*)title andBackgroundColor:(UIColor *)backgroundColor andArrowImage:(UIImage *)image;
- (id)initWithTitle:(NSString *)titleView andBackgroundColor:(UIColor *)backgroundColor andArrowImage:(UIImage*)image andBackgroundImage:(NSString *)bgdImageName inBundleName:(FZBundleName)aBundleName;

- (id)initWithTitle:(NSString*)titleView andBackgroundColor:(UIColor *)backgroundColor andArrowImage:(UIImage *)image andError:(Error *) anError;
- (id)initWithTitle:(NSString *)titleView andBackgroundColor:(UIColor *)backgroundColor andArrowImage:(UIImage*)image andBackgroundImage:(NSString *)bgdImageName inBundleName:(FZBundleName)aBundleName andError:(Error *) anError;


@property (assign, nonatomic) BOOL comeFromForgottenPassword;
@property (nonatomic,retain) NSString * btnImageCenterName;

- (void)forceHideBtnImageCenter;
- (IBAction)validateAction:(id)sender;

@end


