//
//  SubMerchant.m
//  Dompetku
//
//  Created by Indosat on 12/19/14.
//
//

#import "SubMerchant.h"
#import "RLMResults.h"
#import "NRealmSingleton.h"
@implementation SubMerchant
/*
 @property (readonly, nonatomic, copy) NSString *sub_merchant_id;
 @property (readonly, nonatomic, copy) NSString *sub_merchant_nama;
 @property (readonly, nonatomic, copy) NSString *img_path;
 */
+ (NSDictionary *)defaultPropertyValues {
    return @{@"id" : @0,
             @"guid" : [[NSProcessInfo processInfo] globallyUniqueString],
             @"createdAt" : [NSDate date],
             @"updatedAt" : [NSDate date],
             @"sub_merchant_id" : @"",
             @"sub_merchant_nama" : @"",
             @"img_path" : @"",
             @"lastRevisionGuid":@"",
             @"parentId":@""
             };
}
+ (NSString *)primaryKey {
    return @"id";
}
/*
 + (NSArray *)isBeliStatus:(BOOL)isBeli{
 RLMResults *objects = [ModelBeli_Bayar objectsWhere:@"isBeli = %d",isBeli];
 NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:objects.count];
 for(id object in objects) {
 ModelBeli_Bayar *item = [[ModelBeli_Bayar alloc] initWithObject:object];
 [mutableArray addObject:item];
 }
 
 return mutableArray;
 }

 */
+ (NSArray *)getAllSubmerchantById:(NSInteger)subId{
    RLMResults *objects = [SubMerchant objectsWhere:@"parentId = %@",[NSString stringWithFormat:@"%d",subId]];

    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:objects.count];
    for(id object in objects) {
        SubMerchant *item = [[SubMerchant alloc] initWithObject:object];
        [mutableArray addObject:item];
    }
    
    return mutableArray;
}

+ (void)save:(SubMerchant *)sub withRevision:(BOOL)revision{
    sub = [[SubMerchant alloc]initWithObject:sub];
    [[NRealmSingleton sharedMORealmSingleton].realm beginWriteTransaction];
    //    if (revision) [MOUserProfile saveToRevision:userProfile];
    [[NRealmSingleton sharedMORealmSingleton].realm addOrUpdateObject:sub];
    [[NRealmSingleton sharedMORealmSingleton].realm commitWriteTransaction];

}
@end
