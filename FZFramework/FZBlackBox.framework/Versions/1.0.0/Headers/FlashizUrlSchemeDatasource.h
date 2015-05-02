//
//  FlashizUrlSchemeDatasource.h
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 25/02/14.
//  Copyright (c) 2014 Flashiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FlashizUrlSchemeDatasource <NSObject>

- (NSString *)customUrlScheme;
- (NSString *)customUrlHost;

@end
