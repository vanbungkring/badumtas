//
//  UIImage+FZImage.h
//  FZBlackBox
//
//  Created by Olivier Demolliens on 4/18/14.
//  Copyright (c) 2014 FLASHiZ. All rights reserved.
//

#import <UIKit/UIKit.h>

//Enum
#import <FZAPI/FZFilesEnum.h>

@interface FZUIImageWithImage : UIImage
{
    
}

+ (UIImage *)imageNamed:(NSString *)name inBundle:(FZBundleName)bundleName;
+ (UIImage *)imageNamed568h:(NSString *)imageName inBundle:(FZBundleName)bunble;

@end
