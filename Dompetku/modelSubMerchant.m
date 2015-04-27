//
//  modelSubMerchant.m
//  Dompetku
//
//  Created by Indosat on 11/28/14.
//
//

#import "modelSubMerchant.h"
#import "AFHTTPRequestOperation.h"
@interface modelSubMerchant ()
@property (readwrite, nonatomic, copy) NSString *sub_merchant_id;
@property (readwrite, nonatomic, copy) NSString *sub_merchant_nama;
@property (readwrite, nonatomic, copy) NSString *img_path;

@end
@implementation modelSubMerchant
- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    NSLog(@"attributes-->%@",[[attributes valueForKeyPath:@"sub_merchant_id"] objectAtIndex:0]);

    return self;
}


@end
