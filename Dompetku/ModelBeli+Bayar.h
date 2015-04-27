//
//  ModelBeli.h
//  Dompetku
//
//  Created by Indosat on 11/28/14.
//
//

#import <Foundation/Foundation.h>
#import "SubMerchant.h"
#import "RLMObject.h"
#import "RLMArray.h"
@class SubMerchant;

@interface ModelBeli_Bayar  : RLMObject
@property NSInteger id;
@property NSString *guid;
@property NSDate *createdAt;
@property NSDate *updatedAt;
@property NSString* mid;
@property NSString *mnama;
@property NSString *mimage;
@property BOOL isBeli;
@property NSString *lastRevisionGuid;


//@property (nonatomic,strong) NSString *jsonMid;
//@property (nonatomic,strong) NSString *jsonMnama;
//@property (nonatomic,strong) NSString *jsonMimage;
//@property (nonatomic,strong) NSArray  *jsonSub;

+(void)fetchBeli;
+(void)fetchBayar;
+ (NSURLSessionDataTask *)getDataFromModelBeli:(void (^)(NSArray *beli,NSArray *bayar, NSError *error))block;
+(void)insertManager:(NSArray *)data isBeli:(BOOL)isBeli;
+ (void)save:(ModelBeli_Bayar *)userInquiry withRevision:(BOOL)revision;
+(void)removeBeli;
+ (ModelBeli_Bayar *)getByID:(NSInteger)mmid;
+ (NSArray *)isBeliStatus:(BOOL)isBeli;
+ (ModelBeli_Bayar *)getByParentID:(NSString *)ids;
@end

