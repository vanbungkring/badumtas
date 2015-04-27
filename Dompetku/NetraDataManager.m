//
//  NetraDataManager.m
//  Dompetku
//
//  Created by Indosat on 11/28/14.
//
//

#import "NetraDataManager.h"

@implementation NetraDataManager
static NetraDataManager *shared;
+ (NetraDataManager *)sharedDataManager {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared = [[super allocWithZone:NULL] init];
    });
    return shared;
}
+(NSString *)getWT{
    return [NetraDataManager sharedDataManager].walletType;
}
+(void)setBeliJson:(NSArray *)beliData{
    [NetraDataManager sharedDataManager].beliArray = beliData;
}
+(void)setBayarData:(NSArray *)bayarData{
    [NetraDataManager sharedDataManager].bayarArray = bayarData;

}
+(void)setWalletType:(NSString *)wt{
    [NetraDataManager sharedDataManager].walletType = wt;
    
}
+(NSArray *)getBeliData{
    return [NetraDataManager sharedDataManager].beliArray;
}
+(NSArray *)getBayarData{
    return [NetraDataManager sharedDataManager].bayarArray;
}
@end
