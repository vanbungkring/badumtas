//
//  NetraUserModel.h
//  Dompetku
//
//  Created by Indosat on 12/6/14.
//
//

#import "RLMObject.h"
#import "NetraUserInquiry.h"
@interface netraUserModel : RLMObject
@property NSInteger id;
@property NSString *guid;
@property NSDate *createdAt;
@property NSDate *updatedAt;
@property NSString *userNumber;
@property NSString *pin;
@property NSString *lastRevisionGuid;
@property BOOL billpayQueryState;
@property BOOL billpayState;
@property NSString *status;
@property NSString *trxid;
@property NSString *msg;
@property NSString *tripleDes;
@property RLMArray <NetraUserInquiry>*userInquiry;


+ (netraUserModel *)getUserProfile;
+ (void)save:(netraUserModel *)userProfile withRevision:(BOOL)revision;
@end