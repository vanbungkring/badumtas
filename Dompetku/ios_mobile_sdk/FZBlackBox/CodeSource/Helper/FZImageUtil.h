//
//  ImageHelper.h
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 17/12/13.
//  Copyright (c) 2013 Flashiz. All rights reserved.
//

#import <UIKit/UIKit.h>

//Enum
#import <FZAPI/FZFilesEnum.h>

/***
* Private Class
****/

@interface FZImageUtil : UIImage

+ (UIImage *)imageNamed:(NSString *)imageName inBundle:(FZBundleName)bunble;
+ (UIImage *)imageNamed568h:(NSString *)imageName inBundle:(FZBundleName)bunble;

@end
