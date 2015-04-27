//
//  transactionMapping.h
//  Dompetku
//
//  Created by Indosat on 11/30/14.
//
//

#import <Foundation/Foundation.h>
#import "fieldTransaction.h"
@interface transactionMapping : NSObject
@property (strong)NSArray *bayarStorage;
@property (strong)NSArray *historyTransaction;
@property (strong)NSArray *beliStorage;
@property (strong)NSArray *parentBayarStorage;
@property (strong)NSArray *parentbeliStorage;
+ (transactionMapping *)sharedDataManager;
+(void)setTransactionBayar:(NSArray *)bayar;
+(void)setTransactionParentBayar:(NSArray *)parent;
+(void)setTransactionParentBeli:(NSArray *)parent;
+(void)setTransactionBeli:(NSArray *)beli;
+(NSArray *)getTransactionByCategory:(NSString *)category merchant:(NSString *)idMerchant;
+(NSArray *)getTransactionByMerchant:(NSString *)idMerchant;
@end
