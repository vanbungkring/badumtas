//
//  transactionFavorite.m
//  Dompetku
//
//  Created by Indosat on 12/15/14.
//
//

#import "transactionFavorite.h"
#import "NRealmSingleton.h"
#import "RLMResults.h"
@implementation transactionFavorite
/*
 @property NSInteger id;
 @property NSString *guid;
 @property NSDate *createdAt;
 @property NSDate *updatedAt;
 @property NSString *state;
 @property BOOL isDeleted;
 @property NSString *merchant;
 @property NSString *parent;
 @property NSString *name;
 */
+ (NSDictionary *)defaultPropertyValues {
    /*
     @property NSInteger id;
     @property NSString *guid;
     @property NSDate *createdAt;
     @property NSDate *updatedAt;
     @property NSString *balance;
     @property BOOL billpayQueryState;
     @property BOOL billpayState;
     @property NSString *status;
     @property NSString *trxid;
     @property NSString *lastRevisionGuid;
     */
    return @{@"id" : @0,
             @"guid" : [[NSProcessInfo processInfo] globallyUniqueString],
             @"createdAt" : [NSDate date],
             @"updatedAt" : [NSDate date],
             @"state" : @"",
             @"isDeleted" : @NO,
             @"merchant" : @"",
             @"parent":@"",
             @"name":@"",
             @"merchantID": @"",
             @"parentID":@"",
             @"transactionJenis":@"",
             @"lastRevisionGuid":@"",
             @"fieldInformation":@"",
             @"tags":@""
             };
}

+ (NSString *)primaryKey {
    return @"guid";
}
+ (NSArray *)getItems {
    RLMResults *objects = [transactionFavorite objectsWhere:@"isDeleted=0"];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:objects.count];
    for(id object in objects) {
        transactionFavorite *item = [[transactionFavorite alloc] initWithObject:object];
        [mutableArray addObject:item];
    }
    
    return mutableArray;
}
+ (transactionFavorite *)findFav:(NSString *)key{
    RLMResults *array = [transactionFavorite objectsWhere:@"name CONTAINS %@",key];
    if(array.count > 0) {
        return [[transactionFavorite alloc] initWithObject:array[0]];
    } else {
        return nil;
    }
}
+ (transactionFavorite *)getFavorite {
    RLMResults *array = [transactionFavorite objectsWhere:@"isDeleted = 0"];
    if(array.count > 0) {
        return [[transactionFavorite alloc] initWithObject:array[0]];
    } else {
        return [[transactionFavorite alloc] init];
    }
}
+(transactionFavorite *)getFavoriteByGuid:(NSString *)guid{
    RLMResults *array = [transactionFavorite objectsWhere:@"guid = %@ AND isDeleted = NO",guid];
    if(array.count > 0) {
        return [[transactionFavorite alloc] initWithObject:array[0]];
    } else {
        return nil;
    }

}
+(void)save:(transactionFavorite *)favorite withRevision:(BOOL)revision{
    favorite = [[transactionFavorite alloc]initWithObject:favorite];
    [[NRealmSingleton sharedMORealmSingleton].realm beginWriteTransaction];
    //    if (revision) [MOUserProfile saveToRevision:userProfile];
    [[NRealmSingleton sharedMORealmSingleton].realm addOrUpdateObject:favorite];
    [[NRealmSingleton sharedMORealmSingleton].realm commitWriteTransaction];
}

@end
