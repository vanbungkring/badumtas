//
//  FZFlashizTemplateFonts.m
//  FZApp
//
//  Created by Olivier Demolliens on 4/17/14.
//  Copyright (c) 2014 flashiz. All rights reserved.
//

#import "FZFlashizTemplateFonts.h"

#import <FZAPI/FZFilesEnum.h>

@implementation FZFlashizTemplateFonts


#pragma mark Files name

- (NSString*) futurConFileName
{
    return @"FuturCon";
}

- (NSString*) futurConLigFileName
{
    return @"FuturConLig";
}

- (NSString*) helveticaFileName
{
    return @"HelveticaNeueLTCom-Lt";
}

- (NSString*) helveticaBoldFileName
{
    return @"HelveticaNeueLTCom-Bd";
}


#pragma mark Fonts name


- (NSString*) futurConName
{
    return @"FuturaFlashiz-MediumCondensed";
}

- (NSString*) futurConLigName
{
    return @"FuturaFlashiz-LightCondensed";
}

- (NSString*) helveticaName
{
    return @"HelveticaNeueLTCom-Lt";
}

- (NSString*) helveticaBoldName
{
    return @"HelveticaNeueLTCom-Bd";
}

- (FZBundleName) bundleType
{
    return FZBundleBlackBox;
}

@end
