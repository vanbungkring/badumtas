//
//  YourLoyaltyProgramsViewController.h
//  iMobey
//
//  Created by Matthieu Barile on 14/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FZBlackBox/GenericViewController.h>


@protocol YourLoyaltyProgramsViewControllerDelegate <NSObject>

- (void)setSgmCtrlProgramsToYourProgramsAndShowYourProgramsAndRefreshPrograms:(BOOL)needRefresh;

@end

@interface YourLoyaltyProgramsViewController : GenericViewController
{
    
}

@property (nonatomic, assign) id<YourLoyaltyProgramsViewControllerDelegate> delegate;



@end
