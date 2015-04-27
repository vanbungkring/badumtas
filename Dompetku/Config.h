//
//  Config.h
//  Dompetku
//
//  Created by Indosat on 1/9/15.
//
//

#import "RLMObject.h"

@interface Config : RLMObject
@property (nonatomic)NSInteger id;
@property (nonatomic)BOOL isGuide;
@property (nonatomic)BOOL isOTP;
+ (void)save:(Config *)log withRevision:(BOOL)revision;
+ (Config *)getConfigOTP;
+ (Config *)getConfigGuides;
@end
