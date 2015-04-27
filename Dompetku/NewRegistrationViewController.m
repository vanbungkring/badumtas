//
//  NewRegistrationViewController.m
//  Dompetku
//
//  Created by Indosat on 1/15/15.
//
//

#import "NewRegistrationViewController.h"
#import <M13Checkbox.h>
#import "RadioButton.h"
#import <MBProgressHUD.h>
#import "InformasiDetail.h"
#import "RegisterManager.h"
#import "NetraUserProfile.h"
@interface NewRegistrationViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *registerScroller;
@property (strong, nonatomic) IBOutlet UITextField *tanggalLahirPicker;
@property (strong, nonatomic) IBOutlet UITextField *tipeIdentitas;
@property (strong, nonatomic) IBOutlet UITextField *konfPIN;
@property (strong, nonatomic) IBOutlet UITextField *PIN;
@property (strong, nonatomic) IBOutlet UITextField *namaIbuKandung;
@property (strong, nonatomic) IBOutlet UITextField *nomorIdentitas;
@property (strong, nonatomic) IBOutlet M13Checkbox *agreeChecker;
@property (strong, nonatomic) IBOutlet UITextView *alamat;
@property (strong, nonatomic) IBOutlet UITextField *namaBelakang;
@property (strong, nonatomic) IBOutlet UITextField *namaDepan;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSString *dates;
@property (nonatomic) BOOL isChecked;
@property (nonatomic) int gender;
@end

@implementation NewRegistrationViewController

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField.tag == _PIN.tag ||_PIN.tag==_konfPIN.tag){
        NSLog(@"data->%@",string);
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= MAXLENGTH || returnKey;
    }
    else{
        return YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isChecked=0;
    _gender = 1;
    _phoneNumber.userInteractionEnabled = false;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    _phoneNumber.text = [prefs stringForKey:@"msisdn"];
    _agreeChecker.hidden = false;
    [_agreeChecker setUserInteractionEnabled:YES];
    _registerScroller.delegate = self;
    _registerScroller.contentSize = CGSizeMake(320, 1900);
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    _dateNow = [NSDate date];
    for (int i=1; i<14; i++) {
        [[NetraCommonFunction sharedCommonFunction]giveBorderTo:[self.view viewWithTag:i]
                                                      withColor:LIGHT_GRAY_BORDER_COLOR
                                               withCornerRadius:20
                                                withBorderWidth:2];
    }
    for (UIView *view in [_registerScroller subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            textField.leftView = paddingView;
            textField.delegate =self;
            textField.leftViewMode = UITextFieldViewModeAlways;
            // do something with textField
        }
    }
    
}
-(void)handleTap{
    for (UIView *view in [_registerScroller subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            [textField resignFirstResponder];
            // do something with textField
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [[NetraCommonFunction sharedCommonFunction]giveBorderTo:[self.view viewWithTag:textField.tag]
                                                  withColor:ORANGE_BORDER_COLOR
                                           withCornerRadius:20
                                            withBorderWidth:2];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [[NetraCommonFunction sharedCommonFunction]giveBorderTo:[self.view viewWithTag:textField.tag]
                                                  withColor:LIGHT_GRAY_BORDER_COLOR
                                           withCornerRadius:20
                                            withBorderWidth:2];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics: UIBarMetricsDefault];
    
    self.navigationItem.title = NSLocalizedString(@"Registration", nil);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onGenderSelected:(RadioButton *)sender {
    
    NSLog(@"SELECTED %@", sender.titleLabel.text);
    if([sender.titleLabel.text isEqualToString:@"Pria"]){
        _gender=1;
    }
    else{
        _gender = 2;
    }
}

- (IBAction)onCheckboxChanged:(id)sender {
    M13Checkbox *checkbox = (M13Checkbox*) sender;
    
    if( checkbox.checkState ) {
        NSLog(@"Checked");
        _isChecked=1;
    }
    else {
        _isChecked=0;
        NSLog(@"Unchecked");
    }
}

- (IBAction)openCalendar:(id)sender {
    
    _datePickers = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:self.dateNow minimumDate:nil maximumDate:nil target:self action:@selector(dateWasSelected:element:) origin:sender];
    _datePickers.title = @"Tanggal Lahir";
    _datePickers.hideCancel = YES;
    [_datePickers showActionSheetPicker];
    
}
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    
    _dateNow = selectedDate;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM YYYY";
    NSDateFormatter* dateFormatter2 = [[NSDateFormatter alloc] init];
    dateFormatter2.dateFormat = @"ddMMYYYY";
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    _tanggalLahirPicker.text =[dateFormatter stringFromDate:_dateNow];
    _dates=[dateFormatter2 stringFromDate:_dateNow];;
}

- (IBAction)openPengenal:(id)sender {
    // Inside a IBAction method:
    
    // Create an array of strings you want to show in the picker:
    NSArray *colors = [NSArray arrayWithObjects:@"KTP", @"KITAS", @"SIM",nil];
    
    [ActionSheetStringPicker showPickerWithTitle:@"Pilih Tanda Pengenal"
                                            rows:colors
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           _tipeIdentitas.text = selectedValue;
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
    // You can also use self.view if you don't have a sender
}
- (IBAction)daftar:(id)sender {
    /*
     else if(_pinRequestRepeat.text.length<1){
     [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Mohon Isi Konfirmasi Pin Baru"];
     }
     else if (![_pinRequest.text isEqualToString:_pinRequestRepeat.text]){
     [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Pin baru tidak sama dengan Konfirmasi PIN baru"];
     }
     else if ([_oldPin.text isEqualToString:_pinRequestRepeat.text]){
     [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"PIN lama & PIN Baru tidak boleh sama"];
     }

     */
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(!_phoneNumber.text.length){
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Nomor Handphone Tidak Boleh Kosong"];
        [[NetraCommonFunction sharedCommonFunction]giveBorderTo:_phoneNumber
                                                      withColor:[UIColor redColor]
                                               withCornerRadius:20
                                                withBorderWidth:2];
    }
    else  if(!_namaDepan.text.length){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Nama Depan Tidak Boleh Kosong"];
        [[NetraCommonFunction sharedCommonFunction]giveBorderTo:_namaDepan
                                                      withColor:[UIColor redColor]
                                               withCornerRadius:20
                                                withBorderWidth:2];
    }
    else  if(!_tanggalLahirPicker.text.length){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Tanggal Lahir Tidak Boleh Kosong"];
        [[NetraCommonFunction sharedCommonFunction]giveBorderTo:_tanggalLahirPicker
                                                      withColor:[UIColor redColor]
                                               withCornerRadius:20
                                                withBorderWidth:2];
    }
    else  if(!_namaIbuKandung.text.length){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Nama Ibu Kandung Tidak Boleh Kosong"];
        [[NetraCommonFunction sharedCommonFunction]giveBorderTo:_namaIbuKandung
                                                      withColor:[UIColor redColor]
                                               withCornerRadius:20
                                                withBorderWidth:2];
    }
    else if(!_PIN.text.length){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Mohon Isi PIN Baru"];
        [[NetraCommonFunction sharedCommonFunction]giveBorderTo:_PIN
                                                      withColor:[UIColor redColor]
                                               withCornerRadius:20
                                                withBorderWidth:2];
    }
    else if(!_konfPIN.text.length){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Mohon Isi Konfirmasi Pin"];
        [[NetraCommonFunction sharedCommonFunction]giveBorderTo:_konfPIN
                                                      withColor:[UIColor redColor]
                                               withCornerRadius:20
                                                withBorderWidth:2];
    }
    else if(![_PIN.text isEqualToString:_konfPIN.text]){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Pin tidak sama dengan Konfirmasi PIN"];
        [[NetraCommonFunction sharedCommonFunction]giveBorderTo:_konfPIN
                                                      withColor:[UIColor redColor]
                                               withCornerRadius:20
                                                withBorderWidth:2];
        [[NetraCommonFunction sharedCommonFunction]giveBorderTo:_PIN
                                                      withColor:[UIColor redColor]
                                               withCornerRadius:20
                                                withBorderWidth:2];
    }
    else if(!_isChecked){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Centang Tanda Setuju dengan Syarat dan Ketentuan"];
    }
    else{
        NSString *secretKey = [NSString stringWithFormat:@"%@%@|%@|%@",TimeStamp,_PIN.text,[NetraUserProfile reversedString:_PIN.text],_phoneNumber.text];
        NSLog(@"secretKye->%@",secretKey);
        [NetraUserProfile TripleDES:secretKey encryptOrDecrypt:kCCEncrypt key:secretKeyGlobal];
        
        
        NSString *idType;
        if([_tipeIdentitas.text isEqualToString:@"KTP"]){
            idType = @"1";
        }
        else if ([_tipeIdentitas.text isEqualToString:@"SIM"]){
            idType = @"2";
        }
        else{
            idType = @"3";
        }
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        [dictionary setObject:[NetraUserProfile TripleDES:secretKey encryptOrDecrypt:kCCEncrypt key:secretKeyGlobal] forKey:@"signature"];
        [dictionary setObject:userID forKey:@"userid"];
        [dictionary setObject:_phoneNumber.text forKey:@"msisdn"];
        [dictionary setObject:_namaDepan.text forKey:@"firstname"];
        
        [dictionary setObject:_dates forKey:@"dob"];
        [dictionary setObject:[NSString stringWithFormat:@"%d",_gender] forKey:@"gender"];
        [dictionary setObject:_namaIbuKandung.text forKey:@"mothername"];
        
        if(_namaBelakang.text.length<1){
            [dictionary setObject:@"" forKey:@"lastname"];
        }
        else{
            [dictionary setObject:_namaBelakang.text forKey:@"lastname"];
        }
        
        if(_alamat.text.length<1){
            [dictionary setObject:@"" forKey:@"address"];
        }
        else{
            [dictionary setObject:_alamat.text forKey:@"address"];
        }
        
        if(_tipeIdentitas.text.length<1){
            [dictionary setObject:@"" forKey:@"idtype"];
        }
        else{
            [dictionary setObject:idType forKey:@"idtype"];
        }
        if(_nomorIdentitas.text.length<1){
            [dictionary setObject:@"" forKey:@"idnumber"];
        }
        else{
            [dictionary setObject:_nomorIdentitas.text forKey:@"idnumber"];
        }
        
        NSLog(@"params-->%@",dictionary);
        
        [RegisterManager registerParams:dictionary registerManager:^(NSArray *posts, NSError *error) {
            {
                if (!error) {
                    
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    if([[[posts objectAtIndex:0]objectForKey:@"status"]integerValue]==18){
                        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Nomor Anda Sudah Pernah Teregister"];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    
                    if([[[posts objectAtIndex:0]objectForKey:@"status"]integerValue]==0){
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    
                    else{
                        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:[[posts objectAtIndex:0]objectForKey:@"msg"]];
                    }
                }
                else{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    NSLog(@"Error-->%@",error);
                }
            }
        }];
        
        
    }
}
- (IBAction)syaratKetentuan:(id)sender {
    infomasiDetail *newView = [[infomasiDetail alloc]init];
    newView.title =@"Syarat & Ketentuan";
    [self.navigationController pushViewController:newView animated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
