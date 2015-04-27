//
//  NetraApiManager.h
//  Dompetku
//
//  Created by Indosat on 11/28/14.
//
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface NetraApiManager : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end

