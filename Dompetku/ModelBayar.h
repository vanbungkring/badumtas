//
//  ModelBayar.h
//  Dompetku
//
//  Created by Indosat on 11/28/14.
//
//

#import <Foundation/Foundation.h>

@class modelSubMerchant;

@interface ModelBayar : NSObject
@property (nonatomic, assign) NSString* mid;
@property (nonatomic, strong) NSString *mnama;
@property (nonatomic, strong) NSString *mimage;

@property (nonatomic, strong) modelSubMerchant *subMerchant;
+(void)fetchBayar;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;

+ (NSURLSessionDataTask *)getdataFromModelBayar:(void (^)(NSArray *posts, NSError *error))block;

@end
