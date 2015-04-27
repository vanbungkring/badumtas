//
//  NetraUserModel.m
//  Dompetku
//
//  Created by Indosat on 12/6/14.
//
//

//
//  netraUserModel.m
//  Dompetku
//
//  Created by Indosat on 12/6/14.
//
//

#import "NetraUserModel.h"
#import "NRealmSingleton.h"
#import <Realm.h>

@implementation netraUserModel

+ (NSDictionary *)defaultPropertyValues {
    return @{@"id" : @0,
             @"guid" : [[NSProcessInfo processInfo] globallyUniqueString],
             @"createdAt" : [NSDate date],
             @"updatedAt" : [NSDate date],
             @"billpayQueryState" : @NO,
             @"billpayState" : @NO,
             @"status" : @"",
             @"trxid" : @"",
             @"msg" : @"",
             @"tripleDes":@"",
             @"lastRevisionGuid":@""
             };
}

+ (NSString *)primaryKey {
    return @"id";
}
+ (netraUserModel *)getUserProfile {
    RLMResults *array = [netraUserModel allObjects];
    if(array.count > 0) {
        return [[netraUserModel alloc] initWithObject:array[0]];
    } else {
        return [[netraUserModel alloc] init];
    }
}
+(void)save:(netraUserModel *)userProfile withRevision:(BOOL)revision{
    userProfile = [[netraUserModel alloc]initWithObject:userProfile];
    [[NRealmSingleton sharedMORealmSingleton].realm beginWriteTransaction];
    //    if (revision) [MOUserProfile saveToRevision:userProfile];
    [[NRealmSingleton sharedMORealmSingleton].realm addOrUpdateObject:userProfile];
    [[NRealmSingleton sharedMORealmSingleton].realm commitWriteTransaction];
}
@end