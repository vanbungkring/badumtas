//
//  UIImage+BinaryArray.m
//  iMobey
//
//  Created by Matthieu Barile on 16/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "FZUIImageWithFZBinaryArray.h"

#import "FZNSDataWithMD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation FZUIImageWithFZBinaryArray


+ (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}
+ (UIImage*)imageFromBinaryArray:(NSArray*)binaryArray withDefautImage:(UIImage *)defaultImage {
    unsigned char *buffer = (unsigned char*)malloc([binaryArray count]);
    int j=0;
    
    for (NSDecimalNumber *num in binaryArray) {
        buffer[j++] = [num intValue];
    }
    
    NSData *data = [NSData dataWithBytes:buffer length:[binaryArray count]];
	
	
	// Create byte array of unsigned chars
	unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
	
	// Create 16 byte MD5 hash value, store in buffer
	CC_MD5([data bytes], [data length], md5Buffer);
	
	// Convert unsigned char buffer to NSString of hex values
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
		[output appendFormat:@"%02x",md5Buffer[i]];
	}
	
	NSString *fileName = [NSString stringWithFormat:@"%@.png",output];
	
    free(buffer);
    
    if([fileName isEqualToString:@"e94f0bfab8c987a7437ba4e1697c1cc0.png"]){
        return defaultImage;
    }
    
    NSString *filePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:fileName];
    
    //check if a local copy exist
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    
        return [UIImage imageWithContentsOfFile:filePath];
    } else {
        NSData* dataImage = UIImagePNGRepresentation([UIImage imageWithData:data]);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createFileAtPath:filePath contents:dataImage attributes:nil];
        
        if([UIImage imageWithData:dataImage]==nil){
            return defaultImage;
        } else {
            return [UIImage imageWithData:dataImage];
        }
    }
}

@end
