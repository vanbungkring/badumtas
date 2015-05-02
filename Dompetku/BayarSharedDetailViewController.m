//
//  BayarSharedDetailViewController.m
//  Dompetku
//
//  Created by Indosat on 12/22/14.
//
//

#import "BayarSharedDetailViewController.h"
#import <MBProgressHUD.h>
#import "NetraCommonFunction.h"
#import "transactionMapping.h"
#import "fieldTransaction.h"
#import "NSDate+TCUtils.h"
#import <ActionSheetStringPicker.h>
#import <ActionSheetDatePicker.h>
#import "searchStasiunTableViewController.h"
#import "transactionFavorite.h"
#import "netraUserModel.h"
#import "Log.h"
#import "API+BeliManager.h"
#import <AddressBookUI/AddressBookUI.h>
@interface BayarSharedDetailViewController ()<UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate,UINavigationControllerDelegate,ABPersonViewControllerDelegate,UIAlertViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)NSArray *id_isi_dropdown;
@property (nonatomic,strong)NSArray *stasiun;
@property (nonatomic,strong)NSArray *isi_dropdown;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSDate *selectedTime;
@property (nonatomic,strong)NSMutableArray *parent;
@property (nonatomic,strong)NSMutableArray *child;
@property (nonatomic,strong)NSMutableArray *totalTagLabel;
@property (nonatomic,strong)UIScrollView *scroll;
@property (nonatomic,strong) fieldTransaction *f;
@property (nonatomic,strong) Log *logInboxs;
@property (nonatomic,strong) NSString *transID;
@property (nonatomic,strong) NSString *amount;
@property (nonatomic,strong) NSString *tujuanParams;
@property (nonatomic,strong) NSString *totalTagihan;
@property (nonatomic,strong) NSString *tempPin;
@end
static float Top__ = 74;
static float last_frame__;
static BOOL isPhoneNumber__=0;
NSInteger tags_;
NSInteger tags_favorite__;
NSInteger tags_default__;
NSInteger pinTags;

NSMutableDictionary *params;
NSMutableArray *paramsKey;
NSDictionary *otherParams;
NSMutableArray *paramsValue;



@implementation BayarSharedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetScroll];
    self.view.backgroundColor = [UIColor whiteColor];
    
    paramsKey = [[NSMutableArray alloc]init];
    paramsValue = [[NSMutableArray alloc]init];
    _totalTagLabel = [[NSMutableArray alloc]init];
    params = [[NSMutableDictionary alloc]init];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    [fieldTransaction fieldDetail:_subMerchantId getAllField:^(NSArray *posts, NSError *error) {
        if(!error){
            _parent = [NSMutableArray arrayWithArray:posts];
            _f = [_parent objectAtIndex:0];
            _child = [NSMutableArray arrayWithArray:_f.detail_field];
            [self drawDetail];
        }
        else{
            [hud hide:YES];
        }
        
        
    }];
    
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_scroll];
    _scroll.delegate = self;
    _scroll.backgroundColor = [UIColor clearColor];
    _scroll.contentSize = CGSizeMake(320, self.view.frame.size.height);
    //ny additional setup after loading the view.
    //ny additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(resetTab)
     name:@"resetTab"
     object:nil];
    
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:doubleTap];
    
    // Do any additional setup after loading the view.
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if(textField.tag == pinTags){
        UIToolbar *toolBar1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)]; UIBarButtonItem *doItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleDoubleTap:)]; [toolBar1 setItems:@[doItem]]; textField.inputAccessoryView = toolBar1; } return YES; }


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.view])
        return NO;
    return YES;
}
-(void)handleDoubleTap:(id)sender{
    NSLog(@"double tap");
    [self.view endEditing:TRUE];
}
-(void)resetTab{
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float rol_y = _scroll.contentOffset.y;
    float rol_x = _scroll.contentOffset.x;
    if(rol_y < 1){
        [self resetScroll];
    }
    NSLog(@"scroll now->%f,%f",rol_x,rol_y);
}
-(void)resetScroll{
    [_scroll setContentOffset:CGPointMake(0, 0) animated:NO];
}
-(void)drawDetail{
    NSLog(@"draw detail");
    for (int i=1; i<=_child.count; i++) {
        UILabel *_label;
        _label = [[UILabel alloc]initWithFrame:CGRectMake(21, i*Top__, self.view.frame.size.width, 28)];
        
        _label.text = [[_child objectAtIndex:i-1]objectForKey:@"label"];
        _label.numberOfLines = 2;
        _label.tag = 40000+i;
        _label.font = [UIFont fontWithName:@"AvenirNext-Medium" size:18];
        NSLog(@"draw detail0000--->%d",_label.tag);
        [_totalTagLabel addObject:[[_child objectAtIndex:i-1]objectForKey:@"label"]];
        self.selectedDate = [NSDate date];
        self.selectedTime = [NSDate date];
        UITextField *_textField;
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(21, i*Top__+25, self.view.frame.size.width-35, 40)];
        _textField.delegate = self;
        _textField.tag = i;
        if(_textField.tag==[_tagPass integerValue]){
            _textField.text = _fielTextdPass;
        }
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
        if([[[_child objectAtIndex:i-1]objectForKey:@"textview_type"]integerValue]==1){
            isPhoneNumber__=1;
        }
        else{
            isPhoneNumber__=0;
        }
        UIButton *overlay = [UIButton buttonWithType:UIButtonTypeCustom];
        overlay.backgroundColor = [UIColor clearColor];
        switch ([[[_child objectAtIndex:i-1]objectForKey:@"textview_type"]integerValue]) {
            case 2:
                overlay.frame = _textField.frame;
                overlay.backgroundColor = [UIColor clearColor];
                [overlay addTarget:self action:@selector(openCalendar:) forControlEvents:UIControlEventTouchUpInside];
                overlay.tag = 1000000+_textField.tag;
                tags_ = _textField.tag;
                break;
            case 3:
                [_textField setSecureTextEntry:YES];
                _textField.keyboardType = UIKeyboardTypeNumberPad;
                pinTags = _textField.tag;
                break;
            case 4:
                _textField.keyboardType = UIKeyboardTypeNumberPad;
                tags_ = _textField.tag;
                break;
            case 1:
                [_textField setFrame:frames];
                tags_ = _textField.tag;
                _textField.keyboardType = UIKeyboardTypeNumberPad;
                [findContact setFrame:CGRectMake(_textField.frame.size.width+_textField.frame.origin.x +5, _textField.frame.size.height+_textField.frame.origin.y-35, 30, 30)];
                [_scroll addSubview:findContact];
                
                break;
            case 6:
                overlay.frame = _textField.frame;
                
                [overlay addTarget:self action:@selector(openKrl:) forControlEvents:UIControlEventTouchUpInside];
                overlay.tag = 1000000+_textField.tag;
                //[_textField addSubview:overlay];
                tags_ = _textField.tag;
                break;
            default:
                tags_ = _textField.tag;
                break;
        }
        switch ([[[_child objectAtIndex:i-1]objectForKey:@"field_tipe"]integerValue]) {
            case 0:
                tags_default__ = _textField.tag;
                
                break;
            case 1:
                
                overlay.frame = _textField.frame;
                
                [overlay addTarget:self action:@selector(openActionSheet:) forControlEvents:UIControlEventTouchUpInside];
                overlay.tag = 1000000+_textField.tag;
                NSLog(@"overlay tag->%d",overlay.tag);
                tags_default__ = _textField.tag;
                
                break;
                
            default:
                break;
        }
        if ([[_child objectAtIndex:i-1]objectForKey:@"is_favorite"]) {
            switch ([[[_child objectAtIndex:i-1]objectForKey:@"is_favorite"]integerValue]) {
                case 1:
                    
                    [_textField setFrame:frames];
                    tags_favorite__ = _textField.tag;
                    _label.tag = 1000+tags_favorite__;
                    if (isPhoneNumber__) {
                        [addToFavorite setFrame:CGRectMake(_textField.frame.size.width+_textField.frame.origin.x +40, _textField.frame.size.height+_textField.frame.origin.y-35, 30, 30)];
                        _textField.keyboardType = UIKeyboardTypeNumberPad;
                        
                    }
                    else{
                        [addToFavorite setFrame:CGRectMake(_textField.frame.size.width+_textField.frame.origin.x +20, _textField.frame.size.height+_textField.frame.origin.y-35, 35, 35)];
                    }
                    [_scroll addSubview:addToFavorite];
                    break;
                    
                default:
                    break;
            }
        }
        if([[_child objectAtIndex:i-1]objectForKey:@"param_name"]){
            if([[_child objectAtIndex:i-1]objectForKey:@"isi_dropdown"]){
                [paramsKey addObject:[[_child objectAtIndex:i-1]objectForKey:@"param_name"]];
                [paramsValue addObject:[NSString stringWithFormat:@"%d",_textField.tag]];
            }
            
        }
        //
        [_scroll addSubview:_label];
        
        [_scroll addSubview:_textField];
        overlay.layer.zPosition = 1000;
        [_scroll addSubview:overlay];
        last_frame__ =_textField.frame.origin.y+_textField.frame.size.height;
    }
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(103, last_frame__+30, 114, 38);
    [submitButton setBackgroundImage:[UIImage imageNamed:@"button-bayar"] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(inquiryProcess) forControlEvents:UIControlEventTouchUpInside];
    [_scroll addSubview:submitButton];
    
    [_scroll setContentSize:CGSizeMake(40, last_frame__+400)];
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            textField.leftView = paddingView;
            textField.leftViewMode = UITextFieldViewModeAlways;
            // do something with textField
        }
    }
    [self populateData:tags_default__];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(setValueOfTextField:)
     name:@"postBack"
     object:nil];
    
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    // Do any additional setup after loading the view.
    
}
-(void)setValueOfTextField:(NSNotification *)notification{
    NSDictionary *dictionary = [notification userInfo];
    NSInteger a = [[dictionary objectForKeyedSubscript:@"key"]integerValue];
    UITextField *tf = (UITextField *)[self.view viewWithTag:a];
    tf.text = [dictionary objectForKey:@"value"];
    
    
}

-(void)openKrl:(UIControl *)sender{
    
    searchStasiunTableViewController *vc = [[searchStasiunTableViewController alloc]init];
    vc.tagss=[NSString stringWithFormat:@"%d",[sender tag]-1000000];
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
    dateFormatter.dateFormat = @"dd MMMM YYYY";
    int x = ([element tag]-1000000);
    [(UITextField *)[self.view viewWithTag:x] setText:[dateFormatter stringFromDate:self.selectedDate]];
    [(UITextField *)[self.view viewWithTag:x] resignFirstResponder];
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
    NSLog(@"called");
    ABMultiValueRef phone = ABRecordCopyValue(person, property);
    UITextField *tf = (UITextField *)[self.view viewWithTag:tags_];
    tf.text = [[[[NSString stringWithFormat:@"%@",(__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, ABMultiValueGetIndexForIdentifier(phone, identifier))] stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"-" withString:@""]stringByReplacingOccurrencesOfString:@"+62" withString:@"0"];
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
                strippedStr1 = [tmpStr1 stringByReplacingOccurrencesOfString:@" " withString:@""];
            }
        }
    }
    
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"()-"];
    strippedStr1 = [[strippedStr1 componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
    
    NSString *pn =[[[strippedStr1 stringByReplacingOccurrencesOfString:@"+62" withString:@"0"] stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"  " withString:@""];
    UITextField *tf = (UITextField *)[self.view viewWithTag:tags_];
    tf.text = pn;
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    
    //    ABPersonViewController *controller = [[ABPersonViewController alloc] init];
    //    controller.displayedPerson = person;
    //    controller.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonEmailProperty]];
    //    controller.personViewDelegate = self;
    //    [peoplePicker pushViewController:controller animated:YES];
    [self resetScroll];
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
    NSLog(@"called 1");
    return NO;
}


- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)openActionSheet:(id)sender{
    int x = ([sender tag]-1000000)-1;
    NSLog(@"data-->%d",[sender tag]-1);
    [(UITextField *)[self.view viewWithTag:[sender tag]] resignFirstResponder];
    [ActionSheetStringPicker showPickerWithTitle:@"Pick"
                                            rows:[[[_child objectAtIndex:x]objectForKey:@"isi_dropdown"] componentsSeparatedByString:@";"]
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           [self selectedValue:selectedIndex  element:sender];
                                           [(UITextField *)[self.view viewWithTag:x+1] resignFirstResponder];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         [(UITextField *)[self.view viewWithTag:x+1] resignFirstResponder];
                                     }
                                          origin:sender];
}
- (void)selectedValue:(NSInteger)selectedIndex element:(id)element {
    int x = ([element tag]-1000000)-1;
    [(UITextField *)[self.view viewWithTag:x+1] setText:[[[[_child objectAtIndex:x]objectForKey:@"isi_dropdown"] componentsSeparatedByString:@";"] objectAtIndex:selectedIndex]];
    [params setObject:[[[[_child objectAtIndex:x]objectForKey:@"id_isi_dropdown"] componentsSeparatedByString:@";"] objectAtIndex:selectedIndex] forKey:[[_child objectAtIndex:x]objectForKey:@"param_name"]];
    
}
-(void)populateData:(int)element{
    
    //    [(UITextField *)[self.view viewWithTag:element] setText:[[[[_child objectAtIndex:element-1]objectForKey:@"isi_dropdown"] componentsSeparatedByString:@";"] objectAtIndex:0]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)saveToFavorite:(id)sender{
    UITextField *tf = (UITextField *)[self.view viewWithTag:tags_favorite__];
    UILabel *label = (UILabel *)[self.view viewWithTag:1000+tags_favorite__];
    
    if(tf.text.length ==0){
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:[NSString stringWithFormat:@"%@ Tidak Boleh Kosong",label.text]];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Masukkan Nama Favorite" message:@"" delegate:self cancelButtonTitle:@"Batal" otherButtonTitles:@"Simpan", nil] ;
        alertView.tag = 20000;
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField = [alertView textFieldAtIndex:0];
        textField.text = [NSString stringWithFormat:@"%@_%@_%@",_transactionNameParent,[[_child objectAtIndex:0]objectForKey:@"sub_merchant_nama"],tf.text];
        
        [alertView show];
        
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==20000){
        
        if(buttonIndex==1){
            UITextField * alertTextField = [alertView textFieldAtIndex:0];
            UITextField *tf = (UITextField *)[self.view viewWithTag:tags_favorite__];
            transactionFavorite *t  = [[transactionFavorite alloc]init];
            t.state =@"Bayar";
            t.transactionJenis = _transactionJenis;
            t.merchant =[[_child objectAtIndex:0]objectForKey:@"sub_merchant_nama"];
            t.parent = _transactionNameParent;
            t.tags =[NSString stringWithFormat:@"%d",tags_favorite__];
            t.merchantID = _subMerchantId;
            t.parentID = _parentId;
            t.fieldInformation =tf.text;
            t.name = alertTextField.text;
            [transactionFavorite save:t withRevision:YES];
            
            NSLog(@"alerttextfiled - %@",[transactionFavorite getItems]);
        }
        
    }
    else if(alertView.tag ==10010101){
        
        if(buttonIndex==1){
            NSLog(@"Bayar");
            [self commitTransactions];
        }
        
    }
    
    // do whatever you want to do with this UITextField.
}
-(void)inquiryProcess{
    [self.view endEditing:YES];
    int i=0;
    BOOL isEmpty=0;
    for (UIView *view in [_scroll subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            
            UITextField *textField = (UITextField *)view;
            if (textField.text.length<1) {
                [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:[NSString stringWithFormat:@"Mohon Isi %@",[_totalTagLabel objectAtIndex:textField.tag-1]]];
                bool isEmpty=1;
                break;
            }
            else{
                i++;
                if(i==_totalTagLabel.count){
                    
                    if (isEmpty==1) {
                        NSLog(@"masih ada yang kosong");
                    }
                    else{
                        if(textField.text.length<1){
                            NSLog(@"masih ada yang kosong cuk!");
                        }
                        else{
                            [self doProcessTransaction];
                        }
                    }
                }
                else{
                    isEmpty=0;
                }
                
            }
            
        }
    }
}

-(void)doProcessTransaction{
    UITextField *pinText = (UITextField *)[self.view viewWithTag:pinTags];
    _tempPin = pinText.text;
    NSLog(@"do here");
    for (int i=0; i<paramsKey.count; i++) {
        UITextField *texts = (UITextField *)[self.view viewWithTag:[[paramsValue objectAtIndex:i]integerValue]];
        if(![[paramsKey objectAtIndex:i] isEqualToString:@"amount"]){
            [params setObject:texts.text forKey:[paramsKey objectAtIndex:i]];
        }
        if ([[paramsKey objectAtIndex:i] isEqualToString:@"to"]) {
            _tujuanParams = texts.text;
        }
        
    }
    
    [params setObject:[[NetraCommonFunction sharedCommonFunction]tripleDesGenerate:_tempPin] forKey:@"signature"];
    [params removeObjectForKey:@"pin"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"params-->%@",params);
    [API_BeliManager urlparams:_f.url_action1 param:params postParams:^(NSArray *posts, NSError *error) {
        if(!error){
            if(posts.count>0){
                
                if(![_f.url_action2 isEqualToString:@""]){
                    NSString *feeString;
                    NSString *noPelanggan;
                    NSString *totalTagihanSummon;
                    NSString *totalSum;
                    _tujuanParams = [params objectForKey:@"to"];
                    noPelanggan = [NSString stringWithFormat:@"\n No. Tujuan: %@",_tujuanParams];
                    
                    _totalTagihan = [[posts objectAtIndex:0]objectForKey:@"price"];
                    int calculate =[_totalTagihan integerValue]-[[[posts objectAtIndex:0]objectForKey:@"fee"]integerValue];
                    totalSum =[NSString stringWithFormat:@"\n Jumlah: %d",calculate];
                    
                    if(![[posts objectAtIndex:0]objectForKey:@"fee"]){
                        feeString= @"";
                        totalSum = @"";
                    }
                    else{
                        feeString=[NSString stringWithFormat:@"\n Fee: %@",[[posts objectAtIndex:0]objectForKey:@"fee"]];
                        
                    }
                    totalTagihanSummon =[NSString stringWithFormat:@"\n Jumlah: %@",_totalTagihan];
                    
                    
                    NSLog(@"post--->%@",posts);
                    NSString *message = [NSString stringWithFormat:@"Anda Akan  Membayar %@ %@ dengan detail sebagai berikut :%@ \n Nama Pelanggan: %@ %@ %@ %@",_transactionNameParent,self.title,noPelanggan,[[posts objectAtIndex:0]objectForKey:@"name"],totalSum,feeString,totalTagihanSummon];
                    _amount =[[posts objectAtIndex:0]objectForKey:@"price"];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Konfirmasi" message:message delegate:self cancelButtonTitle:@"Batal" otherButtonTitles:@"Bayar", nil] ;
                    alertView.tag = 10010101;
                    alertView.delegate = self;
                    [alertView show];
                    _transID  =[[posts objectAtIndex:0]objectForKey:@"trxid"];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }
                else{
                    
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    NSString *message = [NSString stringWithFormat:@"Anda Telah Berhasil Melakukan Pembayaran %@ %@ dengan detail sebagai berikut: \n Harga: %@",_transactionNameParent,self.title,[params objectForKey:@"amount"]];
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Berhasil" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] ;
                    alertView.delegate = self;
                    [alertView show];
                    _logInboxs = [[Log alloc]init];
                    _logInboxs.actionName = [NSString stringWithFormat:@"Beli %@",_transactionNameParent];
                    _logInboxs.destination = _tujuanParams;
                    _logInboxs.merchant = self.title;
                    _logInboxs.token =[[posts objectAtIndex:0]objectForKey:@"trxid"];
                    _logInboxs.expired =[NSDate date];
                    _logInboxs.refId = [[posts objectAtIndex:0]objectForKey:@"refID"];
                    _logInboxs.amount = [[posts objectAtIndex:0]objectForKey:@"price"];
                    [Log save:_logInboxs withRevision:YES];
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
-(void)commitTransactions{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    netraUserModel *modelUsers = [netraUserModel getUserProfile];
    NSMutableDictionary *parameterCommit = [[NSMutableDictionary alloc]init];
    [parameterCommit setObject:_transID forKey:@"transid"];
    [parameterCommit setObject:[[NetraCommonFunction sharedCommonFunction]tripleDesGenerate:_tempPin] forKey:@"signature"];
    [parameterCommit setObject:_totalTagihan forKey:@"amount"];
    if([params objectForKey:@"denom"]){
        [parameterCommit setObject:[params objectForKey:@"denom"] forKey:@"denom"];
    }
    
    [parameterCommit setObject:_tujuanParams forKey:@"to"];
    NSLog(@"paramss->%@",parameterCommit);
    [API_BeliManager urlparams:_f.url_action2 param:parameterCommit postParams:^(NSArray *posts, NSError *error) {
        if(!error){
            if(posts.count>0){
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"dd-MM-YYYY"];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSString *voucherCode;
                NSString *refID;
                
                ///////get voucher code
                
                if ([[[posts objectAtIndex:0] allKeys] containsObject:@"voucherCode"]) {
                    if([[[posts objectAtIndex:0]objectForKey:@"voucherCode"] isEqual:[NSNull null]]){
                        voucherCode =@"";
                    }
                    else if([[[posts objectAtIndex:0]objectForKey:@"voucherCode"] isEqualToString:@""]){
                        voucherCode =@"";
                    }
                    else{
                        voucherCode =[NSString stringWithFormat:@"\n Kode  Voucher :%@",[[posts objectAtIndex:0]objectForKey:@"voucherCode"]];
                        
                    }
                }
                else{
                    voucherCode = @"";
                }
                
                /////refID
                if ([[[posts objectAtIndex:0] allKeys] containsObject:@"trxid"]) {
                    if([[[posts objectAtIndex:0]objectForKey:@"trxid"] isEqual:[NSNull null]]){
                        refID =@"\n RefID: -";
                    }
                    else if([[[posts objectAtIndex:0]objectForKey:@"trxid"] isEqualToString:@""]){
                        refID =@"\n RefID: -";
                    }
                    else{
                        refID =[NSString stringWithFormat:@"\n RefID: %@",[[posts objectAtIndex:0]objectForKey:@"trxid"]];
                    }
                }
                else{
                    refID = @"";
                }
                
                if(![[[posts objectAtIndex:0]objectForKey:@"trxid"] isEqualToString:@""]){
                    refID =[NSString stringWithFormat:@"\n RefID: %@",[[posts objectAtIndex:0]objectForKey:@"trxid"]];
                }
                else{
                    refID =@"\n RefID: -";
                }
                
                NSString *message = [NSString stringWithFormat:@"Anda Telah Melakukan Pembayaran %@ %@ pada tanggal %@ ke %@ Sebesar %@ %@ %@",_transactionNameParent,self.title,[formatter stringFromDate:[NSDate date]],_tujuanParams,_totalTagihan,voucherCode,refID];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Berhasil" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] ;
                alertView.delegate = self;
                [alertView show];
                _logInboxs = [[Log alloc]init];
                _logInboxs.destination = _tujuanParams;
                _logInboxs.merchant = self.title;
                _logInboxs.actionName = [NSString stringWithFormat:@"Bayar %@",_transactionNameParent];
                _logInboxs.expired =[NSDate date];
                if ([voucherCode isEqualToString:@"\n RefID :-"]) {
                    _logInboxs.refId = @"";
                }
                else{
                    _logInboxs.refId = [[posts objectAtIndex:0]objectForKey:@"trxid"];
                }
                
                if ([voucherCode isEqualToString:@"\n Voucher  -"]) {
                    _logInboxs.voucherID = @"";
                }
                else{
                    _logInboxs.voucherID = [voucherCode stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                }
                _logInboxs.amount = _amount;
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

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField.tag==pinTags){
        NSLog(@"string-->%@",string);
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
