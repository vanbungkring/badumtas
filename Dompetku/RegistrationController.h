//
//  RegistrationController.h
//  Dompetku
//
//  Created by iMac on 11/16/14.
//
//

#import <UIKit/UIKit.h>
#import "AbstractActionSheetPicker.h"

@class AbstractActionSheetPicker;
@class RadioButton;

@interface RegistrationController : UIViewController <UITextFieldDelegate> {
    NSInteger day, month, year;
    NSInteger selectedDayIdx, selectedMonthIdx, selectedYearIdx;
}

@property (nonatomic, strong) NSArray *days;
@property (nonatomic, strong) NSArray *months;
@property (nonatomic, strong) NSMutableArray *years;
@property (nonatomic, strong) NSString *selectedDay, *selectedMonth, *selectedYear;

@property (strong, nonatomic) IBOutlet RadioButton *gender;
@property (strong, nonatomic) IBOutlet UITextField *txtFullName;
@property (strong, nonatomic) IBOutlet UITextField *txtMotherName;
@property (strong, nonatomic) IBOutlet UITextField *txtHP;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPin;
@property (strong, nonatomic) IBOutlet UITextField *txtConfirmationPin;
@property (strong, nonatomic) IBOutlet UIButton *txtDay;
@property (strong, nonatomic) IBOutlet UIButton *txtMonth;
@property (strong, nonatomic) IBOutlet UIButton *txtYear;
@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;

- (IBAction)onMonthSelected:(id)sender;
- (IBAction)onYearSelected:(id)sender;
- (IBAction)onDaySelected:(id)sender;
- (IBAction)onCheckboxChanged:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)onGenderSelected:(RadioButton *)sender;
-(BOOL) textFieldShouldReturn:(UITextField *)textField;


@end
