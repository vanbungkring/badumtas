//
//  FlashizDictionary.h
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 19/12/13.
//  Copyright (c) 2013 Flashiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlashizDictionary : NSDictionary

/**
 @brief Function that check if the NSDictionary receiver contains all the keys which are in the keysArray NSArray. If it is the case it returns YES. Otherwise, it returns NO and the missingKeysArray is filled with all the missing keys.
 @param keysArray the array containing the keys we want to check on the NSDictionary
 @param missingKeysArray An array that will contain the keys that was not found in the NSDictionary. Can be nil
 @return YES if all the keys was found, NO otherwise
 */
- (BOOL)containsKeys:(NSArray *)keysArray missingKeys:(NSMutableArray *)missingKeysArray;

@end
