//
//  RegisterManager.h
//  Dompetku
//
//  Created by Indosat on 1/23/15.
//
//

#import <Foundation/Foundation.h>

@interface RegisterManager : NSObject
+ (NSURLSessionDataTask *)registerParams:(NSDictionary *)params registerManager:(void (^)(NSArray *posts, NSError *error))block;
@end
