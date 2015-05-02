//
//  AllLoyaltyProgramsNavBarOpenedViewController.h
//  iMobey
//
//  Created by Matthieu Barile on 16/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AllLoyaltyProgramsNavBarOpenedViewControllerDelegate <NSObject>

- (void)showNearProgramsOpened;
- (void)showSuggestedProgramsOpened;
- (void)searchInAllPrograms:(id)sender;

@end

@interface AllLoyaltyProgramsNavBarOpenedViewController : UIViewController
{
    
}

@property (assign, nonatomic) id<AllLoyaltyProgramsNavBarOpenedViewControllerDelegate> delegate;


- (id)init;


@end
