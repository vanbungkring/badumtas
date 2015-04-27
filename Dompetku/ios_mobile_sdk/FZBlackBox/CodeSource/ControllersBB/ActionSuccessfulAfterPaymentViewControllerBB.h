//
//  ActionSuccessfulAfterPaymentViewControllerBB.h
//  FZBlackBox
//
//  Created by OlivierDemolliens on 6/5/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FZBlackBox/GenericViewController.h>
#import <FZBlackBox/ActionSuccessfullDelegate.h>

@interface ActionSuccessfulAfterPaymentViewControllerBB : GenericViewController
{
    
}


- (void)customArrow:(NSString *)imageName;
@property (nonatomic, assign) id<ActionSuccessfullDelegate> delegate;
@end
