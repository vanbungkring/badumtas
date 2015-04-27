//
//  Tip.h
//  FZAPI
//
//  Created by Matthieu Barile on 29/10/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <FZAPI/FZAPI.h>

#import "FlashizObject.h"

@interface Tip : FlashizObject

@property (nonatomic, assign) double suggestedAmount;
@property (nonatomic, assign) double firstProposition;
@property (nonatomic, assign) double secondProposition;

+ (void)tipWithDictionary:(NSDictionary *)tip successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure;

@end
