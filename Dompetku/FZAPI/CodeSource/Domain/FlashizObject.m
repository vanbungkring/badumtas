//
//  FlashizObject.m
//  flashiz_ios_api
//
//  Created by Yvan Moté on 17/12/13.
//  Copyright (c) 2013 Flashiz. All rights reserved.
//

#import "FlashizObject.h"

#import "Error.h"

@implementation FlashizObject

- (void)fillWithMatchingKeys:(NSArray *)matchingKeys
                        keys:(NSArray *)keys
                    fromJSON:(NSDictionary *)JSON
                successBlock:(FillObjectSuccessBlock)success
                failureBlock:(FillObjectFailureBlock)failure {
    
    NSInteger numberOfMatchingKeys = [matchingKeys count];
    NSInteger numberOfKeys = [keys count];
    
    BOOL isValidMatchingKeys = (numberOfMatchingKeys>0 && numberOfMatchingKeys==numberOfKeys);
    
    if (!isValidMatchingKeys) {
        
        //Debug
        NSLog(@"%@ \n %@",[NSString stringWithFormat:FZ_JSON_NUMBER_OF_KEYS_BETWEEN_SERVER_AND_OBJECT,(long)numberOfMatchingKeys,(long)numberOfKeys],JSON);
        //Nota:
        //If Count of matching keys (0) differs from count of keys (X), check if matchingKeys != nil or is well define
        
        
        Error *error = [[Error alloc] initWithRequest:nil
                                             response:nil
                                            timestamp:[NSDate date]
                                          messageCode:[NSString stringWithFormat:FZ_JSON_NUMBER_OF_KEYS_BETWEEN_SERVER_AND_OBJECT,(long)numberOfMatchingKeys,(long)numberOfKeys]
                                               detail:nil
                                                 code:FZ_JSON_MISSING_KEYS_ERROR_CODE
                                  andRequestErrorCode:FZ_JSON_MISSING_KEYS_ERROR_CODE];
        
        failure(error);
    } else {
        for(NSInteger i=0;i<[keys count];i++) {
            
            NSString *key = [keys objectAtIndex:i];
            NSString *matchingKey = @"";
            
            if(numberOfMatchingKeys>0) {
                matchingKey = [matchingKeys objectAtIndex:i];
            }
            
            id value = [JSON objectForKey:key];
            
            if(value!=[NSNull null] && value!=nil) {
                if([matchingKey length]>0) {
                    [self setValue:value forKey:matchingKey];
                }
                else {
                    [self setValue:value forKey:key];
                }
            }
        }
        
        success();
    }
}

@end
