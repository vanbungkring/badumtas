//
//  NetraCommonFunction.h
//  Dompetku
//
//  Created by Indosat on 11/23/14.
//
//

#import <Foundation/Foundation.h>
#define BLUE_BORDER_COLOR [UIColor colorWithRed:60/255.f green:93/255.f blue:170/255.f alpha:1]
#define GRAY_BORDER_COLOR [UIColor colorWithRed:0.282 green:0.282 blue:0.282 alpha:1]
#define ORANGE_BORDER_COLOR [UIColor colorWithRed:0.953 green:0.435 blue:0.129 alpha:1]
#define LIGHT_GRAY_BORDER_COLOR [UIColor colorWithRed:191/255.f green:191/255.f blue:191/255.f alpha:1]
@interface NetraCommonFunction : NSObject

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (id)setAndFormatObjectFromOldKey:(NSString *)oldKey toNewKey:(NSString *)newKey withFormatType:(NSString *)type;
- (NSMutableDictionary *) getMutableDictionary;


@property NSMutableDictionary *mutableDictionary;
@property NSDictionary *dictionary;

+ (NetraCommonFunction *)sharedCommonFunction;

-(void)giveBorderTo:(UIView *)view
          withColor:(UIColor *)color;
-(NSString *)formatToRupiah:(NSNumber *)charge;
-(void)giveBorderTo:(UIView *)view
         withRadius:(float)radius
    withBorderWidth:(float)width
          withColor:(UIColor *)color;

-(void)giveCornerTo:(UIView *)view
         withRadius:(float)radius;

-(void)giveBorderTo:(UIView *)view
          withColor:(UIColor *)color
   withCornerRadius:(CGFloat)cornerRadius
    withBorderWidth:(CGFloat)borderWidth;

-(BOOL) isValidEmail:(NSString *)checkString;
-(NSString *)pathForFile:(NSString *)fileName;
-(BOOL)checkIfFileExist:(NSString *)fileName;
-(void)deleteItemName:(NSString *)itemName;
-(NSString *)documentPath;
-(NSArray *)getDocumentDirectoryContents;
-(void)setAlert:(NSString *)title message:(NSString *)message;
-(NSString *)tripleDesGenerate:(NSString *)pin;
@end


