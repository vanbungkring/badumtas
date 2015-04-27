//
//  ModelBayar.m
//  Dompetku
//
//  Created by Indosat on 11/28/14.
//
//

#import "ModelBayar.h"
#import "NetraApiManager.h"
#import "NetraDataManager.h"
#import "ModelBeli+Bayar.h"
#import "modelSubMerchant.h"
#import "NRealmSingleton.h"
@implementation ModelBayar
- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.mid = [attributes valueForKeyPath:@"mid"];
    self.mnama = [attributes valueForKeyPath:@"mnama"];
    self.mimage = [attributes valueForKeyPath:@"mimage"];
    self.subMerchant = [[modelSubMerchant alloc] initWithAttributes:[attributes valueForKeyPath:@"sub_merchant"]];
    
    return self;
}

#pragma mark -


+(void)fetchBayar{
    NSLog(@"fetch Bayar");
    [ModelBayar getdataFromModelBayar:^(NSArray *posts, NSError *error) {
        if (!error) {
            
            [[NetraDataManager sharedDataManager] setBayarArray:posts];
           // [ModelBeli fetchBeli];
            
        }
        else{
             NSLog(@"Gagal-->%@",error);
            [[NRealmSingleton sharedMORealmSingleton]deleteRealm];
        }
    }];
}

@end
