//
//  AllLoyaltyProgramsNavBarViewController.h
//  iMobey
//
//  Created by Matthieu Barile on 16/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AllLoyaltyProgramsNavBarViewControllerDelegate <NSObject>

- (void)showNearPrograms;
- (void)showSuggestedPrograms;
- (void)showSearchTextField;

@end

@interface AllLoyaltyProgramsNavBarViewController : UIViewController
{
    
}

- (id)init;


@property (assign, nonatomic) id<AllLoyaltyProgramsNavBarViewControllerDelegate> delegate;

// TODO : why in .h?
@property (retain, nonatomic) IBOutlet UIButton *btnNearPrograms;
@property (retain, nonatomic) IBOutlet UIButton *btnSuggestedPrograms;

@end
