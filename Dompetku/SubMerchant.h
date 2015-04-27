//
//  SubMerchant.h
//  Dompetku
//
//  Created by Indosat on 12/19/14.
//
//

#import "RLMObject.h"

@interface SubMerchant : RLMObject
@property NSInteger id;
@property NSString *guid;
@property NSDate *createdAt;
@property NSDate *updatedAt;
@property NSString *sub_merchant_id;
@property NSString *sub_merchant_nama;
@property NSString *img_path;
@property NSString *lastRevisionGuid;
@property NSString *parentId;
+ (void)save:(SubMerchant *)sub withRevision:(BOOL)revision;
+ (NSArray *)getAllSubmerchantById:(NSInteger)subId;
@end
