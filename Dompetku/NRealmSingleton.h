//
//  NRealmSingleton.h
//  Dompetku
//
//  Created by Indosat on 12/6/14.
//
//

#import "RLMRealm.h"

@class RLMRealm;
@interface NRealmSingleton : RLMRealm
+ (NRealmSingleton *)sharedMORealmSingleton;
- (void)deleteRealm;
@property (nonatomic, strong) RLMRealm *realm;
@end