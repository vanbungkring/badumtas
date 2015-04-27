//
//  NetraCommonFunction.m
//  Dompetku
//
//  Created by Indosat on 11/23/14.
//
//

#import "NetraCommonFunction.h"
#import "NetraUserModel.h"
#import "NetraUserProfile.h"
@implementation NetraCommonFunction

+ (NetraCommonFunction *)sharedCommonFunction {
    static dispatch_once_t pred;
    static NetraCommonFunction *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[NetraCommonFunction alloc] init];
    });
    return shared;
}
-(NSString *)formatToRupiah:(NSNumber *)charge{
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setGroupingSeparator:@"."];
    nf.usesGroupingSeparator = YES;
    nf.numberStyle = NSNumberFormatterDecimalStyle;
    [nf setMaximumFractionDigits:0];
    nf.roundingMode = NSNumberFormatterRoundFloor;
    return [nf stringFromNumber:charge];
}


-(void)giveBorderTo:(UIView *)view
          withColor:(UIColor *)color{
    CALayer *layer = view.layer;
    [layer setCornerRadius:10];
    [layer setBorderWidth:0.5];
    layer.borderColor=[color CGColor];
}

-(void)giveBorderTo:(UIView *)view
          withColor:(UIColor *)color
   withCornerRadius:(CGFloat)cornerRadius
    withBorderWidth:(CGFloat)borderWidth{
    CALayer *layer = view.layer;
    [layer setCornerRadius:cornerRadius];
    [layer setBorderWidth:borderWidth];
    layer.borderColor=[color CGColor];
}

-(void)giveCornerTo:(UIView *)view
         withRadius:(float)radius{
    CALayer *layer = view.layer;
    [layer setCornerRadius:radius];
}


-(void)giveBorderTo:(UIView *)view
         withRadius:(float)radius
    withBorderWidth:(float)width
          withColor:(UIColor *)color{
    CALayer *layer = view.layer;
    [layer setCornerRadius:radius];
    [layer setBorderWidth:width];
    layer.borderColor=[color CGColor];
}

-(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark - write access

-(NSString *)documentPath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

-(NSString *)pathForFile:(NSString *)fileName{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    return filePath;
}

-(BOOL)checkIfFileExist:(NSString *)fileName{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self pathForFile:fileName]];
}

-(NSArray *)getDocumentDirectoryContents{
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self documentPath] error:nil];
}

-(void)deleteItemName:(NSString *)itemName{
    [[NSFileManager defaultManager]removeItemAtPath:[self pathForFile:itemName] error:nil];
}

-(void)setAlert:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}
- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        self.dictionary = dictionary;
        self.mutableDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(NSString *)tripleDesGenerate:(NSString *)pin{
    netraUserModel *model = [netraUserModel getUserProfile];
    NSString *secretKey = [NSString stringWithFormat:@"%@%@|%@|%@",
                           TimeStamp,
                           pin,
                           [NetraUserProfile reversedString:pin],
                           model.userNumber];
    NSLog(@"secretKye->%@",secretKey);
    return [NetraUserProfile TripleDES:secretKey encryptOrDecrypt:kCCEncrypt key:secretKeyGlobal];
}
@end
