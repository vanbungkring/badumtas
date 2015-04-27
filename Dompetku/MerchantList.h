//
//  MerchantList.h
//  Dompetku
//
//  Created by Indosat on 12/21/14.
//
//

#import <Foundation/Foundation.h>

@interface MerchantList : NSObject
/*
 list_merchant_nama: "Alfamart",
 list_merchant_img: "",
 list_merchant_url: "http://www.alfamartku.com"
 },
 */
@property (nonatomic, assign) NSString *list_merchant_nama;
@property (nonatomic, strong) NSString *list_merchant_img;
@property (nonatomic, strong) NSString *list_merchant_url;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
+ (NSURLSessionDataTask *)getAllMerchant:(NSInteger)pagination pag:(void (^)(NSArray *posts, NSError *error))block;
@end
