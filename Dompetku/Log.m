//
//  Log.m
//  Dompetku
//
//  Created by Indosat on 12/28/14.
//
//

#import "Log.h"
#import "NRealmSingleton.h"
#import <RLMResults.h>
@implementation Log
+ (NSDictionary *)defaultPropertyValues {
    /*
     @property NSInteger id;
     @property NSString *guid;
     @property NSDate *createdAt;
     @property NSDate *updatedAt;
     @property NSString *actionName;
     @property NSString *merchant;
     @property BOOL isDeleted;
     @property NSString *destination;
     @property NSString *token;
     @property NSDate *expired;
     @property NSString *lastRevisionGuid;
     */
    return @{@"id" : @0,
             @"guid" : [[NSProcessInfo processInfo] globallyUniqueString],
             @"createdAt" : [NSDate date],
             @"updatedAt" : [NSDate date],
             @"actionName" : @"",
             @"isDeleted" : @NO,
             @"merchant" : @"",
             @"destination":@"",
             @"refId":@"",
             @"token": @"",
             @"expired":@0,
             @"amount":@"",
             @"voucherID":@"",
             @"lastRevisionGuid":@"",
             };
}

+ (NSString *)primaryKey {
    return @"guid";
}
+ (NSArray *)getItems {
    RLMResults *objects = [[Log objectsWhere:@"isDeleted=0"]sortedResultsUsingProperty:@"createdAt" ascending:NO];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:objects.count];
    for(id object in objects) {
        Log *item = [[Log alloc] initWithObject:object];
        [mutableArray addObject:item];
    }
    
    return mutableArray;
}
+ (Log *)findFav:(NSString *)key{
    RLMResults *array = [Log objectsWhere:@"name CONTAINS %@",key];
    if(array.count > 0) {
        return [[Log alloc] initWithObject:array[0]];
    } else {
        return nil;
    }
}
+(Log *)getFavoriteByGuid:(NSString *)guid{
    RLMResults *array = [Log objectsWhere:@"guid = %@ AND isDeleted = NO",guid];
    if(array.count > 0) {
        return [[Log alloc] initWithObject:array[0]];
    } else {
        return nil;
    }
    
}
+ (Log *)getFavorite {
    RLMResults *array = [Log objectsWhere:@"isDeleted=0"];
    if(array.count > 0) {
        return [[Log alloc] initWithObject:array[0]];
    } else {
        return [[Log alloc] init];
    }
}
+(void)save:(Log *)favorite withRevision:(BOOL)revision{
    favorite = [[Log alloc]initWithObject:favorite];
    [[NRealmSingleton sharedMORealmSingleton].realm beginWriteTransaction];
    //    if (revision) [MOUserProfile saveToRevision:userProfile];
    [[NRealmSingleton sharedMORealmSingleton].realm addOrUpdateObject:favorite];
    [[NRealmSingleton sharedMORealmSingleton].realm commitWriteTransaction];
}
@end
