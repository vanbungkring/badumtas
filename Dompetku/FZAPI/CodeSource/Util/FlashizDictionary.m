//
//  FlashizDictionary.m
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 19/12/13.
//  Copyright (c) 2013 Flashiz. All rights reserved.
//

#import "FlashizDictionary.h"

@implementation FlashizDictionary {
    NSDictionary *internalDictionary;
}

- (instancetype)initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    self = [super init];
    if(self) {
        internalDictionary = [[NSDictionary alloc] initWithObjects:objects
                                                           forKeys:keys
                                                             count:cnt];
    }
    return self;
}

- (NSUInteger)count {
    return [internalDictionary count];
}

- (id)objectForKey:(id)aKey {
    return [internalDictionary objectForKey:aKey];
}

- (NSEnumerator *)keyEnumerator {
    return [internalDictionary keyEnumerator];
}

/*
 * Conpare if the keys we've defined are in the server response
 * keysArray: keys define as the contract
 * [self allKeys]: keys from the server reponse
 */
- (BOOL)containsKeys:(NSArray *)keysArray missingKeys:(NSMutableArray *)missingKeysArray{
    
    BOOL result = YES;
    
    for(id key in keysArray){
        
        //if the dictionary does not contain the key
        if(![[self allKeys] containsObject:key]){
            
            result = NO;
            
            if(missingKeysArray != nil) {
                [missingKeysArray addObject:key];
            }
        }
    }
    
    return result;
}

@end
