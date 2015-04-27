//
//  NetraUserInquiry.h
//  Dompetku
//
//  Created by Indosat on 12/6/14.
//
//

#import "RLMObject.h"
#import <Realm.h>

@interface NetraUserInquiry : RLMObject
@property NSInteger id;
@property NSString *guid;
@property NSDate *createdAt;
@property NSDate *updatedAt;
@property NSString *balance;
@property BOOL billpayQueryState;
@property BOOL billpayState;
@property NSString *status;
@property NSString *trxid;
@property NSString *name;
@property NSString *lastRevisionGuid;

+ (NetraUserInquiry *)getUserInquiry;
+ (void)save:(NetraUserInquiry *)userInquiry withRevision:(BOOL)revision;
@end
RLM_ARRAY_TYPE(NetraUserInquiry);
// Defines an RLMArray<Dog> type