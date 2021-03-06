//
//  ODDeviceUtil.h
//  ostalgo
//
//  Created by Olivier Demolliens on 30/04/11.
//  Copyright 2010 company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODDeviceUtil : NSObject

typedef enum {
    ODDeviceModeliPhoneSimulator,
    ODDeviceModeliPhone3GS,
    ODDeviceModeliPhone4,
    ODDeviceModeliPhone4S,
    ODDeviceModeliPhone5,
    ODDeviceModeliPhone5C,
    ODDeviceModeliPhone5S
} ODDeviceModel;

typedef enum {
    ODDeviceScreenSize3_5inch,
    ODDeviceScreenSize4inch
} ODDeviceScreenSize;

+(float)deviceSystemVersion;
+(BOOL)isAnIphoneOrIpod;
+(BOOL)isAnIpad;
+(BOOL)isRetina;
+(BOOL)isAnIphoneFive;
+(ODDeviceModel)currentDeviceModel;
+ (ODDeviceScreenSize)currentDeviceScreenSize;
+(NSString *)currentDeviceModelName;
+(NSString*)regionFormat;
+(NSString*)userLanguage;

@end
