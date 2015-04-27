//
//  ODDeviceUtil.m
//  ostalgo
//
//  Created by Olivier Demolliens on 30/04/11.
//  Copyright 2010 company. All rights reserved.
//

#import "ODDeviceUtil.h"

#include <sys/sysctl.h>

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@implementation ODDeviceUtil

+(BOOL)isAnIphoneFive
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

+ (ODDeviceModel)currentDeviceModel {
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    ODDeviceModel deviceModel = ODDeviceModeliPhoneSimulator;
    
    if([platform isEqualToString:@"iPhone2,1"]) {
        deviceModel = ODDeviceModeliPhone3GS;
    }
    else if([platform isEqualToString:@"iPhone3,1"] || [platform isEqualToString:@"iPhone3,2"] || [platform isEqualToString:@"iPhone3,3"]) {
        deviceModel = ODDeviceModeliPhone4;
    }
    else if([platform isEqualToString:@"iPhone4,1"]) {
        deviceModel = ODDeviceModeliPhone4S;
    }
    else if([platform isEqualToString:@"iPhone5,1"] || [platform isEqualToString:@"iPhone5,2"]){
        deviceModel = ODDeviceModeliPhone5;
    }
    else if([platform hasPrefix:@"iPhone5,3"] || [platform hasPrefix:@"iPhone5,4"]) {
        deviceModel = ODDeviceModeliPhone5C;
    }
    else if([platform hasPrefix:@"iPhone6,1"] || [platform hasPrefix:@"iPhone6,2"]) {
        deviceModel = ODDeviceModeliPhone5S;
    }
    
    return deviceModel;
}

+ (ODDeviceScreenSize)currentDeviceScreenSize {
    CGFloat screenSize = [[UIScreen mainScreen]bounds].size.height;
    
    if(screenSize > 480) {
        return ODDeviceScreenSize4inch;
    } else {
        return ODDeviceScreenSize3_5inch;
    }
}

+(NSString *)currentDeviceModelName {
    ODDeviceModel currentDeviceModel = [ODDeviceUtil currentDeviceModel];
    
    NSString *modelName = @"";
    
    switch (currentDeviceModel) {
        case ODDeviceModeliPhone3GS:
            modelName = @"iPhone 3GS";
            break;
        case ODDeviceModeliPhone4:
            modelName = @"iPhone 4";
            break;
        case ODDeviceModeliPhone4S:
            modelName = @"iPhone 4S";
            break;
        case ODDeviceModeliPhone5:
            modelName = @"iPhone 5";
            break;
        case ODDeviceModeliPhone5C:
            modelName = @"iPhone 5C";
            break;
        case ODDeviceModeliPhone5S:
            modelName = @"iPhone 5S";
            break;
        default:
            modelName = @"iPhone";
            break;
    }
    
    return modelName;
}

+(float)deviceSystemVersion
{
    return [[[UIDevice currentDevice]systemVersion]floatValue];
}

+(BOOL)isAnIphoneOrIpod
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return YES;
    }else{
        return NO;
    }
}

+(BOOL)isRetina
{
    BOOL isRetina = NO;
    
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        CGFloat scale = [[UIScreen mainScreen] scale];
        if (scale > 1.0) {
            isRetina = YES;
        }
    }
    
    return isRetina;
}

+(BOOL)isAnIpad
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }else{
        return NO;
    }
}

+(NSString*)regionFormat
{
    return [NSString stringWithFormat:@"%@",[[NSLocale currentLocale] localeIdentifier]];
}


+(NSString*)userLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    return [NSString stringWithFormat:@"%@",[languages objectAtIndex:0]];
}

@end
