//
//  transactionMapping.m
//  Dompetku
//
//  Created by Indosat on 11/30/14.
//
//

#import "transactionMapping.h"

@implementation transactionMapping
static transactionMapping *shared;
+ (transactionMapping *)sharedDataManager {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared = [[super allocWithZone:NULL] init];
    });
    return shared;
}
+(void)setTransactionBayar:(NSArray *)bayar{
    [transactionMapping sharedDataManager].bayarStorage = bayar;

}
+(void)setTransactionBeli:(NSArray *)beli{
    [transactionMapping sharedDataManager].bayarStorage = beli;
}
+(NSArray *)getTransactionByCategory:(NSString *)category merchant:(NSString *)idMerchant{
    NSArray *dataTemp;
    NSMutableArray *data = [[NSMutableArray alloc]init];
    if ([category isEqualToString:@"Bayar"]) {
        dataTemp =[transactionMapping sharedDataManager].bayarStorage;
    }
    else{
        dataTemp =[transactionMapping sharedDataManager].beliStorage;
    }
    for(id dict in dataTemp /*your original plist is an array for you*/) {
        if([[dict objectForKey:@"sub_merchant_id"]isEqualToString:idMerchant]) {
            [data addObject:dict];
            
        }
    }
    NSLog(@"data------------------>%@",data);
    return data;
}

//+(NSArray *)getTransactionByMerchant:(NSString *)idMerchant{
//    NSLog(@"adt-->%@",[[transactionMapping sharedDataManager].parentBayarStorage objectAtIndex:0]objectForKey:@"");
//    NSMutableArray *data = [[NSMutableArray alloc]init];
//    
//    for(id dict in [transactionMapping sharedDataManager].parentBayarStorage /*your original plist is an array for you*/) {
//        NSLog(@"dict-->%@",[dict objectForKey:@"sub_merchant_id"]);
//    }
//    return nil;
//    
//}
@end
