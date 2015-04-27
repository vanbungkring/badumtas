//
//  BeliSharedDetailViewController.m
//  Dompetku
//
//  Created by Indosat on 12/21/14.
//
//

#import "BeliSharedDetailViewController.h"
#import <MBProgressHUD.h>
#import "NetraCommonFunction.h"
#import "transactionMapping.h"
#import "fieldTransaction.h"
#import "NSDate+TCUtils.h"
#import <ActionSheetStringPicker.h>
#import <ActionSheetDatePicker.h>
#import "searchStasiunTableViewController.h"
#import "transactionFavorite.h"
#import "API+BeliManager.h"
#import "NetraUserModel.h"
#import "Log.h"
#import <AddressBookUI/AddressBookUI.h>
@interface BeliSharedDetailViewController ()<UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate,UINavigationControllerDelegate,ABPersonViewControllerDelegate,UIAlertViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)NSArray *id_isi_dropdown;
@property (nonatomic,strong)NSArray *stasiun;
@property (nonatomic,strong)NSArray *isi_dropdown;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSDate *selectedTime;
@property (nonatomic,strong)NSMutableArray *parent;
@property (nonatomic,strong)NSMutableArray *child;
@property (nonatomic,strong)NSMutableArray *labelText;
@property (nonatomic,strong) UIScrollView *scroll;
@property (nonatomic,strong) NSString *amount;
@property (nonatomic,strong) NSString *transID;
@property (nonatomic,strong) Log *logInboxs;
@property (nonatomic,strong)NSString *totalTagihan;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *tujuanString;
@property (nonatomic,strong)NSString *tanggalLahir;
@property (nonatomic,strong)NSString *program;
@property (nonatomic,strong)NSString *tempPin;
@property (nonatomic,strong)NSString *jumlah;
@property (nonatomic,strong)  fieldTransaction *f;
@end
static float Top_ = 74;
float last_frame_;
BOOL isPhoneNumber_=0;
NSInteger pinTag;
NSInteger tujuanTag;
NSInteger amountTag;
NSInteger tags_;
NSInteger tags_favorite_;
NSInteger tags_default_;
NSMutableDictionary *params;
NSMutableArray *paramsKey;
NSDictionary *otherParams;
NSMutableArray *paramsValue;


@implementation BeliSharedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetScroll];
    paramsKey = [[NSMutableArray alloc]init];
    paramsValue = [[NSMutableArray alloc]init];
    params = [[NSMutableDictionary alloc]init];
    _labelText = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"called->");
    [fieldTransaction fieldDetail:_subMerchantId getAllField:^(NSArray *posts, NSError *error) {
        _parent = [NSMutableArray arrayWithArray:posts];
        _f= [_parent objectAtIndex:0];
        _child = [NSMutableArray arrayWithArray:_f.detail_field];
        [self drawDetail];
    }];
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [_scroll setAutoresizesSubviews:NO];
    _scroll.backgroundColor = [UIColor clearColor];
    _scroll.delegate  =self;
    _scroll.scrollEnabled = YES;
    [self.view addSubview:_scroll];
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
-(void)handleDoubleTap:(id)sender{
    [self.view endEditing:TRUE];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self resetScroll];
    [_scroll setContentOffset:CGPointMake(0, 0)animated:YES];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self resetScroll];
}
-(void)resetTab{
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}
-(void)drawDetail{
    
    float adder=0;
    for (int i=1; i<=_child.count; i++) {
        UITextField *_textField;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, i*Top_-5+adder, 300, 40)];
        
        label.tag =4000+i;
        
        label.text = [[_child objectAtIndex:i-1]objectForKey:@"label"];
        [_labelText addObject:[[_child objectAtIndex:i-1]objectForKey:@"label"]];
        
        label.font = [UIFont fontWithName:@"AvenirNext-Medium" size:18];
        label.numberOfLines = 0;
        [label sizeToFit];
        if(label.frame.size.height>25){
            adder=25;
        }
        self.selectedDate = [NSDate date];
        self.selectedTime = [NSDate date];
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(21, i*Top_+25+adder, self.view.frame.size.width-35, 40)];
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
            isPhoneNumber_=1;
        }
        else{
            isPhoneNumber_=0;
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
                pinTag = _textField.tag;
                
                _textField.keyboardType = UIKeyboardTypeNumberPad;
                break;
            case 4:
                _textField.keyboardType = UIKeyboardTypeNumberPad;
                break;
            case 1:
                [_textField setFrame:frames];
                _textField.keyboardType = UIKeyboardTypeNumberPad;
                tags_ = _textField.tag;
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
                break;
        }
        switch ([[[_child objectAtIndex:i-1]objectForKey:@"field_tipe"]integerValue]) {
            case 1:
                overlay.frame = _textField.frame;
                
                [overlay addTarget:self action:@selector(openActionSheet:) forControlEvents:UIControlEventTouchUpInside];
                overlay.tag = 1000000+_textField.tag;
                tags_default_ = _textField.tag;
                
                break;
                
            default:
                
                break;
        }
        if ([[_child objectAtIndex:i-1]objectForKey:@"is_favorite"]) {
            switch ([[[_child objectAtIndex:i-1]objectForKey:@"is_favorite"]integerValue]) {
                case 1:
                    
                    [_textField setFrame:frames];
                    tags_favorite_ = _textField.tag;
                    if (isPhoneNumber_) {
                        [addToFavorite setFrame:CGRectMake(_textField.frame.size.width+_textField.frame.origin.x +40, _textField.frame.size.height+_textField.frame.origin.y-35, 30, 30)];
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
        
        [_scroll addSubview:label];
        
        [_scroll addSubview:_textField];
        overlay.layer.zPosition = 1000;
        [_scroll addSubview:overlay];
        
        last_frame_ =_textField.frame.origin.y+_textField.frame.size.height;
    }
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(103, last_frame_+30, 114, 38);
    [submitButton setBackgroundImage:[UIImage imageNamed:@"button-beli"] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(sendToAPI) forControlEvents:UIControlEventTouchUpInside];
    [_scroll addSubview:submitButton];
    [_scroll setContentSize:CGSizeMake(320, last_frame_+400)];
    _scroll.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            textField.leftView = paddingView;
            textField.leftViewMode = UITextFieldViewModeAlways;
            // do something with textField
        }
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(setValueOfTextField:)
     name:@"postBack"
     object:nil];
    
    NSLog(@"label tag->%d",pinTag);
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    // Do any additional setup after loading the view.
    
}

//
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{ if(textField.keyboardType == UIKeyboardTypeNumberPad){ UIToolbar *toolBar1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)]; UIBarButtonItem *doItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleDoubleTap:)]; [toolBar1 setItems:@[doItem]]; textField.inputAccessoryView = toolBar1; } return YES; }



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float rol_y = _scroll.contentOffset.y;
    float rol_x = _scroll.contentOffset.x;
    if(rol_y <-64){
        [_scroll setContentOffset:CGPointMake(0, 0) animated:NO];
        [self resetScroll];
    }
    NSLog(@"scroll now->%f,%f",rol_x,rol_y);
}
-(void)resetScroll{
    [_scroll setContentOffset:CGPointMake(0, 0) animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self resetScroll];
}

-(void)viewDidLayoutSubviews {
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        UIEdgeInsets currentInsets = _scroll.contentInset;
        _scroll.contentInset = (UIEdgeInsets){
            .top = self.topLayoutGuide.length,
            .bottom = currentInsets.bottom,
            .left = currentInsets.left,
            .right = currentInsets.right
        };
    }
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
    [self resetScroll];
    [self.view setNeedsDisplay];
    NSLog(@"open contact dipanggil");
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
    UITextField *tf = (UITextField *)[self.view viewWithTag:tags_];
    tf.text = [[[[NSString stringWithFormat:@"%@",(__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, ABMultiValueGetIndexForIdentifier(phone, identifier))] stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"-" withString:@""]stringByReplacingOccurrencesOfString:@"+62" withString:@"0"];
    [self resetScroll];
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
    else{
        return YES;
    }
    
   
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
    [self resetScroll];
    return NO;
}


- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self resetScroll];
}

-(void)openActionSheet:(id)sender{
    int x = ([sender tag]-1000000)-1;
    [(UITextField *)[self.view viewWithTag:[sender tag]] resignFirstResponder];
    [ActionSheetStringPicker showPickerWithTitle:@"Pick"
                                            rows:[[[_child objectAtIndex:x]objectForKey:@"isi_dropdown"] componentsSeparatedByString:@";"]
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           _amount = selectedValue;
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
    
    NSLog(@"data-->%@",[[_child objectAtIndex:x]objectForKey:@"id_isi_dropdown"]);
    
    
    [params setObject:[[[[_child objectAtIndex:x]objectForKey:@"id_isi_dropdown"] componentsSeparatedByString:@";"] objectAtIndex:selectedIndex] forKey:@"amount"];
    _amount = [[[[_child objectAtIndex:x]objectForKey:@"id_isi_dropdown"] componentsSeparatedByString:@";"] objectAtIndex:selectedIndex];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)saveToFavorite:(id)sender{
    NSLog(@"called");
    UITextField *tf = (UITextField *)[self.view viewWithTag:tags_favorite_];
    UILabel *label = (UILabel *)[self.view viewWithTag:1000+tags_favorite_];
    
    if(tf.text.length ==0){
        [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:[NSString stringWithFormat:@"%@ Tidak Boleh Kosong",label.text]];
    }
    else{
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Masukkan Nama Favorite" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] ;
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
    if((alertView.tag ==20000)){
        NSLog(@"button index->%d",buttonIndex);
        if(buttonIndex==1){
            UITextField * alertTextField = [alertView textFieldAtIndex:0];
            UITextField *tf = (UITextField *)[self.view viewWithTag:tags_favorite_];
            transactionFavorite *t  = [[transactionFavorite alloc]init];
            t.state =@"Beli";
            t.transactionJenis = _transactionJenis;
            t.merchant =[[_child objectAtIndex:0]objectForKey:@"sub_merchant_nama"];
            t.parent = _transactionNameParent;
            t.tags =[NSString stringWithFormat:@"%d",tags_favorite_];
            t.merchantID = _subMerchantId;
            t.parentID = _parentId;
            t.fieldInformation =tf.text;
            t.name = alertTextField.text;
            [transactionFavorite save:t withRevision:YES];
        }
    }
    else if(alertView.tag ==100){
        
        if(buttonIndex==1){
            [self commitTransaction];
        }
    }
    
    else if(alertView.tag ==101){
        
        if(buttonIndex==1){
            [self commitTransaction2];
        }
        
    }
    // do whatever you want to do with this UITextField.
}

-(void)sendToAPI{
    [self.view endEditing:YES];
    int i=0;
    BOOL isEmpty=0;
    for (UIView *view in [_scroll subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            
            UITextField *textField = (UITextField *)view;
            if (textField.text.length<1) {
                [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:[NSString stringWithFormat:@"Mohon Isi %@",[_labelText objectAtIndex:textField.tag-1]]];
                BOOL isEmpty=1;
                break;
            }
            else{
                i++;
                if(i==_labelText.count){
                    
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UITextField *pinText = (UITextField *)[self.view viewWithTag:pinTag];
    _tempPin = pinText.text;
    for (int i=0; i<paramsKey.count; i++) {
        UITextField *texts = (UITextField *)[self.view viewWithTag:[[paramsValue objectAtIndex:i]integerValue]];
        if(![params objectForKey:@"amount"])
            [params setObject:texts.text forKey:[paramsKey objectAtIndex:i]];
        else
            [params setObject:texts.text forKey:[paramsKey objectAtIndex:i]];
        NSLog(@"params key->%@ text->%@",[paramsKey objectAtIndex:i],texts.text);
    }
    
    [params setObject:[[NetraCommonFunction sharedCommonFunction]tripleDesGenerate:_tempPin] forKey:@"signature"];
    [params removeObjectForKey:@"pin"];
    if(![_f.url_action2 isEqualToString:@""]){
        [API_BeliManager urlparams:_f.url_action1 param:params postParams:^(NSArray *posts, NSError *error) {
            if(!error){
                if(posts.count>0){
                    
                    if([[posts objectAtIndex:0]objectForKey:@"price"])
                        _totalTagihan = [[posts objectAtIndex:0]objectForKey:@"price"];
                    else
                        _totalTagihan = [params objectForKey:@"amount"];
                    
                    NSString *noPelanggan;
                    NSString *denominal;
                    
                    if([[posts objectAtIndex:0]objectForKey:@"msisdn"]){
                        _tujuanString =[[posts objectAtIndex:0]objectForKey:@"msisdn"];
                        if ([_transactionNameParent isEqualToString:@"Voucher Games"]){
                            noPelanggan  = @"";
                        }
                        else{
                            noPelanggan = [NSString stringWithFormat:@"\n No. Tujuan: %@",_tujuanString];
                        }
                    }
                    
                    else{
                        _tujuanString = [params objectForKey:@"to"];
                        noPelanggan = [NSString stringWithFormat:@"\n No. Tujuan: %@",_tujuanString];
                    }
                    
                    if ([[posts objectAtIndex:0]objectForKey:@"name"]){
                        _name =[[posts objectAtIndex:0]objectForKey:@"name"];
                        noPelanggan = [NSString stringWithFormat:@"\n Nama: %@",_name];
                        
                    }
                    if([params objectForKey:@"denom"]){
                        denominal = [NSString stringWithFormat:@"\n Nominal: %@",[params objectForKey:@"denom"]];
                    }
                    else{
                        denominal = @"";
                    }
                    NSString *harga;
                    if(_totalTagihan){
                        if([_transactionNameParent isEqualToString:@"Asuransi"]||[_transactionNameParent isEqualToString:@"Donasi"]){
                            harga = @"";
                        }
                        else{
                            harga = [NSString stringWithFormat:@"\n Harga: %@",_totalTagihan];
                        }
                    }
                    else{
                        harga = @"";
                    }
                    NSString *message = [NSString stringWithFormat:@"Anda Akan Membeli %@ %@ dengan detail sebagai berikut : %@%@%@",_transactionNameParent,self.title,noPelanggan,denominal,harga];
                    
                    
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Konfirmasi" message:message delegate:self cancelButtonTitle:@"Batal" otherButtonTitles:@"Beli", nil] ;
                    alertView.tag = 100;
                    alertView.delegate = self;
                    [alertView show];
                    _transID  =[[posts objectAtIndex:0]objectForKey:@"trxid"];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
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
    else{
        NSString *message;
        if([params objectForKey:@"amount"]){
            if([_transactionNameParent isEqualToString:@"Asuransi"]){
                _jumlah = @"";
            }
            else{
                _jumlah = [NSString stringWithFormat:@"\n Jumlah: %@",[params objectForKey:@"amount"]];
            }
        }
        else{
            _jumlah = @"";
        }
        if([params objectForKey:@"dob"]){
            _tanggalLahir = [NSString stringWithFormat:@"\n Tanggal Lahir: %@",[params objectForKey:@"dob"]];
        }
        else{
            _tanggalLahir = @"";
        }
        if([params objectForKey:@"program"]){
            _program = [NSString stringWithFormat:@"\n Program: %@",[params objectForKey:@"program"]];
        }
        else{
            _program = @"";
        }
        if([params objectForKey:@"name"]){
            _name = [NSString stringWithFormat:@"\n Nama Lengkap: %@",[params objectForKey:@"name"]];
        }
        else{
            _name = @"";
        }
        message = [NSString stringWithFormat:@"Anda Akan Membeli %@ %@ dengan detail Sebagai Berikut: %@%@%@%@",_transactionNameParent,self.title,_name,_tanggalLahir,_program,_jumlah];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Konfirmasi" message:message delegate:self cancelButtonTitle:@"Batal" otherButtonTitles:@"Beli", nil];
        alert.tag = 101;
        alert.delegate = self;
        [alert show];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
    
}
-(void)commitTransaction2{
    
    if(_amount.length){
        [params setObject:_amount forKey:@"amount"];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [API_BeliManager urlparams:_f.url_action1 param:params postParams:^(NSArray *posts, NSError *error) {
        if(!error){
            if(posts.count>0){
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"dd-MM-YYYY"];
                NSLog(@"do nothing-->%@",posts);
                NSString *refID;
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
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSString *message = [NSString stringWithFormat:@"Anda Telah melakukan  Pembelian %@ %@ Pada Tanggal %@ \n Sebesar %@. %@",_transactionNameParent,self.title,[formatter stringFromDate:[NSDate date]],[params objectForKey:@"amount"],refID];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Berhasil" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] ;
                alertView.delegate =self;
                [alertView show];
                _logInboxs = [[Log alloc]init];
                if(_tujuanString)
                    _logInboxs.destination = _tujuanString;
                else
                    
                    _logInboxs.merchant = self.title;
                _logInboxs.actionName = [NSString stringWithFormat:@"Beli %@",_transactionNameParent];
                _logInboxs.token =[[posts objectAtIndex:0]objectForKey:@"trxid"];
                _logInboxs.expired =[NSDate date];
                _logInboxs.amount = [params objectForKey:@"amount"];
                [Log save:_logInboxs withRevision:YES];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
-(void)commitTransaction{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *param= [[NSMutableDictionary alloc]init];
    [param setObject:_transID forKey:@"transid"];
    [param setObject:[[NetraCommonFunction sharedCommonFunction]tripleDesGenerate:_tempPin]forKey:@"signature"];
    if(_tujuanString)
        [param setObject:_tujuanString forKey:@"to"];
    else
        [param setObject:_name forKey:@"to"];
    if([params objectForKey:@"amount"]){
        [param setObject:_totalTagihan forKey:@"amount"];
    }
    if([params objectForKey:@"denom"]){
        [param setObject:[params objectForKey:@"amount"] forKey:@"denom"];
    }
    NSLog(@"parameter commit->%@",param);
    [API_BeliManager urlparams:_f.url_action2 param:param postParams:^(NSArray *posts, NSError *error) {
        if(!error){
            if(posts.count>0){
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"dd-MM-YYYY"];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSString *voucherCode;
                NSString *refID;
                
                ///////get voucher code
                NSString *tujuan;
                NSLog(@"tujuan 1->%@",_tujuanString);
                NSLog(@"tujuan 2->%@",_name);
                if(_tujuanString){
                    tujuan = _tujuanString;
                    tujuan =[NSString stringWithFormat:@" Ke %@",tujuan];
                }
                else if(_name){
                    tujuan = _name;
                    tujuan =[NSString stringWithFormat:@" Ke %@",tujuan];
                }
                
                NSLog(@"data->%@",[[posts objectAtIndex:0]objectForKey:@"voucherCode"]);
                if ([[[posts objectAtIndex:0] allKeys] containsObject:@"voucherCode"]) {
                    if([[[posts objectAtIndex:0]objectForKey:@"voucherCode"] isEqual:[NSNull null]]){
                        voucherCode =@"\n Kode Voucher: -";
                    }
                    else if([[[posts objectAtIndex:0]objectForKey:@"voucherCode"] isEqualToString:@""]){
                        voucherCode =@"\n Kode Voucher: -";
                    }
                    else{
                        voucherCode =[NSString stringWithFormat:@". Voucher: %@",[[posts objectAtIndex:0]objectForKey:@"voucherCode"]];
                        tujuan = @"";
                        NSLog(@"voucher Code->%@",voucherCode);
                        
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
                
                NSString *message = [NSString stringWithFormat:@"Anda Telah Melakukan Pembelian %@ pada tanggal %@%@ Sebesar %@ %@ %@",self.title,[formatter stringFromDate:[NSDate date]],tujuan,_totalTagihan,voucherCode,refID];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Berhasil" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] ;
                alertView.delegate = self;
                [alertView show];
                _logInboxs = [[Log alloc]init];
                if(_tujuanString)
                    _logInboxs.destination = _tujuanString;
                else
                    _logInboxs.destination = _name;
                _logInboxs.merchant = self.title;
                _logInboxs.actionName = [NSString stringWithFormat:@"Beli %@",_transactionNameParent];
                _logInboxs.expired =[NSDate date];
                if ([voucherCode isEqualToString:@"\n RefID: -"]) {
                    _logInboxs.refId = @"";
                }
                else{
                    _logInboxs.refId = [[posts objectAtIndex:0]objectForKey:@"trxid"];
                }
                
                if ([voucherCode isEqualToString:@"\n Voucher: -"]) {
                    _logInboxs.voucherID = @"";
                }
                else{
                    
                    _logInboxs.voucherID = [voucherCode stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                }
                _logInboxs.amount = _totalTagihan;
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
    
    if(textField.tag==pinTag){
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



@end
