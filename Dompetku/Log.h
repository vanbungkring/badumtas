//
//  Log.h
//  Dompetku
//
//  Created by Indosat on 12/28/14.
//
//

#import "RLMObject.h"

@interface Log : RLMObject
@property NSInteger id;
@property NSString *guid;
@property NSDate *createdAt;
@property NSDate *updatedAt;
@property NSString *actionName;
@property NSString *merchant;
@property BOOL isDeleted;
@property NSString *destination;
@property NSString *token;
@property NSString *refId;
@property NSDate *expired;
@property NSString *amount;
@property NSString *voucherID;
@property NSString *lastRevisionGuid;
+ (Log *)getFavorite;
+ (NSArray *)getItems;
+ (Log *)findFav:(NSString *)key;
+(Log *)getFavoriteByGuid:(NSString *)guid;
+ (void)save:(Log *)log withRevision:(BOOL)revision;
@end
