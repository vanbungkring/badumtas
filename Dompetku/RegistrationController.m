//
//  RegistrationController.m
//  Dompetku
//
//  Created by iMac on 11/16/14.
//
//

#import "RegistrationController.h"
#import "RadioButton.h"
#import "M13Checkbox.h"

#import "AbstractActionSheetPicker.h"
#import "ActionSheetCustomPicker.h"
#import "ActionSheetCustomPickerDelegate.h"
#import "ActionSheetStringPicker.h"
#import "ActionSheetDatePicker.h"
#import "ActionSheetDistancePicker.h"

@interface RegistrationController ()
@property (strong, nonatomic) IBOutlet UIControl *controls;

@end

@implementation RegistrationController

@synthesize days = _days;
@synthesize months = _months;
@synthesize years = _years;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.txtFullName.delegate = self;
    self.txtMotherName.delegate = self;
    self.txtHP.delegate = self;
    self.txtEmail.delegate = self;
    self.txtPin.delegate = self;
    self.txtConfirmationPin.delegate = self;
    
    for (int i=1; i<10; i++) {
        [[NetraCommonFunction sharedCommonFunction]giveBorderTo:[self.view viewWithTag:i]
                                                      withColor:ORANGE_BORDER_COLOR
                                               withCornerRadius:20
                                                withBorderWidth:2];
    }
    for (UIView *view in [_controls subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            textField.leftView = paddingView;
            textField.delegate =self;
            textField.leftViewMode = UITextFieldViewModeAlways;
            // do something with textField
        }
    }
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    day = [components day];
    month = [components month];
    year = [components year];
    NSLog(@"year %i", year);
    
    [self.txtDay setTitle:[NSString stringWithFormat:@"%i", day]  forState: UIControlStateNormal];
    [self.txtMonth setTitle:[NSString stringWithFormat:@"%i", month]  forState: UIControlStateNormal];
    [self.txtYear setTitle:[NSString stringWithFormat:@"%i", year]  forState: UIControlStateNormal];
    
    self.days = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30", @"31"];
    self.months = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12"];
    
    self.years=[[NSMutableArray alloc] init];
    for (int i=1940; i<=year; i++) {
        [self.years addObject:[NSDecimalNumber numberWithInt:i]];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    //show navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics: UIBarMetricsDefault];
    
    self.navigationItem.title = NSLocalizedString(@"Registration", nil);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onMonthSelected:(id)sender {
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        selectedMonthIdx = selectedIndex;
        self.selectedMonth = [NSString stringWithFormat:@"%@", selectedValue];
        NSLog(@"Selected Month %@", self.selectedMonth);
        
        [self.txtMonth setTitle:[NSString stringWithFormat:@"%@", self.selectedMonth]  forState: UIControlStateNormal];
    };
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Month Picker Canceled");
    };
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select Month" rows:self.months initialSelection:month-1 doneBlock:done cancelBlock:cancel origin:sender];
}

- (IBAction)onYearSelected:(id)sender {
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        selectedYearIdx = selectedIndex;
        self.selectedYear = [NSString stringWithFormat:@"%@", selectedValue];
        NSLog(@"Selected Year %@", self.selectedYear);
        
        [self.txtYear setTitle:[NSString stringWithFormat:@"%@", self.selectedYear]  forState: UIControlStateNormal];
    };
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Year Picker Canceled");
    };
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select Year" rows:self.years initialSelection:year-1940 doneBlock:done cancelBlock:cancel origin:sender];
}

- (IBAction)onDaySelected:(id)sender {
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        selectedDayIdx = selectedIndex;
        self.selectedDay = [NSString stringWithFormat:@"%@", selectedValue];
        NSLog(@"Selected Day %@", self.selectedDay);
        
        [self.txtDay setTitle:[NSString stringWithFormat:@"%@", self.selectedDay]  forState: UIControlStateNormal];
    };
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Day Picker Canceled");
    };
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select Day" rows:self.days initialSelection:day-1 doneBlock:done cancelBlock:cancel origin:sender];
}

- (IBAction)onCheckboxChanged:(id)sender {
    M13Checkbox *checkbox = (M13Checkbox*) sender;
    
    if( checkbox.checkState ) {
        NSLog(@"Checked");
    }
    else {
        NSLog(@"Unchecked");
    }
}

- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)onGenderSelected:(RadioButton *)sender {
    NSLog(@"SELECTED %@", sender.titleLabel.text);
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if(textField.returnKeyType==UIReturnKeyNext) {
        UIView *next = [[textField superview] viewWithTag:textField.tag+1];
        [next becomeFirstResponder];
    } else if (textField.returnKeyType==UIReturnKeyDone) {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
