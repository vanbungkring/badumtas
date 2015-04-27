//
//  fieldTransaction.m
//  Dompetku
//
//  Created by Indosat on 11/30/14.
//
//

#import "fieldTransaction.h"
#import "NetraApiManager.h"
@implementation fieldTransaction

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.sub_merchant_id = [attributes valueForKeyPath:@"sub_merchant_id"];
    self.url_action1 = [attributes valueForKeyPath:@"url_action1"];
    self.url_action2 = [attributes valueForKeyPath:@"url_action2"];
    self.detail_field = [attributes valueForKey:@"detail_field"];
    
    return self;
}

+ (NSURLSessionDataTask *)fieldDetail:(NSString *)data getAllField:(void (^)(NSArray *posts, NSError *error))block {
    return [[NetraApiManager sharedClient] POST:[NSString stringWithFormat:@"%@/list_field/%@/%@",elasitasApiUrl,fakeToken,data] parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *postsFromResponse =JSON;
        NSLog(@"api params-.%@",[NSString stringWithFormat:@"%@/list_field/%@/%@",elasitasApiUrl,fakeToken,data]);
        NSLog(@"JSON-->%@",JSON);
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        for (NSDictionary *attributes in postsFromResponse) {
            fieldTransaction *post = [[fieldTransaction alloc] initWithAttributes:attributes];
            [mutablePosts addObject:post];
        }
        
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
