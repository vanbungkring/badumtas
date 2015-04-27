//
//  ModelBeli+BayarManager.h
//  Dompetku
//
//  Created by Indosat on 12/19/14.
//
//

#import <Foundation/Foundation.h>

@interface ModelBeli_BayarManager : NSObject
@property (nonatomic,strong) NSString *jsonMid;
@property (nonatomic,strong) NSString *jsonMnama;
@property (nonatomic,strong) NSString *jsonMimage;
@property (nonatomic,strong) NSArray  *jsonSub;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end
