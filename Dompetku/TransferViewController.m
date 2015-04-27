//
//  TransferViewController.m
//  Dompetku
//
//  Created by Indosat on 11/23/14.
//
//

#import "TransferViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Log.h"
#import "NetraUserModel.h"
#import <MBProgressHUD.h>
#import "NetraCommonFunction.h"
#import "API+BeliManager.h"
@interface TransferViewController ()<UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate,UINavigationControllerDelegate,ABPersonViewControllerDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *emailTujuan;
@property (strong, nonatomic) IBOutlet UITextField *transferJumlah;
@property (strong, nonatomic) IBOutlet UITextField *PIN;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollers;
@property (strong, nonatomic) NSString *transID;
@property (nonatomic,strong)NSArray *prefix;
@property (nonatomic,strong)NSString *message;
@property (strong, nonatomic) Log *logInboxs;
@property (nonatomic) BOOL isPrefixNotFound;
@end

@implementation TransferViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if(!_isDompetku){
        _emailTujuan.placeholder = @"Nomor Tujuan";
        _message = @"Nomor Tujuan Harus Operator Telkomsel Atau XL";
        _prefix = [@"0811,0812,0813,0817,0818,0819,0821,0822,0823,0852,0853,0877,0878,0879" componentsSeparatedByString:@","];
    }
    else{
        _prefix = [@"0814,0815,0816,0855,0856,0857,0858" componentsSeparatedByString:@","];
        _message = @"Nomor Tujuan Harus Operator Indosat";
        
    }
    for (int i=1; i<6; i++) {
        [[NetraCommonFunction sharedCommonFunction]giveBorderTo:[self.view viewWithTag:i]
                                                      withColor:ORANGE_BORDER_COLOR
                                               withCornerRadius:20
                                                withBorderWidth:2];
    }
    for (UIView *view in [_scrollers subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            textField.leftView = paddingView;
            textField.delegate =self;
            textField.leftViewMode = UITextFieldViewModeAlways;
            // do something with textField
        }
    }
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:doubleTap];
    
    // Do any additional setup after loading the view.
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.view])
        return NO;
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField.keyboardType == UIKeyboardTypeNumberPad){
        UIToolbar *toolBar1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)]; UIBarButtonItem *doItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleDoubleTap:)]; [toolBar1 setItems:@[doItem]]; textField.inputAccessoryView = toolBar1; } return YES;
}
-(void)handleDoubleTap:(id)sender{
    [_PIN resignFirstResponder];
    [_emailTujuan resignFirstResponder];
    [_transferJumlah resignFirstResponder];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    // not supported on iOS4
    UITabBar *tabBar = [self.tabBarController tabBar];
    if ([tabBar respondsToSelector:@selector(setBackgroundImage:)])
    {
        NSLog(@"keen update");
        // set it just for this instance
        [tabBar setBackgroundImage:[UIImage imageNamed:@"transfer-state"]];
        
        // set for all
        // [[UITabBar appearance] setBackgroundImage: ...
    }
    else
    {
        // ios 4 code here
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)searchText:(NSString *)string{
    if (string.length >0 && string.length <5 ) {
        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",string];
        NSArray *data = [_prefix filteredArrayUsingPredicate:bPredicate];
        if(data.count==0){
            if(!_isPrefixNotFound)
                [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:_message];
            _isPrefixNotFound = true;
            
        }
        else{
            _isPrefixNotFound = false;
        }
        
    }
}
- (IBAction)sendToTransferAPI:(id)sender {
    for (UIView *view in [_scrollers subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            [textField resignFirstResponder];
            // do something with textField
        }
    }
    if(_emailTujuan.text.length<1){
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Mohon Isi Nomor Tujuan"];
    }
    else if (_isPrefixNotFound){
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:_message];
    }
    else if(_transferJumlah.text.length<1){
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Mohon Isi Jumlah"];
    }
    else if(_PIN.text.length<1){
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Mohon Isi PIN"];
    }
    
    else{
        NSString *url ;
        NSDictionary *params;
        if(_isDompetku){
            url = [NSString stringWithFormat:@"%@user_inquiry",indosatApiUrl];
            params =@{ @"signature":[[NetraCommonFunction sharedCommonFunction]tripleDesGenerate:_PIN.text],
                       @"to":_emailTujuan.text,
                       @"userid":userID,
                       @"amount":_transferJumlah.text};
        }
        else{
            url = [NSString stringWithFormat:@"%@p2p_transfer",indosatApiUrl];
            params =@{ @"signature":[[NetraCommonFunction sharedCommonFunction]tripleDesGenerate:_PIN.text],
                       @"to":_emailTujuan.text,
                       @"userid":userID,
                       @"amount":_transferJumlah.text};
            
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSLog(@"url transfer->%@",url);
        NSLog(@"params transfer->%@",params);
        
        [API_BeliManager urlparams:url param:params postParams:^(NSArray *posts, NSError *error) {
            if(!error){
                if(posts.count>0){
                    if(_isDompetku){
                        
                        NSString *message = [NSString stringWithFormat:@"Anda Akan Melakukan Kirim Uang Ke \n Nomor Pelanggan : %@ \n Nama:  %@ \n Jumlah: %@ \n Fee: 500 \n Total: %@",_emailTujuan.text, [[posts objectAtIndex:0] objectForKey:@"name"],_transferJumlah.text,[NSString stringWithFormat:@"%d",[_transferJumlah.text integerValue]+500]];
                        
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Konfirmasi" message:message delegate:self cancelButtonTitle:@"Batal" otherButtonTitles:@"Setuju", nil] ;
                        alertView.tag = 100;
                        alertView.delegate = self;
                        [alertView show];
                        _transID  =[[posts objectAtIndex:0]objectForKey:@"trxid"];
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        
                        
                    }
                    else{
                        if(!_isPrefixNotFound){
                            NSString *message = [NSString stringWithFormat:@"Anda Akan Menerima konfirmasi pop-up di nomor akun anda"];
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sukses" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] ;
                            [alertView show];
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                        }
                        else{
                            [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:_message];
                        }
                    }
                    
                }
                else{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }
            }
            else{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        }];
        
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        [self commitTransaction];
    }
    
}
-(void)commitTransaction{
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    netraUserModel *modelUser = [netraUserModel getUserProfile];
    //3.Jika user menekan tombol OK maka gunakan API money_transfer (contoh : http://114.4.68.110:14567/mfsmw/webapi/money_transfer?signature=EQzm7cOlqeG0IGQC/98vvb1xjJW5cU2qY6x+VtPYhHA=&userid=web_api_test&to=08551436505&amount=3000
    NSDictionary *params;
    NSString *url = [NSString stringWithFormat:@"%@money_transfer",indosatApiUrl];
    
    params =@{ @"signature":[[NetraCommonFunction sharedCommonFunction]tripleDesGenerate:_PIN.text],
               @"to":_emailTujuan.text,
               @"userid":userID,
               @"amount":_transferJumlah.text};
    NSLog(@"params 2->%@",params);
    NSLog(@"url 2->%@",url);
    [API_BeliManager urlparams:url param:params postParams:^(NSArray *posts, NSError *error) {
        if(!error){
            if(posts.count>0){
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"dd-MM-YYYY"];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSString *message = [NSString stringWithFormat:@"Anda telah melakukan Kirim Uang pada tanggal %@ ke %@ sebesar %@ dengan biaya sebesar 500 \n RefID: %@",[formatter stringFromDate:[NSDate date]],_emailTujuan.text,_transferJumlah.text,[[posts objectAtIndex:0]objectForKey:@"trxid"]];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Berhasil" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] ;
                alertView.delegate = self;
                [alertView show];
                _logInboxs = [[Log alloc]init];
                _logInboxs.actionName = [NSString stringWithFormat:@"Kirim Uang"];
                _logInboxs.expired =[NSDate date];
                _logInboxs.merchant = @"Kirim Uang";
                _logInboxs.destination = _emailTujuan.text;
                _logInboxs.amount = _transferJumlah.text;
                _logInboxs.refId = [[posts objectAtIndex:0]objectForKey:@"trxid"];
                [Log save:_logInboxs withRevision:YES];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            else{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        }
        else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
    
}
- (IBAction)openContact:(id)sender {
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
    _emailTujuan.text = [[[[NSString stringWithFormat:@"%@",(__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, ABMultiValueGetIndexForIdentifier(phone, identifier))] stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"-" withString:@""]stringByReplacingOccurrencesOfString:@"+62" withString:@"0"];
    NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",[_emailTujuan.text substringToIndex:4]];
    NSArray *data = [_prefix filteredArrayUsingPredicate:bPredicate];
    if(data.count==0){
        _isPrefixNotFound = true;
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:_message];
        
    }
    else{
        _isPrefixNotFound = false;
    }
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    NSMutableString *tmpStr1;
    NSString *strippedStr1;
    if (property == kABPersonPhoneProperty) {
        ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for(CFIndex i = 0; i < ABMultiValueGetCount(multiPhones); i++) {
            if(identifier == ABMultiValueGetIdentifierAtIndex (multiPhones, i)) {
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
                CFRelease(multiPhones);
                NSString *phoneNumber = (__bridge NSString *) phoneNumberRef;
                CFRelease(phoneNumberRef);
                tmpStr1 = [NSMutableString stringWithFormat:@"%@", phoneNumber];
                strippedStr1 =tmpStr1;
            }
        }
    }
    
    
    if([strippedStr1 isEqual:[NSNull null]] || strippedStr1 == (NSString *)[NSNull null]){
        _emailTujuan.text =strippedStr1;
        [self dismissModalViewControllerAnimated:YES];
        _isPrefixNotFound = true;
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:_message];
    }
    else if(strippedStr1.length<4){
        _emailTujuan.text =strippedStr1;
        _isPrefixNotFound = true;
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:_message];
        [self dismissModalViewControllerAnimated:YES];
        
        
    }
    else{
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"()-"];
        strippedStr1 = [[strippedStr1 componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
        
        NSString *pn =[[[strippedStr1 stringByReplacingOccurrencesOfString:@"+62" withString:@"0"] stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"  " withString:@""];
        NSLog(@"Pn_>%@",pn);
        
        _emailTujuan.text = [[pn componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
        NSLog(@"called 2 ->%@",_emailTujuan.text);
        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",[_emailTujuan.text substringToIndex:4]];
        NSArray *data = [_prefix filteredArrayUsingPredicate:bPredicate];
        if(data.count==0){
            _isPrefixNotFound = true;
            [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:_message];
            
        }
        else{
            _isPrefixNotFound = false;
        }
        //dismiss
        if (![strippedStr1 isEqualToString:@"null"]) {
            [self dismissModalViewControllerAnimated:YES];
        }
        else{
            [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Phone Number Cannot Be null"];
        }
        
        
        
    }
    
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

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendToServer:(id)sender {
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag==1){
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        [self searchText:newString];
        return YES;
    }
    else if(textField.tag==3){
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end