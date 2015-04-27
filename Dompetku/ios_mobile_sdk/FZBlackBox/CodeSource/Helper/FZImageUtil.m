//
//  ImageHelper.m
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 17/12/13.
//  Copyright (c) 2013 Flashiz. All rights reserved.
//

#import "FZImageUtil.h"

//Util
#import "ODDeviceUtil.h"

//Helper
#import "BundleHelper.h"

static NSString * const kIMageCachePath = @"imageCacheFolder";

static NSCache *cacheImage = nil;


@implementation FZImageUtil

#pragma mark - Private -
#pragma mark - Shared Instance -

+ (NSCache *)currentCacheImage {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheImage = [[NSCache alloc] init];
        [cacheImage setName:kIMageCachePath];
    });
    
    return [[cacheImage retain] autorelease];
}

+ (UIImage *)imageFromCacheWithName:(NSString *)imageName {
    NSCache *currentCacheImage = [FZImageUtil currentCacheImage];
    
    return [currentCacheImage objectForKey:imageName];
}

+ (void)storeImageinCache:(UIImage *)image withName:(NSString *)imageName {
    NSCache *currentCacheImage = [FZImageUtil currentCacheImage];
    
    CGSize imageSize = [image size];
    
    NSUInteger cost = imageSize.height * imageSize.width * [image scale];
    
    [currentCacheImage setObject:image
                          forKey:imageName
                            cost:cost];
}

#pragma mark - Public -

#pragma mark Util

+ (UIImage *)imageNamed:(NSString *)imageName inBundle:(FZBundleName)bunble {

    
    UIImage *image = [FZImageUtil imageFromCacheWithName:imageName];
    
    if(image!=NULL) {
        return image;
    }
    
    NSString *realImageName = @"";
    
    if ([ODDeviceUtil isRetina]) {
        realImageName = [NSString stringWithFormat:@"%@@2x",imageName];
    } else {
        realImageName = [NSString stringWithFormat:@"%@",imageName];
    }
    
    //First find if any image is override in the main bundle
    NSString *filePath = [[[BundleHelper sharedInstance]bundle] pathForResource:realImageName ofType:@"png"];
    
    if ([filePath length]==0) {
        
        //Finally we try to find the image in the specified bundle
        filePath = [[BundleHelper retrieveBundle:bunble] pathForResource:realImageName ofType:@"png"];
        
        if([filePath length]==0) {
            return nil;
        }
    }
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    CGFloat scale = [ODDeviceUtil isRetina] ? 2.0:1.0;
    
    image = [UIImage imageWithData:data scale:scale];
    
    [FZImageUtil storeImageinCache:image withName:imageName];
    
    return image;
}

/*
 * to retreive image for iPhone with a 4" screen -568h@2x
 */
+ (UIImage *)imageNamed568h:(NSString *)imageName inBundle:(FZBundleName)bunble {
    
    UIImage *image = [FZImageUtil imageFromCacheWithName:imageName];
    
    if(image!=NULL) {
        return image;
    }
    
    NSString *imageName568h = @"";
    
    if ([ODDeviceUtil isRetina] && [ODDeviceUtil isAnIphoneFive]) {
        imageName568h = [NSString stringWithFormat:@"%@-568h",imageName];
        
        image = [FZImageUtil imageNamed:imageName568h inBundle:bunble];
        
        if (image != nil) {
            return image;
        } else {
            //-568h@2x image doesn't exist, try to find @2x
            return [FZImageUtil imageNamed:imageName inBundle:bunble];
        }
    } else {
        
        //it's not a 4" sreen iPhone
        return [FZImageUtil imageNamed:imageName inBundle:bunble];
    }
}


#pragma mark - Private methods

+ (NSString*) libraryDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+(void)createDirectory:(NSString *)directoryName atFilePath:(NSString *)filePath
{
    NSString *filePathAndDirectory = [filePath stringByAppendingPathComponent:directoryName];
    NSError *error;
    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
                                   withIntermediateDirectories:NO
                                                    attributes:nil
                                                         error:&error])
    {
        //NSLog(@"Create directory error: %@", error);
    }
}

@end
