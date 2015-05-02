//
//  FZTemplateFontProtocol.h
//  FZBlackBox
//
//  Created by Olivier Demolliens on 4/17/14.
//  Copyright (c) 2014 FLASHiZ. All rights reserved.
//

#import <Foundation/Foundation.h>

//Enum
#import <FZAPI/FZFilesEnum.h>

///FW
#import <CoreGraphics/CGBase.h>
#import <UIKit/UIFont.h>

@protocol FZTemplateFontProtocol <NSObject>

- (NSString*) futurConFileName;
- (NSString*) futurConLigFileName;
- (NSString*) helveticaFileName;
- (NSString*) helveticaBoldFileName;

- (NSString*) futurConName;
- (NSString*) futurConLigName;
- (NSString*) helveticaName;
- (NSString*) helveticaBoldName;

- (FZBundleName) bundleType;

@end
