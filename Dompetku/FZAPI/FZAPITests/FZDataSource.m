//
//  FZDataSource.m
//  FZAPI
//
//  Created by Matthieu Barile on 23/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import "FZDataSource.h"

@implementation FZDataSource

+ (NSDictionary *)dataSourceFromDictionary: (NSDictionary *)aDictionary {
    
    if(aDictionary && [aDictionary count] > 0) {
        
        NSDictionary *returnedDictionary = [[NSMutableDictionary alloc] initWithCapacity:[aDictionary count]];
        
        for (NSDictionary *subDictionary in aDictionary) {
                        
            [returnedDictionary setValue:[subDictionary objectForKey:@"datasource"] forKey:[subDictionary objectForKey:@"test"]];
            
        }
        
        return returnedDictionary;
        
    } else {
        
        return nil;
    }
}

@end