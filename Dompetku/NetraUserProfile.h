//
//  NetraUserProfile.h
//  Dompetku
//
//  Created by Indosat on 11/30/14.
//
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
@interface NetraUserProfile : NSObject
@property (nonatomic, assign) BOOL billpayQueryState;
@property (nonatomic, assign) BOOL billpayState;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *trxid;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *balance;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *transid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *agent;
@property (nonatomic,strong) NSString *agentData;




+ (NSString *)reversedString:(NSString *)pin;
+ (void)login:(NSDictionary *)params;
+ (void)getUserInquiry;
- (instancetype)initWithUserBasicAttribute:(NSDictionary *)attributes;
- (instancetype)initWithUserInquiryAttributes:(NSDictionary *)attributes;
+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key;
- (NSURLSessionDataTask *)login:(NSDictionary *)params login:(void (^)(NSArray *posts, NSError *error))block;
+ (NSURLSessionDataTask *)userInquiry:(void (^)(NSArray *posts, NSError *error))block;
+ (NSURLSessionDataTask *)otpSend:(NSDictionary *)params login:(void (^)(NSArray *posts, NSError *error))block;

@end