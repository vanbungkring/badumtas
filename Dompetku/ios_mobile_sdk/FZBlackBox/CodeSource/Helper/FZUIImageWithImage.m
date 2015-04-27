//
//  UIImage+FZImage.m
//  FZBlackBox
//
//  Created by Olivier Demolliens on 4/18/14.
//  Copyright (c) 2014 FLASHiZ. All rights reserved.
//

#import "FZUIImageWithImage.h"

//Util
#import "FZImageUtil.h"

@implementation FZUIImageWithImage


+ (UIImage *)imageNamed:(NSString *)name inBundle:(FZBundleName)bundleName
{
   return [FZImageUtil imageNamed:name inBundle:bundleName];
}

// TODO : WTF - really we need to specify for this kind of image :'( !!!
+ (UIImage *)imageNamed568h:(NSString *)imageName inBundle:(FZBundleName)bunble
{
    return [FZImageUtil imageNamed568h:imageName inBundle:bunble];
}

@end
