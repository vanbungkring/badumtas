//
//  TranscationDetailSharedViewController.m
//  Dompetku
//
//  Created by Indosat on 11/30/14.
//
//

#import "TranscationDetailSharedViewController.h"
#import "transactionMapping.h"
#import "NSDate+TCUtils.h"
#import "NetraCommonFunction.h"
#import <ActionSheetStringPicker.h>
#import <ActionSheetDatePicker.h>
#import "NetraCommonFunction.h"
#import "searchStasiunTableViewController.h"
#import <AddressBook/AddressBook.h>
#import "transactionFavorite.h"
#import <AddressBookUI/AddressBookUI.h>
@interface TranscationDetailSharedViewController ()<UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate,UINavigationControllerDelegate,ABPersonViewControllerDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)NSArray *id_isi_dropdown;
@property (nonatomic,strong)NSArray *data;
@property (nonatomic,strong)NSArray *stasiun;
@property (nonatomic,strong)NSArray *isi_dropdown;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSDate *selectedTime;
@end
float Top = 74;
float last_frame;
BOOL isPhoneNumber=0;
NSInteger tags;
NSInteger tags_favorite;
NSInteger tags_default;
@implementation TranscationDetailSharedViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [transactionMapping getTransactionByCategory:_state merchant:_transactionJenis];
    NSLog(@"transaction jenis-->%@",_transactionJenis);
    NSLog(@"transaction jenis-->%@",_state);
    
    self.view.backgroundColor =[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -60, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:scroll];
    UIButton *overlay;
    _data = [transactionMapping getTransactionByCategory:_state merchant:_transactionJenis];
    if (_data) {
        for (int i=1; i<=_data.count; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(21, i*Top, self.view.frame.size.width, 28)];
            
            label.text = [[_data objectAtIndex:i-1]objectForKey:@"label"];
            label.numberOfLines = 2;
            label.font = [UIFont fontWithName:@"AvenirNext-Medium" size:18];
            
            self.selectedDate = [NSDate date];
            self.selectedTime = [NSDate date];
            
            _textField = [[UITextField alloc]initWithFrame:CGRectMake(21, i*Top+25, self.view.frame.size.width-35, 40)];
            _textField.delegate = self;
            _textField.tag = i;
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            _textField.leftView = paddingView;
            _textField.leftViewMode = UITextFieldViewModeAlways;
            [[NetraCommonFunction sharedCommonFunction]giveBorderTo:_textField
                                                          withColor:ORANGE_BORDER_COLOR
                                                   withCornerRadius:20
                                                    withBorderWidth:2];
            
            UIButton *addToFavorite= [UIButton buttonWithType:UIButtonTypeCustom];
            [addToFavorite setBackgroundImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
            [addToFavorite setBackgroundImage:[UIImage imageNamed:@"star_"] forState:UIControlStateHighlighted];
            [addToFavorite addTarget:self action:@selector(saveToFavorite:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *findContact= [UIButton buttonWithType:UIButtonTypeCustom];
            [findContact setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
            [findContact setBackgroundImage:[UIImage imageNamed:@"search_"] forState:UIControlStateHighlighted];
            [findContact addTarget:self action:@selector(openContact:) forControlEvents:UIControlEventTouchUpInside];
            
            CGRect frames = _textField.frame;
            frames.size.width = self.view.frame.size.width-100;
            if([[[_data objectAtIndex:i-1]objectForKey:@"textview_type"]integerValue]==1){
                isPhoneNumber=1;
            }
            else{
                isPhoneNumber=0;
            }
            switch ([[[_data objectAtIndex:i-1]objectForKey:@"textview_type"]integerValue]) {
                case 2:
                    [_textField addTarget:self action:@selector(openCalendar:) forControlEvents:UIControlEventAllTouchEvents];
                    tags = _textField.tag;
                    break;
                case 3:
                    [_textField setSecureTextEntry:YES];
                    break;
                case 1:
                    [_textField setFrame:frames];
                    tags = _textField.tag;
                    [findContact setFrame:CGRectMake(_textField.frame.size.width+_textField.frame.origin.x +5, _textField.frame.size.height+_textField.frame.origin.y-35, 30, 30)];
                    NSLog(@"dac->%@",NSStringFromCGRect(findContact.frame));
                    [scroll addSubview:findContact];
                    
                    break;
                case 6:
                    overlay.frame = _textField.frame;
                    overlay.backgroundColor = [UIColor redColor];
                    [overlay addTarget:self action:@selector(openKrl:) forControlEvents:UIControlEventTouchUpInside];
                    [_textField addSubview:overlay];
                    
                    break;
                default:
                    
                    break;
            }
            switch ([[[_data objectAtIndex:i-1]objectForKey:@"field_tipe"]integerValue]) {
                case 1:
                    NSLog(@"data");
                    [_textField addTarget:self action:@selector(openActionSheet:) forControlEvents:UIControlEventAllTouchEvents];
                    tags_default = _textField.tag;
                    
                    break;
                    
                default:
                    break;
            }
            if ([[_data objectAtIndex:i-1]objectForKey:@"is_favorite"]) {
                switch ([[[_data objectAtIndex:i-1]objectForKey:@"is_favorite"]integerValue]) {
                    case 1:
                        
                        [_textField setFrame:frames];
                        tags_favorite = _textField.tag;
                        label.tag = 1000+tags_favorite;
                        if (isPhoneNumber) {
                            [addToFavorite setFrame:CGRectMake(_textField.frame.size.width+_textField.frame.origin.x +40, _textField.frame.size.height+_textField.frame.origin.y-35, 30, 30)];
                        }
                        else{
                            [addToFavorite setFrame:CGRectMake(_textField.frame.size.width+_textField.frame.origin.x +20, _textField.frame.size.height+_textField.frame.origin.y-35, 35, 35)];
                        }
                        [scroll addSubview:addToFavorite];
                        break;
                        
                    default:
                        break;
                }
            }
            //
            [scroll addSubview:label];
            [scroll addSubview:_textField];
            last_frame =_textField.frame.origin.y+_textField.frame.size.height;
        }
    }
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(103, last_frame+30, 114, 38);
    if ([_state isEqualToString:@"Beli"]) {
        [submitButton setBackgroundImage:[UIImage imageNamed:@"button-beli"] forState:UIControlStateNormal];
    }
    else{
        [submitButton setBackgroundImage:[UIImage imageNamed:@"button-bayar"] forState:UIControlStateNormal];
    }
    
    [scroll addSubview:submitButton];
    
    [scroll setContentSize:CGSizeMake(40, last_frame+200)];
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            textField.leftView = paddingView;
            textField.leftViewMode = UITextFieldViewModeAlways;
            // do something with textField
        }
    }
    [self populateData:tags_default];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(setValueOfTextField:)
     name:@"postBack"
     object:nil];
    
    // Do any additional setup after loading the view.
    
}
-(void)saveToFavorite:(id)sender{
    NSLog(@"called");
    UITextField *tf = (UITextField *)[self.view viewWithTag:tags_favorite];
    UILabel *label = (UILabel *)[self.view viewWithTag:1000+tags_favorite];
    
    if(tf.text.length ==0){
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:[NSString stringWithFormat:@"%@ Tidak Boleh Kosong",label.text]];
    }
    else{
   
    
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Masukkan Nama Favorite" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] ;
        alertView.tag = 20000;
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField = [alertView textFieldAtIndex:0];
        textField.text = [NSString stringWithFormat:@"%@_%@_%@",_transactionNameParent,[[_data objectAtIndex:0]objectForKey:@"sub_merchant_nama"],tf.text];
        
        [alertView show];
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITextField *tf = (UITextField *)[self.view viewWithTag:tags_favorite];
    UITextField * alertTextField = [alertView textFieldAtIndex:0];
            transactionFavorite *t  = [[transactionFavorite alloc]init];
            t.state =_state;
            t.transactionJenis = _transactionJenis;
            t.merchant =[[_data objectAtIndex:0]objectForKey:@"sub_merchant_nama"];
            t.parent = _transactionNameParent;
            t.tags =[NSString stringWithFormat:@"%d",tags_favorite];
            t.fieldInformation =tf.text;
            t.name = alertTextField.text;
            [transactionFavorite save:t withRevision:YES];
    NSLog(@"alerttextfiled - %@",alertTextField.text);
    
    // do whatever you want to do with this UITextField.
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
-(void)setValueOfTextField:(NSNotification *)notification{
    
        
//    NSDictionary *dictionary = [notification userInfo];
//    NSInteger a = [[dictionary objectForKeyedSubscript:@"key"]integerValue];
//    UITextField *tf = (UITextField *)[self.view viewWithTag:a];
//    tf.text = [dictionary objectForKey:@"value"];
    
    
}
-(void)openKrl:(UIControl *)sender{
    
    searchStasiunTableViewController *vc = [[searchStasiunTableViewController alloc]init];
    vc.tagss=[NSString stringWithFormat:@"%d",[sender tag]];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    
    [self.navigationController presentViewController:nav
                                            animated:YES completion:nil];
}
-(void)openCalendar:(id)sender{
    
    _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:self.selectedDate target:self action:@selector(dateWasSelected:element:) origin:sender];
    self.actionSheetPicker.hideCancel = false;
    
    [self.actionSheetPicker showActionSheetPicker];
    
}
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    self.selectedDate = selectedDate;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd,MMMM YYYY";
    [(UITextField *)[self.view viewWithTag:[element tag]] setText:[dateFormatter stringFromDate:self.selectedDate]];
    [(UITextField *)[self.view viewWithTag:[element tag]] resignFirstResponder];
}
- (void)openContact:(UITextField *)sender {
    ABPeoplePickerNavigationController *addressBookController = [[ABPeoplePickerNavigationController alloc]init];
    addressBookController.peoplePickerDelegate = self;
    [addressBookController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    addressBookController.delegate = self;
    
    addressBookController.navigationBar.tintColor = [UIColor blackColor];
    addressBookController.searchDisplayController.searchBar.tintColor = [UIColor blackColor];
    
    addressBookController.searchDisplayController.searchBar.backgroundColor = [UIColor blackColor];
    [self presentViewController:addressBookController animated:YES completion:^{
        
    }];
    addressBookController = nil;
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    ABMultiValueRef phone = ABRecordCopyValue(person, property);
    UITextField *tf = (UITextField *)[self.view viewWithTag:tags];
    tf.text = [[[[NSString stringWithFormat:@"%@",(__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, ABMultiValueGetIndexForIdentifier(phone, identifier))] stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"-" withString:@""]stringByReplacingOccurrencesOfString:@"+62" withString:@"0"];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    ABPersonViewController *controller = [[ABPersonViewController alloc] init];
    controller.displayedPerson = person;
    controller.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonEmailProperty]];
    controller.personViewDelegate = self;
    [peoplePicker pushViewController:controller animated:YES];
    return NO;
}
-(BOOL)personViewController:(ABPersonViewController *)personViewController
shouldPerformDefaultActionForPerson:(ABRecordRef)person
                   property:(ABPropertyID)property
                 identifier:(ABMultiValueIdentifier)identifierForValue
{
    ABMutableMultiValueRef multiEmail = ABRecordCopyValue(person, property);
    
    NSString *emailAddress = (__bridge NSString *) ABMultiValueCopyValueAtIndex(multiEmail, identifierForValue);
    
    NSLog(@"strEmail %@",emailAddress);
    
    ABPeoplePickerNavigationController *peoplePicker = (ABPeoplePickerNavigationController *)personViewController.navigationController;
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    ///do stuff here
    ABMultiValueRef phones = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString *phoneStr = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, 0);
    
    //strip number from brakets
    NSMutableString *tmpStr1 = [NSMutableString stringWithFormat:@"%@", phoneStr];
    NSString *strippedStr1 = [tmpStr1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"()-"];
    strippedStr1 = [[strippedStr1 componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
    
    UITextField *tf = (UITextField *)[self.view viewWithTag:tags];
    NSString *pn =[[[strippedStr1 stringByReplacingOccurrencesOfString:@"+62" withString:@"0"] stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"  " withString:@""];
    
    tf.text = [[pn componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];;
    NSLog(@"called 2 ->%@", tf.text);
    //dismiss
    if (![strippedStr1 isEqualToString:@"null"]) {
        [self dismissModalViewControllerAnimated:YES];
    }
    else{
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Phone Number Cannot Be null"];
    }
    
    
    return NO;
}
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)openActionSheet:(id)sender{
    [_textField resignFirstResponder];
    [(UITextField *)[self.view viewWithTag:[sender tag]] resignFirstResponder];
    [ActionSheetStringPicker showPickerWithTitle:@"Pick"
                                            rows:[[[_data objectAtIndex:[sender tag]-1]objectForKey:@"isi_dropdown"] componentsSeparatedByString:@";"]
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           NSLog(@"Picker: %@", picker);
                                           NSLog(@"Selected Index: %ld", (long)selectedIndex);
                                           [self selectedValue:selectedIndex  element:sender];
                                           [(UITextField *)[self.view viewWithTag:[sender tag]] resignFirstResponder];
                                           NSLog(@"Selected Value: %@", selectedValue);
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         [(UITextField *)[self.view viewWithTag:[sender tag]] resignFirstResponder];
                                     }
                                          origin:sender];
}
- (void)selectedValue:(NSInteger)selectedIndex element:(id)element {
    [(UITextField *)[self.view viewWithTag:[element tag]] setText:[[[[_data objectAtIndex:[element tag]-1]objectForKey:@"isi_dropdown"] componentsSeparatedByString:@";"] objectAtIndex:selectedIndex]];
    
}
-(void)populateData:(int)element{
    NSLog(@"elemetn--->%@",[[[[_data objectAtIndex:element-1]objectForKey:@"isi_dropdown"] componentsSeparatedByString:@";"] objectAtIndex:0]);
    [(UITextField *)[self.view viewWithTag:element] setText:[[[[_data objectAtIndex:element-1]objectForKey:@"isi_dropdown"] componentsSeparatedByString:@";"] objectAtIndex:0]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
