//
//  NetraUserInquiry.m
//  Dompetku
//
//  Created by Indosat on 12/6/14.
//
//

#import "NetraUserInquiry.h"
#import "NRealmSingleton.h"
@implementation NetraUserInquiry
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
             @"billpayQueryState" : @NO,
             @"billpayState" : @NO,
             @"status" : @"",
             @"trxid" : @"",
             @"balance":@"",
             @"name":@"",
             @"lastRevisionGuid":@""
             };
}

+ (NSString *)primaryKey {
    return @"id";
}
+ (NetraUserInquiry *)getUserInquiry {
    RLMResults *array = [NetraUserInquiry allObjects];
    if(array.count > 0) {
        return [[NetraUserInquiry alloc] initWithObject:array[0]];
    } else {
        return [[NetraUserInquiry alloc] init];
    }
}
+(void)save:(NetraUserInquiry *)userInquiry withRevision:(BOOL)revision{
    userInquiry = [[NetraUserInquiry alloc]initWithObject:userInquiry];
    [[NRealmSingleton sharedMORealmSingleton].realm beginWriteTransaction];
    //    if (revision) [MOUserProfile saveToRevision:userProfile];
    [[NRealmSingleton sharedMORealmSingleton].realm addOrUpdateObject:userInquiry];
    [[NRealmSingleton sharedMORealmSingleton].realm commitWriteTransaction];
}
@end