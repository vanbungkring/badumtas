//
//  HistoryViewController.m
//  iMobey
//
//  Created by Neopixl on 21/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "HistoryViewController.h"

//Services
#import <FZAPI/InvoiceServices.h>
#import <FZAPI/TransactionServices.h>
#import <FZAPI/ConnectionServices.h>
#import <FZAPI/AvatarServices.h>

//Domain
#import <FZAPI/UserSession.h>
#import "HistoryDetailCell.h"
#import "HistoryConfirmationCell.h"

//Controllers
#import "AccountBannerViewController.h"

//Helper
#import <FZBlackBox/LocalizationHelper.h>
#import <FZBlackBox/ColorHelper.h>

//Util
#import <FZBlackBox/FZUIImageWithImage.h>

//Color
#import <FZBlackBox/FZUIColorCreateMethods.h>
#import <FZBlackBox/ColorsConstants.h>

#import <FZAPI/FZUIImageWithFZBinaryArray.h>

//Bundle Helper
#import <FZBlackBox/BundleHelper.h>

//Tracker
#import <FZBlackBox/StatisticsFactory.h>


//Targets manager
#import <FZBlackBox/FZTargetManager.h>

#define kRowHeight 90.0

#define kConfirmationRowHeight 170.0
//comments
#define kCommentRowHeight 140.0
#define kDefaultCommentHeight 35.0
#define kAdjustCommentHeight 7.0

#define kCommentFont [UIFont fontWithName:@"Helvetica" size:11.0f]

enum {
    kFilterAll = 0,
    kFilterOutput = 1,
    kFilterInput = 2,
    kFilterPending = 3
};

@interface HistoryViewController ()<HistoryDetailCellDelegate>
{
    
}

//View
@property (retain, nonatomic) IBOutlet UITableView *transactionsTableView;
@property (retain, nonatomic) IBOutlet UIButton *allButton;
@property (retain, nonatomic) IBOutlet UIButton *outputButton;
@property (retain, nonatomic) IBOutlet UIButton *inputButton;
@property (retain, nonatomic) IBOutlet UIButton *pendingButton;
//badge pending
@property (nonatomic, retain) IBOutlet UIView *badgeView;
@property (nonatomic, retain) IBOutlet UILabel *pendingLabel;
@property (retain, nonatomic) IBOutlet UIView *viewAccountBanner;
@property (retain, nonatomic) IBOutlet UIImageView *imgNumberOf;

//Model
@property (nonatomic, retain) NSArray *transactions;
@property (nonatomic, retain) NSArray *filteredTransactions;
@property (nonatomic, retain) NSArray *filterButtons;
@property (nonatomic, retain) NSMutableArray *selectedIndex;
@property (nonatomic) int currentFilter;
@property (nonatomic) BOOL isSelected;


@property (retain, nonatomic)NSMutableDictionary *avatarCacheList;

//Controller
@property (retain,nonatomic) AccountBannerViewController *accountBannerViewController;



@end

static NSString *cellIdentifier = @"historyCell";

#pragma mark - Constructor

@implementation HistoryViewController

- (id)init
{
    self = [super initWithNibName:@"HistoryViewController" bundle:[BundleHelper retrieveBundle:FZBundlePayment]];
    if (self) {
        [self setTitleHeader:[LocalizationHelper stringForKey:@"historic" withComment:@"AccountBannerViewController" inDefaultBundle:FZBundleCoreUI]];
        [self setTitleColor:[[ColorHelper sharedInstance] whiteColor]];
        [self setBackgroundColor:[[ColorHelper sharedInstance] historyViewController_header_backgroundColor]];
        
        _avatarCacheList = [[NSMutableDictionary alloc] init];
        [self setCanDisplayMenu:NO];
    }
    return self;
}

#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
}

-(void)setupView
{
    //badge pending
    [_badgeView setHidden:YES];
    
    //init array of buttons
    _filterButtons = [[NSArray alloc] initWithObjects:_allButton, _outputButton, _inputButton, _pendingButton, nil];
    //select first button
    [_allButton setBackgroundColor:[[ColorHelper sharedInstance] historyViewController_allButton_backgroundColor]];
    [_allButton setSelected:YES];
    [_allButton setUserInteractionEnabled:NO];
    
    //Customize filters buttons
    //all
    [[_allButton layer] setBorderWidth:1.0];
    [[_allButton layer] setCornerRadius:4.0];
    [[_allButton layer] setBorderColor:[[[ColorHelper sharedInstance] historyViewController_allButton_borderColor] CGColor]];
    [_allButton setTitleColor:[[ColorHelper sharedInstance] historyViewController_allButton_borderColor] forState:UIControlStateNormal];
    [_allButton setTitleColor:[[ColorHelper sharedInstance] historyViewController_allButton_borderColor] forState:UIControlStateHighlighted];
    //output
    [_outputButton setTitleColor:[[ColorHelper sharedInstance] historyViewController_outputButton_titleColor] forState:UIControlStateNormal];
    [_outputButton setTitleColor:[[ColorHelper sharedInstance] historyViewController_outputButton_titleColor] forState:UIControlStateHighlighted];
    [[_outputButton layer] setBorderColor:[[[ColorHelper sharedInstance] historyViewController_outputButton_borderColor] CGColor]];
    [[_outputButton layer] setBorderWidth:1.0];
    [[_outputButton layer] setCornerRadius:4.0];
    //input
    [_inputButton setTitleColor:[[ColorHelper sharedInstance] historyViewController_inputButton_titleColor] forState:UIControlStateNormal];
    [_inputButton setTitleColor:[[ColorHelper sharedInstance] historyViewController_inputButton_titleColor] forState:UIControlStateHighlighted];
    [[_inputButton layer] setBorderColor:[[[ColorHelper sharedInstance] historyViewController_inputButton_borderColor] CGColor]];
    [[_inputButton layer] setBorderWidth:1.0];
    [[_inputButton layer] setCornerRadius:4.0];
    //pending
    [_pendingButton setTitleColor:[[ColorHelper sharedInstance] historyViewController_pendingButton_titleColor] forState:UIControlStateNormal];
    [_pendingButton setTitleColor:[[ColorHelper sharedInstance] historyViewController_pendingButton_titleColor] forState:UIControlStateHighlighted];
    [[_pendingButton layer] setBorderColor:[[[ColorHelper sharedInstance] historyViewController_pendingButton_borderColor] CGColor]];
    [[_pendingButton layer] setBorderWidth:1.0];
    [[_pendingButton layer] setCornerRadius:4.0];
    
    // Do any additional setup after loading the view from its nib.
    [[self transactionsTableView] registerNib:[UINib nibWithNibName:@"HistoryDetailCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    //showuser banner
    _accountBannerViewController = [[[self multiTargetManager] accountBannerViewController] retain];
    
    [_accountBannerViewController setDelegate:self];
    [_accountBannerViewController setChangeAvatarRules:YES];
    
    [_viewAccountBanner addSubview:[_accountBannerViewController view]];
    [self addChildViewController:_accountBannerViewController];
    
    [[_accountBannerViewController btnGoToOrCloseHistoric] setHidden:YES];
    
    _selectedIndex = [[NSMutableArray alloc] init];
    
    [_transactionsTableView setSeparatorColor:[UIColor clearColor]];
    
    //init localized text for buttons
    [_allButton setTitle:[[LocalizationHelper stringForKey:@"all" withComment:@"HistoryViewController" inDefaultBundle:FZBundlePayment] uppercaseString]forState:UIControlStateNormal];
    [_outputButton setTitle:[[LocalizationHelper stringForKey:@"output" withComment:@"HistoryViewController" inDefaultBundle:FZBundlePayment] uppercaseString] forState:UIControlStateNormal];
    [_inputButton setTitle:[[LocalizationHelper stringForKey:@"input" withComment:@"HistoryViewController" inDefaultBundle:FZBundlePayment] uppercaseString] forState:UIControlStateNormal];
    [_pendingButton setTitle:[[LocalizationHelper stringForKey:@"waiting" withComment:@"HistoryViewController" inDefaultBundle:FZBundlePayment] uppercaseString] forState:UIControlStateNormal];
    [[_pendingButton titleLabel] setAdjustsFontSizeToFitWidth:YES];
    [[_pendingButton titleLabel] setMinimumScaleFactor:0.5];
    
    [_imgNumberOf setImage:[FZUIImageWithImage imageNamed:@"icon_badge" inBundle:FZBundlePayment]];
    
    [self refreshUserInformations];
}

- (void)refreshUserInformations {
    // refresh account
    [ConnectionServices retrieveUserInfosLight:[[UserSession currentSession] userKey] successBlock:^(id context) {
        [[UserSession currentSession] setUser:context];
    } failureBlock:^(Error *error) {
        FZPaymentLog(@"failed while retrieving user infos");
        [self displayAlertForError:error];
    }];
}

- (void)viewDidLayoutSubviews {
    CGRect transactionsTableViewFrame = [_transactionsTableView frame];
    CGRect superViewFrame = [[[self view] superview] frame];
    transactionsTableViewFrame.size.height = superViewFrame.size.height - transactionsTableViewFrame.origin.y;
    [_transactionsTableView setFrame:transactionsTableViewFrame];
}

-(void)loadTransactions{
    
    BOOL isUserTrial = [[[UserSession currentSession] user] isTrial];
    
    if(isUserTrial){
        [ConnectionServices updateIfStillTrial];
        isUserTrial = [[[UserSession currentSession] user] isTrial];
    }
    
    if(!isUserTrial) {
        
        [self showWaitingViewWithMessage:[LocalizationHelper stringForKey:@"app_loading" withComment:@"HistoryViewController" inDefaultBundle:FZBundleBlackBox]];
        
        [InvoiceServices getTransactionsHistory:[[UserSession currentSession] userKey] successBlock:^(id context) {
            [self setTransactions:context];
            
            NSPredicate *pendingPredicate = [NSPredicate predicateWithFormat:@"self.pending == 1"];
            int pendingCount = [[_transactions filteredArrayUsingPredicate:pendingPredicate] count];
            
            if(pendingCount){
                [_pendingLabel setText:[NSString stringWithFormat:@"%d",pendingCount]];
                [_badgeView setHidden:NO];
                
            }
            else{
                [_badgeView setHidden:YES];
            }
            
            if([_selectedIndex count]){
                [_selectedIndex removeAllObjects];
            }
            
            [self setFilteredTransactions];
            
            //images
            for(NSInteger i = 0; i < [[self transactions] count];i++){
                
                if([_avatarCacheList objectForKey:[[self transactions][i] receiverInfo]] == nil){
                    
                    if([[self transactions][i] creditorUsername] && ![[[self transactions][i] creditorUsername]isEqualToString:@"unknown"]){
                        [AvatarServices avatarWithUserName:[[self transactions][i] creditorUsername] successBlock:^(id context) {
                            
                            [self storeAvatar:[FZUIImageWithFZBinaryArray imageFromBinaryArray:context withDefautImage:[FZUIImageWithImage imageNamed:@"logo_default.png" inBundle:FZBundleAPI]]
                                       forKey:[[self transactions][i] creditorUsername]];
                            
                            if(i < [_transactionsTableView numberOfRowsInSection:0]){//reload rows only if they are in the tableview (prevent navigation between all/debit/credit/pending transactions)
                                [_transactionsTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:
                                                                                [NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                            }
                            
                        } failureBlock:^(Error *error) {
                            FZPaymentLog(@"Failed to load transaction avatar: %@", [[self transactions][i] creditorUsername]);
                        }];
                    } else if([[self transactions][i] debitorUsername] && ![[[self transactions][i] debitorUsername]isEqualToString:@"unknown"]){
                        [AvatarServices avatarWithUserName:[[self transactions][i] debitorUsername] successBlock:^(id context) {
                            
                            [self storeAvatar:[FZUIImageWithFZBinaryArray imageFromBinaryArray:context withDefautImage:[FZUIImageWithImage imageNamed:@"logo_default.png" inBundle:FZBundleAPI]]
                                       forKey:[[self transactions][i] debitorUsername]];
                            
                            if(i < [_transactionsTableView numberOfRowsInSection:0]){//reload rows only if they are in the tableview (prevent navigation between all/debit/credit/pending transactions)
                                [_transactionsTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:
                                                                                [NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                            }
                            
                        } failureBlock:^(Error *error) {
                            FZPaymentLog(@"Failed to load transaction avatar: %@", [[self transactions][i] debitorUsername]);
                        }];
                    }
                }
            }
                        
            [_transactionsTableView reloadData];
            
            if([[FZTargetManager sharedInstance] mainTarget] == FZAppTarget && [[[FZTargetManager sharedInstance] brandName]isEqualToString:@"leclerc"]) {
                [[self outputButton] sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
            
            [self hideWaitingView];
        } failureBlock:^(Error *error) {
            FZPaymentLog(@"Failed to load transactions");
            
            [self displayAlertForError:error];
            [self hideWaitingView];
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_accountBannerViewController viewWillAppear:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self loadTransactions];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_accountBannerViewController viewDidDisappear:YES];
}

-(void)didChangeValueForKey:(NSString *)key{
    [[self transactionsTableView] reloadData];
}

-(void) activateFilterButtton:(UIButton *)filterButton{
    
    for(UIButton *aButton in _filterButtons){
        if([aButton isSelected]){
            [aButton setSelected:NO];
            [aButton setUserInteractionEnabled:YES];
            [aButton setBackgroundColor:[UIColor whiteColor]];
        }
    }
    [filterButton setSelected:YES];
    [filterButton setUserInteractionEnabled:NO];
    [filterButton setBackgroundColor:[[filterButton titleLabel] textColor]];
}


-(void) setFilteredTransactions{
    
    switch (_currentFilter) {
        case kFilterAll:{
            [self setFilteredTransactions:nil];
            break;
        }
        case kFilterOutput:
        {
            NSPredicate *outputPredicate = [NSPredicate predicateWithFormat:@"(self.debitor == %i) AND (self.status == %@)",[[[[UserSession currentSession] user] account] accountId], @"EXE"];
            [self setFilteredTransactions:[_transactions filteredArrayUsingPredicate:outputPredicate]];
            break;
        }
        case kFilterInput:{
            NSPredicate *inputPredicate = [NSPredicate predicateWithFormat:@"self.creditor == %i AND (self.status == %@)",[[[[UserSession currentSession] user] account] accountId], @"EXE"];
            
            [self setFilteredTransactions:[_transactions filteredArrayUsingPredicate:inputPredicate]];
            break;
        }
        case kFilterPending:{
            NSPredicate *pendingPredicate = [NSPredicate predicateWithFormat:@"self.pending == 1"];
            
            [self setFilteredTransactions:[_transactions filteredArrayUsingPredicate:pendingPredicate]];
            break;
        }
    }
}

#pragma mark - Private method

- (void)storeAvatar:(UIImage *)imageAvatar forKey:(NSString *)key {
    if(nil!=imageAvatar && nil!=key) {
        [_avatarCacheList setObject:imageAvatar
                             forKey:key];
    }
}

- (void)updateTableViewAnimated:(NSInteger)direction {
    
    [self setDisplayConfirmation:NO];
    
    [_transactionsTableView beginUpdates];
    
    NSArray *transactions = [self currentArray];
    
    NSMutableArray *indexPathes = [[NSMutableArray alloc] init];
    
    for(NSInteger i=0;i<[transactions count];i++) {
        [indexPathes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [_transactionsTableView deleteRowsAtIndexPaths:indexPathes
                                  withRowAnimation:UITableViewRowAnimationBottom];
    
    [self setFilteredTransactions];
    
    transactions = [self currentArray];
    
    [indexPathes removeAllObjects];
    for(NSInteger i=0;i<[transactions count];i++) {
        [indexPathes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [_transactionsTableView insertRowsAtIndexPaths:indexPathes
                                  withRowAnimation:UITableViewRowAnimationBottom];
    
    
    [_transactionsTableView endUpdates];
    
    [indexPathes release];
}

#pragma mark - actions

//remover filter
- (IBAction)didTapAllButton:(id)sender {
    [[StatisticsFactory sharedInstance] checkPointHistoryAll];
    [self activateFilterButtton:(UIButton *)sender];
    
    int previousFilter = _currentFilter;
    
    [self setCurrentFilter:kFilterAll];
    [self updateTableViewAnimated:_currentFilter-previousFilter];
}

//filter debitor
- (IBAction)didTapOutputButton:(id)sender {
    [[StatisticsFactory sharedInstance] checkPointHistoryDebit];
    
    [self activateFilterButtton:(UIButton *)sender];
    
    int previousFilter = _currentFilter;
    
    [self setCurrentFilter:kFilterOutput];
    [self updateTableViewAnimated:_currentFilter-previousFilter];
    
    //[TestFlightHelper passHistoricOutput];
}

//filter creditor
- (IBAction)didTapInputButton:(id)sender {
    [[StatisticsFactory sharedInstance] checkPointHistoryCredit];
    
    [self activateFilterButtton:(UIButton *)sender];
    
    int previousFilter = _currentFilter;
    
    [self setCurrentFilter:kFilterInput];
    [self updateTableViewAnimated:_currentFilter-previousFilter];
    
    //[TestFlightHelper passHistoricInput];
}

//filter waiting transaction
- (IBAction)didTapWaitingButton:(id)sender {
    
    [[StatisticsFactory sharedInstance] checkPointHistoryPending];
    [self activateFilterButtton:(UIButton *)sender];
    
    int previousFilter = _currentFilter;
    
    [self setCurrentFilter:kFilterPending];
    [self updateTableViewAnimated:_currentFilter-previousFilter];
}

//return array used in tableview
- (NSArray *) currentArray{
    return (_filteredTransactions!=nil) ? _filteredTransactions : _transactions;
}


#pragma mark - table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[self currentArray] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Transaction *transaction = [[self currentArray] objectAtIndex:indexPath.row];
    
    //confirmation cell
    if(_displayConfirmation && indexPath.row == 0){
        return kConfirmationRowHeight;
    }
    //has comment
    else if([[transaction comment] length]){
        //comment is open
        if([_selectedIndex containsObject:[NSNumber numberWithInteger:indexPath.row]]){
            
            //calculate opened comment height
            UILabel * tmpCommentLabel = [[UILabel alloc] init];
            [tmpCommentLabel setNumberOfLines:0];
            [tmpCommentLabel setText:[[[self currentArray] objectAtIndex:indexPath.row] comment]];
            
            CGSize commentSize = [[tmpCommentLabel text] sizeWithFont:kCommentFont constrainedToSize:CGSizeMake(_transactionsTableView.bounds.size.width, 1000.0)];
            
            [tmpCommentLabel release];
            
            return kCommentRowHeight + (commentSize.height > kDefaultCommentHeight ? commentSize.height - kDefaultCommentHeight : 0);
        }
        return kCommentRowHeight;
    }
    else{
        return kRowHeight;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    Transaction *transaction = [[self currentArray] objectAtIndex:indexPath.row];
    
    //comming from payment, first cell looks like a confirmation
    if(_displayConfirmation && indexPath.row == 0){
        HistoryConfirmationCell *cCell = (HistoryConfirmationCell*)[_transactionsTableView dequeueReusableCellWithIdentifier:[[HistoryConfirmationCell class] description]];
        
        if (cCell == nil) {
            cCell = [[[NSBundle mainBundle] loadNibNamed:[[HistoryConfirmationCell class] description] owner:self options:nil] objectAtIndex:0] ;
            [cCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        [cCell fillWithTransaction:transaction];
        
        cell = (UITableViewCell *)cCell;
    }
    //transaction cell
    else{
        HistoryDetailCell *hCell = (HistoryDetailCell*)[_transactionsTableView dequeueReusableCellWithIdentifier:[[HistoryDetailCell class] description]];
        if (hCell == nil) {
            hCell = [[[BundleHelper retrieveBundle:FZBundlePayment] loadNibNamed:[[HistoryDetailCell class] description] owner:self options:nil] objectAtIndex:0] ;
            [hCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        [hCell setDelegate:self];
        
        [hCell fillWithTransaction:[[self currentArray] objectAtIndex:indexPath.row]];
        
        if([_avatarCacheList objectForKey:[transaction creditorUsername]]){
            [hCell setAvatar:[_avatarCacheList objectForKey:[transaction creditorUsername]]];
        } else if([_avatarCacheList objectForKey:[transaction debitorUsername]]){
            [hCell setAvatar:[_avatarCacheList objectForKey:[transaction debitorUsername]]];
        }
        else{
            [hCell setAvatar:nil];
        }
        
        //show action view to confirm or cancel transaction
        if([transaction pending] && [_selectedIndex containsObject:[NSNumber numberWithInteger:indexPath.row]]){
            if([transaction creditor] == [[[[UserSession currentSession] user] account] accountId]){
                [hCell showCreditorActionView:YES];
            }
            else{
                [hCell showDebitorActionView:YES];
            }
        }
        
        //open or close comments
        if([[transaction comment] length]){
            //opened
            if([_selectedIndex containsObject:[NSNumber numberWithInteger:indexPath.row]]){
                //resize comment label depending on comment length
                CGSize labelSize = [[transaction comment] sizeWithFont:kCommentFont constrainedToSize:CGSizeMake([hCell lblComment].bounds.size.width, 1000.)];
                
                [[hCell lblComment] setFrame:CGRectMake([hCell lblComment].frame.origin.x, [hCell lblComment].frame.origin.y,[hCell lblComment].frame.size.width, (labelSize.height > kDefaultCommentHeight ? labelSize.height+kAdjustCommentHeight : kDefaultCommentHeight))];
                
                [hCell commentIsOpen:YES];
                
            }
            else{
                
                [hCell commentIsOpen:NO];
                
                [[hCell lblComment] setFrame:CGRectMake([hCell lblComment].frame.origin.x, [hCell lblComment].frame.origin.y,[hCell lblComment].frame.size.width, kDefaultCommentHeight)];
            }
            
            //resize left color indicator
            [[hCell indicatorColorView] setFrame:CGRectMake([hCell indicatorColorView].frame.origin.x, [hCell indicatorColorView].frame.origin.y, [hCell indicatorColorView].frame.size.width, kRowHeight + [hCell lblComment].frame.size.height > kCommentRowHeight ?  kRowHeight + [hCell lblComment].frame.size.height+kAdjustCommentHeight : kCommentRowHeight)];
        }
        
        cell = (UITableViewCell *)hCell;
    }
    
    if(indexPath.row %2 == 0 ){
        [[cell contentView] setBackgroundColor:[[ColorHelper sharedInstance] historyViewController_contentView_backgroundColor]];
        if ([cell isKindOfClass:[HistoryDetailCell class]]) {
            [[(HistoryDetailCell *)cell maskImageView] setImage:[FZUIImageWithImage imageNamed:@"mask_history_list_grey" inBundle:FZBundlePayment]];
        }
        
    }
    else{
        [[cell contentView] setBackgroundColor:[UIColor whiteColor]];
        if ([cell isKindOfClass:[HistoryDetailCell class]]) {
            [[(HistoryDetailCell *)cell maskImageView] setImage:[FZUIImageWithImage imageNamed:@"mask_history_list_white" inBundle:FZBundlePayment]];
        }
    }
    
    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //manage collection of touched index (use for comments and action view)
    if([_selectedIndex containsObject:[NSNumber numberWithInteger:indexPath.row]]){
        [_selectedIndex removeObject:[NSNumber numberWithInteger:indexPath.row]];
    }
    else{
        [_selectedIndex addObject:[NSNumber numberWithInteger:indexPath.row]];
    }
    
    //refresh table to animate
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [tableView endUpdates];
    
    [_transactionsTableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark - historycell delegate

-(void)validatePendingTransaction:(Transaction*)transaction{
    
    [self showWaitingViewWithMessage:[LocalizationHelper stringForKey:@"validating_transactions" withComment:@"HistoryViewController" inDefaultBundle:FZBundlePayment]];
    
    [TransactionServices executeTransactionsWithId:[transaction transactionId] forUser:[[UserSession currentSession] userKey] successBlock:^(id context) {
        
        [_accountBannerViewController setBalance:[context floatValue]];
        
        // refresh account
        [ConnectionServices retrieveUserInfosLight:[[UserSession currentSession] userKey] successBlock:^(id context) {
            [[UserSession currentSession] setUser:context];
        } failureBlock:^(Error *error) {
            FZPaymentLog(@"failed while retrieving user infos");
            [self displayAlertForError:error];
        }];
        
        [self hideWaitingView];
        
        [self loadTransactions];
        
    } failureBlock:^(Error *error) {
        
        FZPaymentLog(@"error to validate transaction %@", error);
        
        [self displayAlertForError:error];
        
        [self hideWaitingView];
    }];
    
}

-(void)cancelPendingTransaction:(Transaction*)transaction{
    
    NSString *side = [transaction creditor] == [[[[UserSession currentSession] user] account] accountId]
    ? @"receiver" : @"sender";
    
    
    [self showWaitingViewWithMessage:[LocalizationHelper stringForKey:@"cancelling_transactions" withComment:@"HistoryViewController" inDefaultBundle:FZBundlePayment]];
    
    [TransactionServices cancelTransactionsWithId:[transaction transactionId] forUser:[[UserSession currentSession] userKey] andSide:side successBlock:^(id context) {
        
        [_accountBannerViewController setBalance:[context floatValue]];
        
        // refresh account
        [ConnectionServices retrieveUserInfosLight:[[UserSession currentSession] userKey] successBlock:^(id context) {
            [[UserSession currentSession] setUser:context];
        } failureBlock:^(Error *error) {
            FZPaymentLog(@"failed while retrieving user infos");
            [self displayAlertForError:error];
        }];
        
        [self hideWaitingView];
        
        [self loadTransactions];
        
    } failureBlock:^(Error *error) {
        FZPaymentLog(@"error to cancel transaction %@", error);
        
        [self displayAlertForError:error];
        
        [self hideWaitingView];
    }];
}


#pragma mark -NavigationViewController delegate methods

- (void)didGoBack:(CustomNavigationHeaderViewController *)controller {
    [[StatisticsFactory sharedInstance] checkPointHistoryQuit];
    [[self navigationController]popViewControllerAnimated:YES];
}

#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    [_avatarCacheList release], _avatarCacheList = nil;
    
    [_badgeView release], _badgeView = nil;
    [_pendingLabel release], _pendingLabel = nil;
    
    [_filterButtons release], _filterButtons = nil;
    [_allButton release], _allButton = nil;
    [_outputButton release], _outputButton = nil;
    [_inputButton release], _inputButton = nil;
    [_pendingButton release], _pendingButton = nil;
    
    [_selectedIndex release];
    [_accountBannerViewController release];
    [_transactions release];
    [_transactionsTableView release];
    [_filteredTransactions release]; _filteredTransactions = nil;
    [_viewAccountBanner release];
    [_imgNumberOf release];
    [super dealloc];
}

@end
