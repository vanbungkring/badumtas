//
//  fieldTransaction.h
//  Dompetku
//
//  Created by Indosat on 11/30/14.
//
//

#import <Foundation/Foundation.h>

@interface fieldTransaction : NSObject
@property (nonatomic, assign) NSString *sub_merchant_id;
@property (nonatomic, strong) NSString *url_action1;
@property (nonatomic, strong) NSString *url_action2;
@property (nonatomic, strong) NSString *service;
@property (nonatomic, assign) NSArray *detail_field;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
+ (NSURLSessionDataTask *)fieldDetail:(NSString *)data getAllField:(void (^)(NSArray *posts, NSError *error))block;
@end
