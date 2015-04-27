//
//  CoreMultiTargetImageService.h
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 23/01/14.
//  Copyright (c) 2014 Flashiz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@protocol CoreMultiTargetImageService <NSObject>

- (UIImage *)noAvatarImage  __attribute__((deprecated));
- (UIImage *)arrowRightGreenImage  __attribute__((deprecated));
- (UIImage *)arrowRightWhiteImage  __attribute__((deprecated));
- (UIImage *)arrowRightBlueImage  __attribute__((deprecated));
- (UIImage *)arrowRightOrangeImage  __attribute__((deprecated));
- (UIImage *)visaImage  __attribute__((deprecated));
- (UIImage *)masterCardImage  __attribute__((deprecated));
- (UIImage *)buttonLocateImage  __attribute__((deprecated));
- (UIImage *)paginationIntro1Image  __attribute__((deprecated));
- (UIImage *)paginationIntro2Image  __attribute__((deprecated));
- (UIImage *)paginationIntro3Image  __attribute__((deprecated));
- (UIImage *)paginationIntro4Image  __attribute__((deprecated));
- (UIImage *)iconCrossImage  __attribute__((deprecated));


@end
