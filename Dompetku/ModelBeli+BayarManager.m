//
//  ModelBeli+BayarManager.m
//  Dompetku
//
//  Created by Indosat on 12/19/14.
//
//

#import "ModelBeli+BayarManager.h"

@implementation ModelBeli_BayarManager
- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.jsonMid = [attributes valueForKeyPath:@"mid"];
    self.jsonMnama = [attributes valueForKeyPath:@"mnama"];
    self.jsonMimage = [attributes valueForKeyPath:@"mimage"];
    self.jsonSub =[attributes valueForKeyPath:@"sub_merchant"];

    return self;
}
@end
