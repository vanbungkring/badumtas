//
//  FidelitizTermsOfUseViewController.h
//  iMobey
//
//  Created by Matthieu Barile on 13/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FZBlackBox/HeaderViewController.h>

@protocol RewardsTermsOfUseViewControllerDelegate <NSObject>

-(void)acceptCGUAndCreateFidelitizAccount;

@end


@interface RewardsTermsOfUseViewController : HeaderViewController
{
    
}

//public delegates
@property(nonatomic,assign)id<RewardsTermsOfUseViewControllerDelegate> delegate;

@end
