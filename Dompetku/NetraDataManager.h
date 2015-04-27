//
//  NetraDataManager.h
//  Dompetku
//
//  Created by Indosat on 11/28/14.
//
//

#import <Foundation/Foundation.h>

@interface NetraDataManager : NSObject
@property (strong)NSArray *beliArray;
@property (strong)NSArray *bayarArray;
@property (strong)NSArray *historicalData;
@property (strong)NSString *walletType;
+ (NetraDataManager *)sharedDataManager;
+(void)setBeliJson:(NSArray *)beliData;
+(void)setBayarData:(NSArray *)bayarData;
+(void)setWalletType:(NSString *)wt;
+(NSArray *)getBeliData;
+(NSString *)getWT;
+(NSArray *)getBayarData;
@end
