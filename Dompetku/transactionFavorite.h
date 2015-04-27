//
//  transactionFavorite.h
//  Dompetku
//
//  Created by Indosat on 12/15/14.
//
//

#import "RLMObject.h"
#import <Realm.h>

@interface transactionFavorite : RLMObject
@property NSInteger id;
@property NSString *guid;
@property NSDate *createdAt;
@property NSDate *updatedAt;
@property NSString *state;
@property NSString *transactionJenis;
@property BOOL isDeleted;
@property NSString *merchant;
@property NSString *merchantID;
@property NSString *parent;
@property NSString *parentID;
@property NSString *fieldInformation;
@property NSString *tags;
@property NSString *name;
@property NSString *lastRevisionGuid;

/*
 NSLog(@"_state->%@",_state);
 NSLog(@"_transaction Jenis->%@",_transactionJenis);
 NSLog(@"Transaction Merchant-->%@",[[_data objectAtIndex:0]objectForKey:@"sub_merchant_nama"]);
 NSLog(@"Transaction Merchant-->%@",_transactionNameParent);
 NSLog(@"transactionName-->%@_%@_%@",_transactionNameParent,[[_data objectAtIndex:0]objectForKey:@"sub_merchant_nama"],tf.text);
 */
+ (transactionFavorite *)getFavorite;
+ (NSArray *)getItems;
+ (transactionFavorite *)findFav:(NSString *)key;
+ (transactionFavorite *)getFavoriteByGuid:(NSString *)guid;
+ (void)save:(transactionFavorite *)favorite withRevision:(BOOL)revision;
@end
