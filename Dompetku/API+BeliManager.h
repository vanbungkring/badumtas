//
//  API+BeliManager.h
//  Dompetku
//
//  Created by Indosat on 1/9/15.
//
//

#import <Foundation/Foundation.h>

@interface API_BeliManager : NSObject
+ (NSURLSessionDataTask *)urlparams:(NSString *)postParams param:(NSDictionary *)parameters postParams:(void (^)(NSArray *posts, NSError *error))block;
@end
