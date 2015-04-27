//
//  User.m
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 05/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "User.h"
#import "Account.h"

#import <objc/runtime.h>

static NSDateFormatter *dateFormatter = nil;

@implementation User

+ (void)userWithDictionary:(NSDictionary *)user successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure {
    
    //create the array of which keys we need to have to create the user object
    NSArray *keysArray = [NSArray arrayWithObjects:@"username", @"firstName", @"lastName", @"email", @"phoneNumber", @"fidelitizId", @"isVerified", @"isCompany", @"canCreateCredit", @"userUpgraded", @"mailValidated",nil];

    NSArray *keysMatching = [NSArray arrayWithObjects:@"username", @"firstName", @"lastName", @"email", @"phoneNumber", @"fidelitizId", @"isVerified", @"isCompany", @"canCreateCredit", @"userUpgraded", @"mailValidated",nil];
    
    //create and return the user object if it is the case
    User *userObject = [[User alloc] init];
    
    /*
    [userObject fillWithMatchingKeys:keysMatching
                                keys:keysArray
                            fromJSON:user];
     */
    
    [userObject fillWithMatchingKeys:keysMatching
                                keys:keysArray
                            fromJSON:user successBlock:^{
                                NSString *accountKey = @"account";
                                
                                //We add a specific case for account key
                                id accountValue = [user objectForKey:accountKey];
                                //id account = [Account accountWithDictionary:accountValue];
                                [Account accountWithDictionary:accountValue successBlock:^(id object) {
                                    [userObject setValue:(Account *)object forKey:accountKey];
                                } failureBlock:^(Error *error) {
                                    NSLog(@"do not add malformed Account");
                                    //do not add malformed Account
                                }];
                                
                                //fill missing information by blank (because some accounts were created before we used trial user)
                                [self fillBlank:userObject];
                                
                                success([userObject autorelease]);
                            } failureBlock:^(Error *error) {
                                failure(error);
                            }];
}

+ (void)userWithInformationDictionary:(NSDictionary *)user successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure {
    //create the array of which keys we need to have to create the user object
    NSArray *keysArray = [NSArray arrayWithObjects:@"username", @"firstName", @"lastName", @"phoneNumber", @"gender", @"birthDate", @"nationality", @"address1", @"zipcode", @"city", @"country", @"email",@"fidelitizId", @"isVerified", @"isCompany", @"canCreateCredit", @"userUpgraded", @"mailValidated", nil];

    //mail replaced by email in JSON result (13/01/2014)
    NSArray *keysMatching = [NSArray arrayWithObjects:@"", @"", @"", @"", @"sex", @"birthday", @"", @"", @"cityCode", @"cityName", @"", @"", @"", @"", @"", @"", @"", @"", nil];
    
    //create and return the user object if it is the case
    User *userObject = [[User alloc] init];
    
    /*
    [userObject fillWithMatchingKeys:keysMatching
                                keys:keysArray
                            fromJSON:user];
     */
    [userObject fillWithMatchingKeys:keysMatching
                                keys:keysArray
                            fromJSON:user
                        successBlock:^{
                            
                            NSString *birthdateDateKey = @"birthDate";
                            
                            if (dateFormatter == nil) {
                                dateFormatter = [[NSDateFormatter alloc]init];
                                [dateFormatter setDateFormat:@"dd/MM/yyyy"];
                                NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                                [dateFormatter setTimeZone: timeZone];
                            }
                            
                            NSString *valueDate = [user objectForKey:birthdateDateKey];//1977-04-16T00:00:00Z
                            valueDate = [[valueDate componentsSeparatedByString:@"T"] objectAtIndex:0];
                            
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                            
                            NSDate *myDate = [dateFormatter dateFromString:valueDate];
                            
                            if((id)[NSNull null]!=myDate) {
                                [userObject setValue:myDate forKey:@"birthday"];
                            }
                            
                            [dateFormatter release];
                            
                            NSString *accountKey = @"account";
                            
                            //We add a specific case for account key
                            id accountValue = [user objectForKey:accountKey];
                            //id account = [Account accountWithDictionary:accountValue];
                            
                            [Account accountWithDictionary:accountValue successBlock:^(id object) {
                                [userObject setValue:(Account *)object forKey:accountKey];
                            } failureBlock:^(Error *error) {
                                NSLog(@"do not add malformed Account");
                                //do not add malformed Account
                            }];
                            
                            //fill missing information by blank (because some accounts were created before we used trial user)
                            [self fillBlank:userObject];
                            
                            success([userObject autorelease]);
                        } failureBlock:^(Error *error) {
                            failure(error);
                        }];
}

+ (void)fillBlank:(User *)aUser {
    
    if (![aUser isTrial]) {
        unsigned int varCount;
        Ivar *vars = class_copyIvarList([User class], &varCount);
        
        for (int i = 0; i < varCount; i++) {
            Ivar var = vars[i];
            
            const char* name = ivar_getName(var);
            const char* typeEncoding = ivar_getTypeEncoding(var);
            
            NSString *varName = [NSString stringWithFormat:@"%s",name];
            NSString *type = [NSString stringWithFormat:@"%s",typeEncoding];
            
            //NSLog(@"name : %s - type : %s",name,typeEncoding);
            if([type isEqualToString:@"@\"NSString\""]) {
                if([self isTextBlankOrWhitespace:[aUser valueForKey:varName]]) {
                    [aUser setValue:@" " forKey:varName];
                }
            }
        }
        
        free(vars);
    }
}

+ (BOOL)isTextBlankOrWhitespace: (NSString *)text {
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [text stringByTrimmingCharactersInSet:whitespace];
    if ([trimmed length] == 0) {
        // Text was empty or only whitespace.
        return YES;
    } else {
        return NO;
    }
}

-(User*)copyWithZone:(NSZone *)zone
{
    User *user = [[User allocWithZone:zone] init];
    
    [user setFirstName:[self firstName]];
    [user setLastName:[self lastName]];
    [user setCurrency:[self currency]];
    [user setUsername:[self username]];
    [user setEmail:[self email]];
    [user setPhoneNumber:[self phoneNumber]];
    [user setFidelitizId:[self fidelitizId]];
    
    [user setSex:[self sex]];
    [user setBirthday:[self birthday]];
    [user setNationality:[self nationality]];
    [user setAddress1:[self address1]];
    [user setCityCode:[self cityCode]];
    [user setCityName:[self cityName]];
    [user setCountry:[self country]];
    
    [user setSecretQuestion:[self secretQuestion]];
    [user setSecretAnswer:[self secretQuestion]];
    [user setPassword:[self password]];
    [user setCaptcha:[self captcha]];
    [user setCaptcha:[self pin]];
    
    [user setIsUserUpgraded:[self isUserUpgraded]];
    [user setIsMailValidated:[self isMailValidated]];
    [user setIsVerified:[self isVerified]];
    [user setIsCompany:[self isCompany]];
    [user setCanCreateCredit:[self canCreateCredit]];
    [user setAccount:[self account]];
    
    return user;
}

- (BOOL)isTrial {
    if([self isUserUpgraded] && [self isMailValidated]){
        return NO;
    } else {
        return YES;
    }
}

- (void)dealloc
{    
    [self setFirstName:nil];
    [self setLastName:nil];
    [self setCurrency:nil];
    [self setUsername:nil];
    [self setEmail:nil];
    [self setPhoneNumber:nil];
    [self setFidelitizId:nil];
    
    [self setSex:nil];
    [self setBirthday:nil];
    [self setNationality:nil];
    [self setAddress1:nil];
    [self setCityCode:nil];
    [self setCityName:nil];
    [self setCountry:nil];
    
    [self setSecretQuestion:nil];
    [self setSecretAnswer:nil];
    [self setPassword:nil];
    [self setCaptcha:nil];
    [self setCaptcha:nil];
    
    [self setAccount:nil];
    
    [super dealloc];
}

@end
