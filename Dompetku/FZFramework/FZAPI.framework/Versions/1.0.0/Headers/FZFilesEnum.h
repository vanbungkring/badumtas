//
//  FZFilesEnum.h
//  FZBlackBox
//
//  Created by Olivier Demolliens on 4/17/14.
//  Copyright (c) 2014 FLASHiZ. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark Enum

/*
 * Don't forget define NSString value in .m -> BundleHelper - retrieveBundleName:
 */
typedef enum {
    FZBundleAPI,
    FZBundleBlackBox,
    FZBundleCoreUI,
    FZBundleExtLibs,
    FZBundleP2P,
    FZBundlePayment,
    FZBundleRewards,
    FZBundleSDK,
    FZBundleBankSDK,
    FZBundleLeclerc,
    FZBundleFlashiz,
    FZBundleNone
} FZBundleName;

/*
 * Don't forget define NSString value in .m -> BundleHelper - retrieveType:
 */
typedef enum {
    FZBundle,
    FZPng,
    FZNib,
    FZFont,
    FZStrings,
    FZSound
} FZFileType;


@interface FZFilesEnum : NSObject


@end
