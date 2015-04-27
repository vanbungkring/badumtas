//
//  NRealmSingleton.m
//  Dompetku
//
//  Created by Indosat on 12/6/14.
//
//

#import "NRealmSingleton.h"
#import "NetraUserInquiry.h"
#import "NetraUserModel.h"
#import "ModelBeli+Bayar.h"
#import "Log.h"
#import "transactionFavorite.h"
@implementation NRealmSingleton

+ (NRealmSingleton *)sharedMORealmSingleton {
    static dispatch_once_t pred;
    static NRealmSingleton *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[NRealmSingleton alloc] init];
    });
    return shared;
}
- (id)init {
    self = [super init];
    if(self) {
        //        [GVUserDefaults standardUserDefaults].databaseVersion = 1;
        //        [self performMigrationIfNeeded];
        _realm = [RLMRealm defaultRealm];
    }
    return self;
}
-(void)deleteRealm{
    [_realm beginWriteTransaction];
    [_realm deleteObjects:[netraUserModel allObjects]];
    [_realm commitWriteTransaction];
}
@end