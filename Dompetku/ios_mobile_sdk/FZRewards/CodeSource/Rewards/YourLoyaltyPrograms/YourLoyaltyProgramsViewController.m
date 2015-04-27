//
//  YourLoyaltyProgramsViewController.m
//  iMobey
//
//  Created by Matthieu Barile on 14/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "YourLoyaltyProgramsViewController.h"

//Table view cell
#import "ProgramTableViewCell.h"

//Network
#import <FZAPI/RewardsServices.h>

//Your program details (cards details)
#import "YourLoyaltyProgramDetailsViewController.h"

//Session
#import <FZAPI/UserSession.h>

//Domain
#import <FZAPI/LoyaltyCard.h>
#import <FZAPI/LoyaltyProgram.h>
#import <FZAPI/LoyaltyCoupon.h>

//Utils
#import <FZAPI/FZUIImageWithFZBinaryArray.h>

//Color
#import <FZBlackBox/ColorHelper.h>

//Util
#import <FZBlackBox/ODDeviceUtil.h>

//Helper
#import <FZBlackBox/LocalizationHelper.h>

//Helper
#import <FZBlackBox/BundleHelper.h>

//Target
#import <FZBlackBox/FZTargetManager.h>

//Category
#import <FZBlackBox/FZUIImageWithImage.h>

//Session
#import <FZAPI/UserSession.h>


@interface YourLoyaltyProgramsViewController () <UITableViewDelegate,YourLoyaltyProgramDetailsViewControllerDelegate>
{
    
}

//private properties
@property (retain, nonatomic) IBOutlet UITableView *tableViewYourPrograms;

//Model
@property (retain, nonatomic) NSMutableArray *yourLoyaltyCardsList;
@property (retain, nonatomic) NSCache *logosCacheList;

@property (assign, nonatomic) BOOL isLoading;

@end

@implementation YourLoyaltyProgramsViewController
@synthesize delegate;

#pragma mark - Init

- (id)init
{
    self = [super initWithNibName:@"YourLoyaltyProgramsViewController" bundle:[BundleHelper retrieveBundle:FZBundleRewards]];
    if (self) {
        // Custom initialization
        _yourLoyaltyCardsList = [[NSMutableArray alloc] init];
        _logosCacheList = [[NSCache alloc] init];
        _isLoading = NO;
        
    }
    return self;
}

#pragma mark - Cycle life

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

-(void)viewDidAppear:(BOOL)animated
{
    if([[UserSession currentSession]isUserConnected]){
        NSLog(@"connected");
        _isLoading = NO;
        [super viewDidAppear:animated];
        [self loadYourProgramsList];
        
    }
    
    [[[FZTargetManager sharedInstance] facade] showDebugLog:@"Start rewards your programs ViewController"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[[FZTargetManager sharedInstance] facade] showDebugLog:@"Close rewards your programs ViewController"];
    
}

#pragma mark - Setup view

- (void)setupView {
	
    [_tableViewYourPrograms setSeparatorColor:[[ColorHelper sharedInstance] yourLoyaltyProgramsViewController_tableViewYourPrograms_separatorColor]];
}

#pragma mark - Functions

- (void)loadYourProgramsList {
    
    if([[[UserSession currentSession] userKey] length] != 0) {
        [self showWaitingViewWithMessage:[LocalizationHelper stringForKey:@"app_please_wait" withComment:@"YourLoyaltyProgramDetailsViewController" inDefaultBundle:FZBundleBlackBox]];
        
        __block UITableView *tableViewYourProgramsWeak = _tableViewYourPrograms;
        
        
        if([[FZTargetManager sharedInstance] mainTarget] != FZBankSDKTarget) {
            [RewardsServices fidelitizCards:[[[[UserSession currentSession] user] fidelitizId] stringValue] withSuccessBlock:^(id context) {
                
                [self loadYourProgramsListSuccessBlock:context withTableView:tableViewYourProgramsWeak];
                
            } failureBlock:^(Error *error) {
                FZRewardsLog(@"error while loading your programs");
                
                [self hideWaitingView];
                [self displayAlertForError:error];
            }];
            
        } else {
            [RewardsServices fidelitizCardsWithUserkey:[[UserSession currentSession] userKey] withSuccessBlock:^(id context) {
                
                [self loadYourProgramsListSuccessBlock:context withTableView:tableViewYourProgramsWeak];
                
            } failureBlock:^(Error *error) {
                FZRewardsLog(@"error while loading your programs");
                
                [self hideWaitingView];
                [self displayAlertForError:error];
            }];
        }
    }
}

- (void)loadYourProgramsListSuccessBlock:(id) context withTableView:(UITableView *) tableViewYourProgramsWeak{
    [_yourLoyaltyCardsList removeAllObjects];
    [_yourLoyaltyCardsList addObjectsFromArray:context];
    
    [tableViewYourProgramsWeak reloadData];
    [self hideWaitingView];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_yourLoyaltyCardsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProgramTableViewCell *cell = [ProgramTableViewCell dequeueReusableCellWithtableView:tableView];
    
    if (cell == nil) {
        cell = [ProgramTableViewCell loadCellWithOwner:self inDefault:FZBundleRewards];
    } else {
        [cell reset];
    }
    
    LoyaltyCard *card = [_yourLoyaltyCardsList objectAtIndex:indexPath.row];
    
    
    UIImage *logo = [_logosCacheList objectForKey:[NSNumber numberWithInteger:[indexPath row]]];
    
    if(nil==logo) {
        //load logos from the server
        [RewardsServices programDetails:[card loyaltyProgramId] withLogo:YES withSuccessBlock:^(id context) {
            
            NSInteger row = [indexPath row];
            
            UIImage *imageLogo = [FZUIImageWithFZBinaryArray imageFromBinaryArray:[(LoyaltyProgram*)context logo] withDefautImage:[FZUIImageWithImage imageNamed:@"logo_default" inBundle:FZBundleAPI]];
            
            //image can be nil
            if(nil!=imageLogo) {
                [_logosCacheList setObject:imageLogo forKey:[NSNumber numberWithInteger:row]];
            }
            
            [cell setLogo:imageLogo];
            
        } failureBlock:^(Error *error) {
            FZRewardsLog(@"error while loading the associated programs");
        }];
    }
    else {
        [cell setLogo:logo];
    }
    
    //check the program type
    if ([[card loyaltyProgramType] isEqualToString:@"PERMANENT_PERCENTAGE_DISCOUNT"]) {//if percent
        
        [cell setUpTableCellViewWithIndicationPointsAndPercent:[NSString stringWithFormat:@"%.0f%%",[card permanentPercentageDiscount]]];
        
    } else if([[card loyaltyProgramType] isEqualToString:@"POINTS"]) {//if points
        
        NSArray *cardCoupons = [card coupons];
        
        if([cardCoupons count] > 0){//if you have any coupons
            
            //LoyaltyCoupon *loyaltyCoupon = [LoyaltyCoupon loyaltyCouponWithDictionary:[cardCoupons firstObject] error:error];
            [LoyaltyCoupon loyaltyCouponWithDictionary:[cardCoupons firstObject] successBlock:^(id object) {
                if([(LoyaltyCoupon *)object couponType] == COUPON_TYPE_PERCENT){
                    [cell setUpTableCellViewWithIndicationCouponsPercent:[NSString stringWithFormat:@"%.0lu x",(unsigned long)[cardCoupons count]] :[NSString stringWithFormat:@"%.2f",[card discountAmount]]];
                } else {
                    [cell setUpTableCellViewWithIndicationCoupons:[NSString stringWithFormat:@"%.0lu x",(unsigned long)[cardCoupons count]] :[NSString stringWithFormat:@"%.2f",[card discountAmount]]];
                }
            } failureBlock:^(Error *error) {
                NSLog(@"do not add malformed LoyaltyCoupon");
                //do not add malformed LoyaltyCoupon
            }];
        } else {//if you have not points, show your points
            [cell setUpTableCellViewWithIndicationPointsAndPercent:[NSString stringWithFormat:@"%.0f/%d",[_yourLoyaltyCardsList[indexPath.row] balance],[card pointAmountForCoupon]]];
        }
    }
    
    [cell setProgramName:[card loyaltyProgramLabel]];
    [cell setMerchantName:[card ownerCompanyName]];
    
    if(indexPath.row %2 == 0 ){
        [cell isOdd];
    }
    else{
        [cell isEven];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(!_isLoading){
        _isLoading = YES;
    }else{
        //Double click handle
        return;
    }
    
    [self showWaitingViewWithMessage:[LocalizationHelper stringForKey:@"app_please_wait" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]];
    
    [RewardsServices programDetails:[_yourLoyaltyCardsList[indexPath.row] loyaltyProgramId] withLogo:YES withSuccessBlock:^(id context) {
        
        YourLoyaltyProgramDetailsViewController *controller = [[self multiTargetManager] yourLoyaltyProgramDetailsViewControllerWithLoyaltyCard:_yourLoyaltyCardsList[indexPath.row] program:(LoyaltyProgram*)context];
        
        [controller setDelegate:self];
        
        [[[FZTargetManager sharedInstance]facade]presentFromController:[[[FZTargetManager sharedInstance]facade]tabBarControllerNavigation] inAppWith:controller andMode:CustomNavigationModeBack animated:YES];
        
        [self hideWaitingView];
        
        _isLoading = NO;
        
        // TODO: need refactor
        //[TestFlightHelper passRewardsShowSuscribedProgramDetails];
        
    } failureBlock:^(Error *error) {
        FZRewardsLog(@"error while loading the associated programs");
        [self hideWaitingView];
        [self displayAlertForError:error];
    }];
}

#pragma mark - CustomNavigationHeaderViewController delegate methods

- (void)didClose:(CustomNavigationHeaderViewController *)_controller {
    // TODO : nothing to do, never used
}

- (void)didGoBack:(CustomNavigationHeaderViewController *)_controller {
    
    [[self navigationController]popToRootViewControllerAnimated:YES];
}


#pragma mark - Delegates

- (void)showYourProgramsAndRefreshAllPrograms:(BOOL)needRefresh {
    if([delegate respondsToSelector:@selector(setSgmCtrlProgramsToYourProgramsAndShowYourProgramsAndRefreshPrograms:)]){
        [delegate setSgmCtrlProgramsToYourProgramsAndShowYourProgramsAndRefreshPrograms:needRefresh];
    }
}

#pragma mark - Usefull Methods

-(void) emptyCacheList {
    [[self logosCacheList] removeAllObjects];
}

#pragma mark - MM

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableViewYourPrograms release];
    [_yourLoyaltyCardsList release];
    [_logosCacheList release];
    [super dealloc];
}
@end
