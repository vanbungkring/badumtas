//
//  MerchantList.m
//  Dompetku
//
//  Created by Indosat on 12/21/14.
//
//

#import "MerchantList.h"
#import "NetraApiManager.h"
@implementation MerchantList
- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    NSLog(@"arrt->%@",attributes);
    self.list_merchant_nama =[attributes valueForKeyPath:@"list_merchant_nama"];
    self.list_merchant_img  = [attributes valueForKeyPath:@"list_merchant_img"];
    self.list_merchant_url  = [attributes valueForKeyPath:@"list_merchant_url"];
    
    return self;
}

+ (NSURLSessionDataTask *)getAllMerchant:(NSInteger)pagination pag:(void (^)(NSArray *posts, NSError *error))block {
    [[NetraApiManager sharedClient].responseSerializer setAcceptableContentTypes:[[NetraApiManager sharedClient].responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"]];
    //[_sharedClient.responseSerializer setAcceptableContentTypes:[_sharedClient.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"]];
    return [[NetraApiManager sharedClient] GET:[NSString stringWithFormat:@"http://fb.elasitas.com/jason/api_dompetku/api_c/list_listmerchant/204a217e5873d4a00868f3224cebd607/10/%d",pagination] parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *postsFromResponse =JSON;
        NSLog(@"json-->%@",JSON);
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        [mutablePosts addObject:postsFromResponse];
        
        if (block) {
            block([NSArray arrayWithArray:mutablePosts], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            NSLog(@"error->%@",error);
            block([NSArray array], error);
        }
    }];
}
@end
