//
//  FZResponseLoader.h
//  FZAPI
//
//  Created by OlivierDemolliens on 7/22/14.
//  Copyright (c) 2014 Flashiz. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Used only with unit testing
 **/
@interface FZResponseLoader : NSObject

+(id)readJSONFromFile:(NSString*)fileName withClass:(NSObject*)object;

+(id)readCVSFromFile:(NSString*)fileName;

@end
