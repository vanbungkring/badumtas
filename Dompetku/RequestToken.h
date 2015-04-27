//
//  RequestToken.h
//  Dompetku
//
//  Created by Indosat on 12/28/14.
//
//

#import <Foundation/Foundation.h>

@interface RequestToken : NSObject
+ (NSURLSessionDataTask *)requestToken:(NSDictionary *)params login:(void (^)(NSArray *posts, NSError *error))block ;
@end
