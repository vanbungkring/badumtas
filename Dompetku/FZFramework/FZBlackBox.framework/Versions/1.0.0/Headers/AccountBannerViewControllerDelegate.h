//
//  AccountBannerViewControllerDelegate.h
//  FZBlackBox
//
//  Created by OlivierDemolliens on 6/5/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AccountBannerViewController;

@protocol AccountBannerViewControllerDelegate <NSObject>

- (void)goToOrCloseHistoric;

@optional

- (void)willTakePicture:(AccountBannerViewController *)bannerViewController;
- (void)didCancelTakePicture:(AccountBannerViewController *)bannerViewController;
- (void)didTakePicture:(AccountBannerViewController *)bannerViewController;
- (void)showChoice:(AccountBannerViewController *)bannerViewController;

@end
