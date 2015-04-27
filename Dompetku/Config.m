//
//  Config.m
//  Dompetku
//
//  Created by Indosat on 1/9/15.
//
//

#import "Config.h"
#import "NRealmSingleton.h"
#import <RLMResults.h>
@implementation Config
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
    return @{
             @"id":@0,
             @"isOTP":@0,
             @"isGuide":@0,
             };
}

+ (NSString *)primaryKey {
    return @"id";
}
+ (void)save:(Config *)config withRevision:(BOOL)revision{
    config = [[Config alloc]initWithObject:config];
    [[NRealmSingleton sharedMORealmSingleton].realm beginWriteTransaction];
    [[NRealmSingleton sharedMORealmSingleton].realm addOrUpdateObject:config];
    [[NRealmSingleton sharedMORealmSingleton].realm commitWriteTransaction];

}
+ (Config *)getConfigOTP{
    RLMResults *array = [Config objectsWhere:@"id = 0"];
    if(array.count > 0) {
        return [[Config alloc] initWithObject:array[0]];
    } else {
        return nil;
    }
}
+ (Config *)getConfigGuides{
    RLMResults *array = [Config objectsWhere:@"id = 0"];
    if(array.count > 0) {
        return [[Config alloc] initWithObject:array[0]];
    } else {
        return nil;
    }
}
@end
