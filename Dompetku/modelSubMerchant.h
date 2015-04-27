//
//  modelSubMerchant.h
//  Dompetku
//
//  Created by Indosat on 11/28/14.
//
//

#import <Foundation/Foundation.h>

@interface modelSubMerchant : NSObject
@property (readonly, nonatomic, copy) NSString *sub_merchant_id;
@property (readonly, nonatomic, copy) NSString *sub_merchant_nama;
@property (readonly, nonatomic, copy) NSString *img_path;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end
