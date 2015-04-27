//
//  NewRegistrationViewController.h
//  Dompetku
//
//  Created by Indosat on 1/15/15.
//
//

#import <UIKit/UIKit.h>
#import <ActionSheetStringPicker.h>
#import <ActionSheetDatePicker.h>
@interface NewRegistrationViewController : UIViewController
@property (nonatomic,strong)ActionSheetDatePicker *datePickers;
@property (nonatomic,strong)ActionSheetStringPicker *stringPickers;
@property (nonatomic,strong)NSDate *dateNow;
@end
