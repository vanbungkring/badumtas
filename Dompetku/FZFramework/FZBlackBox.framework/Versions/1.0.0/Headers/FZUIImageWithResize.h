// FZUIImageWithResize.h
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

// Extends the UIImage class to support resizing/cropping
#import <UIKit/UIKit.h>

@interface FZUIImageWithResize : UIImage
+ (UIImage *)cropped:(UIImage *) image bounds:(CGRect)bounds;

+ (UIImage *)resized:(UIImage *) image image:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;

+ (UIImage *)resized:(UIImage *) image imageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;
@end