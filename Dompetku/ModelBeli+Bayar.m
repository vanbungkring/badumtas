//
//  ModelBeli.m
//  Dompetku
//
//  Created by Indosat on 11/28/14.
//
//

#import "ModelBeli+Bayar.h"
#import "NetraApiManager.h"
#import "NetraDataManager.h"
#import "transactionMapping.h"
#import "modelSubMerchant.h"
#import "fieldTransaction.h"
#import "modelSubMerchant.h"
#import "NRealmSingleton.h"
#import "SubMerchant.h"
#import "RLMResults.h"
#import "Realm.h"
#import "SubMerchant.h"
#import "ModelBeli+BayarManager.h"

@implementation ModelBeli_Bayar

+ (NSDictionary *)defaultPropertyValues {

    return @{@"id" : @0,
             @"guid" : [[NSProcessInfo processInfo] globallyUniqueString],
             @"createdAt" : [NSDate date],
             @"updatedAt" : [NSDate date],
             @"isBeli" : @NO,
             @"mid" : @"",
             @"mnama" : @"",
             @"mimage":@"",
             @"lastRevisionGuid":@""
             };
}

+ (NSString *)primaryKey {
    return @"id";
}

#pragma mark -
+(void)fetchBeli{
    NSLog(@"fetch Beli");
    
//    [ModelBeli_Bayar getDataFromModelBeli:^(NSArray *beli, NSArray *bayar, NSError *error) {
//        if (!error) {
//            [ModelBeli_Bayar insertManager:beli isBeli:1];
//            [ModelBeli_Bayar insertManager:bayar isBeli:0];
//             [[NSNotificationCenter defaultCenter]postNotificationName:@"errorFetch" object:nil];
//        }
//        else{
//            [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Gagal Mengambil data Merchant Dari Server, silahkan tekan tombol reload"];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"errorFetch" object:nil];
//            ///[[NRealmSingleton sharedMORealmSingleton]deleteRealm];
//        }
//        
//        
//    }];
    
}
+(void)insertManager:(NSArray *)data isBeli:(BOOL)isBeli{
    ModelBeli_Bayar *m = [[ModelBeli_Bayar alloc]init];
    
    ///insert into realm when data is empty
    for (int i=0;i<data.count;i++){
        //iterate here
        ///check if record already exist?
        ModelBeli_BayarManager *model = [data objectAtIndex:i];
        m.id = [model.jsonMid integerValue];
        m.mnama = model.jsonMnama;
        m.mimage = model.jsonMimage;
        m.mid = model.jsonMid;
        m.isBeli = isBeli;
        
        for (int x=0; x<model.jsonSub.count; x++) {
            SubMerchant *sub = [[SubMerchant alloc]init];
            sub.id =[[[model.jsonSub objectAtIndex:x]objectForKey:@"sub_merchant_id"] integerValue];
            sub.img_path = [[model.jsonSub objectAtIndex:x]objectForKey:@"img_path"];
            sub.sub_merchant_id =[[model.jsonSub objectAtIndex:x]objectForKey:@"sub_merchant_id"];
            sub.sub_merchant_nama =[[model.jsonSub objectAtIndex:x]objectForKey:@"sub_merchant_nama"];
            sub.parentId = model.jsonMid;
            [SubMerchant save:sub withRevision:YES];
        }
        [ModelBeli_Bayar save:m withRevision:YES];
    }
    
    
}
+ (NSURLSessionDataTask *)getDataFromModelBeli:(void (^)(NSArray *beli,NSArray *bayar, NSError *error))block {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NetraApiManager sharedClient].responseSerializer setAcceptableContentTypes:[[NetraApiManager sharedClient].responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"]];
    return [[NetraApiManager sharedClient] GET:[NSString stringWithFormat:@"%@/list_merchant/%@",elasitasApiUrl,fakeToken] parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSLog(@"json->%@",JSON);
        NSLog(@"hit url->%@",[NSString stringWithFormat:@"%@/list_merchant/%@",elasitasApiUrl,fakeToken]);
        NSArray *beliResponse = [JSON objectForKey:@"Beli"];
        NSArray *bayarResponse = [JSON objectForKey:@"Bayar"];
        
        
        NSMutableArray *mutableBeli = [NSMutableArray arrayWithCapacity:[beliResponse count]];
        NSMutableArray *mutableBayar = [NSMutableArray arrayWithCapacity:[bayarResponse count]];
        
        for (NSDictionary *attributes in beliResponse) {
            ModelBeli_BayarManager *post = [[ModelBeli_BayarManager alloc] initWithAttributes:attributes];
            [mutableBeli addObject:post];
        }
        
        for (NSDictionary *attributes in bayarResponse) {
            ModelBeli_BayarManager *post = [[ModelBeli_BayarManager alloc] initWithAttributes:attributes];
            [mutableBayar addObject:post];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutableBeli], [NSArray arrayWithArray:mutableBayar],nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array],[NSArray array], error);
            [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Mohon pastikan anda terkoneksi ke internet"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"errorFetch" object:nil];
        }
    }];
}
+ (NSArray *)isBeliStatus:(BOOL)isBeli{
    RLMResults *objects = [ModelBeli_Bayar objectsWhere:@"isBeli = %d",isBeli];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:objects.count];
    for(id object in objects) {
        ModelBeli_Bayar *item = [[ModelBeli_Bayar alloc] initWithObject:object];
        [mutableArray addObject:item];
    }
    
    return mutableArray;
}


+ (ModelBeli_Bayar *)getByID:(NSInteger)id {
    RLMResults *array = [ModelBeli_Bayar objectsWhere:@"id = %d", id];
    if(array.count > 0) {
        return [[ModelBeli_Bayar alloc] initWithObject:array[0]];
    } else {
        return nil;
    }
}
+ (ModelBeli_Bayar *)getByParentID:(NSString *)ids {
    
    RLMResults *array = [ModelBeli_Bayar objectsWhere:@"ANY subMerchantArray.parentId = %@",ids];
    if(array.count > 0) {
        return [[ModelBeli_Bayar alloc] initWithObject:array[0]];
    } else {
        return nil;
    }
}
+ (void)save:(ModelBeli_Bayar *)modelBeliBayar withRevision:(BOOL)revision{
    modelBeliBayar = [[ModelBeli_Bayar alloc]initWithObject:modelBeliBayar];
    [[NRealmSingleton sharedMORealmSingleton].realm beginWriteTransaction];
    //    if (revision) [MOUserProfile saveToRevision:userProfile];
    [[NRealmSingleton sharedMORealmSingleton].realm addOrUpdateObject:modelBeliBayar];
    [[NRealmSingleton sharedMORealmSingleton].realm commitWriteTransaction];
}
@end
