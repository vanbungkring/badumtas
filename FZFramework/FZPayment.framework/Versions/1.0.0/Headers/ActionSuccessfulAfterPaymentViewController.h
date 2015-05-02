//
//  ActionSuccessfulAfterPaymentViewController.h
//  iMobey
//
//  Created by Matthieu Barile on 16/09/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <FZBlackBox/ActionSuccessfulAfterPaymentViewControllerBB.h>

//Delegate
#import <FZBlackBox/ActionSuccessfullDelegate.h>

@class ActionSuccessfulAfterPaymentViewController;



@interface ActionSuccessfulAfterPaymentViewController : ActionSuccessfulAfterPaymentViewControllerBB

- (id)initWithNbOfGeneratedPoints:(NSInteger)nbOfGeneratedPoints nbOfPointsToGenerateACoupon:(NSInteger)nbOfPointsToGenerateACoupon nbOfPointsOnTheLoyaltyCard:(NSInteger)nbOfPointsOnTheLoyaltyCard amountOfACoupon:(double)amountOfACoupon;

@property (nonatomic, assign) id<ActionSuccessfullDelegate> delegate;



@end
