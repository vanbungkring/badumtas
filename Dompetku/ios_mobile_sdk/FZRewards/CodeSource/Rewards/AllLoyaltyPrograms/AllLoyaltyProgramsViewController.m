//
//  AllLoyaltyProgramsViewController.m
//  iMobey
//
//  Created by Matthieu Barile on 14/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "AllLoyaltyProgramsViewController.h"

//Network
#import <FZAPI/RewardsServices.h>

//custom loyalty programs navigation bar
#import "AllLoyaltyProgramsNavBarViewController.h"
#import "AllLoyaltyProgramsNavBarOpenedViewController.h"

//Table view cell
#import "ProgramTableViewCell.h"

//Session
#import <FZAPI/UserSession.h>

//Utils
#import <FZAPI/FZUIImageWithFZBinaryArray.h>

//Util
#import <FZBlackBox/ODDeviceUtil.h>

//Localizable
#import <FZBlackBox/LocalizationHelper.h>

//Error
#import <FZAPI/Error.h>

//Helper
#import <FZBlackBox/BundleHelper.h>

//Manager
#import <FZBlackBox/FZTargetManager.h>

//Category
#import <FZBlackBox/FZUIImageWithImage.h>

#define kRowHeight 80.0

@interface AllLoyaltyProgramsViewController () <UITableViewDelegate,AllLoyaltyProgramsNavBarViewControllerDelegate,AllLoyaltyProgramsNavBarOpenedViewControllerDelegate,LoyaltyProgramDetailsViewControllerDelegate> {
    
}

//View
@property (retain, nonatomic) IBOutlet UIView *viewAllProgramsNavBar;

//Model
@property (retain, nonatomic) NSMutableArray *allProgramsList;
@property (retain, nonatomic) NSMutableArray *allProgramsSavedList;


@property (retain, nonatomic) AllLoyaltyProgramsNavBarOpenedViewController *allProgramsNavBarOpened;
@property (retain, nonatomic) AllLoyaltyProgramsNavBarViewController *allProgramsNavBar;

@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) BOOL needRefreshAfterError;

@end

@implementation AllLoyaltyProgramsViewController
@synthesize delegate;

#pragma mark - Init

- (id)init
{
    self = [super initWithNibName:@"AllLoyaltyProgramsViewController" bundle:[BundleHelper retrieveBundle:FZBundleRewards]];
    if (self) {
        // Custom initialization
        _allProgramsList = [[NSMutableArray alloc] init];
        _allProgramsSavedList = [[NSMutableArray alloc] init];
        
        _allProgramsNavBarOpened = [[[self multiTargetManager] allLoyaltyProgramsNavBarOpenedViewController] retain];
        [_allProgramsNavBarOpened setDelegate:self];
        
        _allProgramsNavBar = [[[self multiTargetManager] allLoyaltyProgramsNavBarViewController] retain];
        [_allProgramsNavBar setDelegate:self];
        
        _isLoading = NO;
        
    }
    return self;
}

#pragma mark - Cycle life

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setAutoresizesSubviews:YES];
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_needRefreshAfterError) {
        [self loadAllPrograms];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([[UserSession currentSession]isUserConnected]){
        NSLog(@"connected");
        _isLoading = NO;
        
        //TODO: can be optimized
        if([(RewardsHomeViewController *)[self parentViewController] respondsToSelector:@selector(needRefreshAllPrograms)]) {
            if([(RewardsHomeViewController *)[self parentViewController] needRefreshAllPrograms]){
                [self loadAllPrograms];
                [(RewardsHomeViewController *)[self parentViewController] setNeedRefreshAllPrograms:NO];
            }
        }
        
    }else{
        NSLog(@"no connect, no loading");
    }
    
    
    [[[FZTargetManager sharedInstance] facade] showDebugLog:@"Start rewards all programs ViewController"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[[FZTargetManager sharedInstance] facade] showDebugLog:@"Close rewards all programs ViewController"];
}

#pragma mark - Set up view

- (void)setUpView {
    [self switchToNavBar];
    //[self showNearPrograms]; //Descope
    [self showSearchTextField];
    [_tableViewAllPrograms setSeparatorColor:[UIColor clearColor]];
    
    _needRefreshAfterError = NO;
}

#pragma mark - Functions

- (void)switchToNavBar {
    
    [_allProgramsNavBarOpened.view removeFromSuperview];
    _allProgramsNavBarOpened.view.bounds = _viewAllProgramsNavBar.bounds;
    [_viewAllProgramsNavBar addSubview:_allProgramsNavBar.view];
}

- (void)switchToNavBarOpened {
    
    [_allProgramsNavBar.view removeFromSuperview];
    _allProgramsNavBarOpened.view.bounds = _viewAllProgramsNavBar.bounds;
    [_viewAllProgramsNavBar addSubview:_allProgramsNavBarOpened.view];
}

-(void)activateNearProgramsButton{
    
    [[_allProgramsNavBar btnNearPrograms] setSelected:YES];
    [[_allProgramsNavBar btnNearPrograms] setUserInteractionEnabled:NO];
    
    
    [[_allProgramsNavBar btnSuggestedPrograms] setSelected:NO];
    [[_allProgramsNavBar btnSuggestedPrograms] setUserInteractionEnabled:YES];
}

-(void)activateSuggestedProgramsButton{
    [[_allProgramsNavBar btnSuggestedPrograms] setSelected:YES];
    [[_allProgramsNavBar btnSuggestedPrograms] setUserInteractionEnabled:NO];
    
    [[_allProgramsNavBar btnNearPrograms] setSelected:NO];
    [[_allProgramsNavBar btnNearPrograms] setUserInteractionEnabled:YES];
}

#pragma mark - Delegates

//all programs navigation bar
- (void)showNearPrograms {
    FZRewardsLog(@"loading near programs");
    
#warning TODO wait for WS
    
    FZRewardsLog(@"/!\\ unimplemented - loading near programs");
    
    /*
     [self showWaitingViewWithMessage:[LocalizationHelper stringForKey:@"app_please_wait" withComment:@"AllLoyaltyProgramsViewController"]];
     
     [FidelitizServices programsListNotAlreadySuscribe:[NSString stringWithFormat:@"%@",[[[UserSession currentSession] user] fidelitizId]] withSuccessBlock:^(id context) {
     [_allProgramsList removeAllObjects];
     [_allProgramsList addObjectsFromArray:context];
     
     [_tableViewAllPrograms reloadData];
     
     [self hideWaitingView];
     } failureBlock:^(Error *error) {
     
     [self hideWaitingView];
     [self displayAlertForError:error];
     }];
     
     */
    
#warning Error message hard coded
    Error *error = [Error errorWithMessage:@"Service unavalable : Near programs" code:1 andRequestCode:-1];
    [self displayAlertForError:error];
    
    [self activateNearProgramsButton];
}

- (void)showSuggestedPrograms {
    FZRewardsLog(@"loading sugested programs");
    
#warning TODO wait for WS
    
    FZRewardsLog(@"/!\\ unimplemented - loading suggested programs");
    
    /*
     [self showWaitingViewWithMessage:[LocalizationHelper stringForKey:@"app_please_wait" withComment:@"AllLoyaltyProgramsViewController"]];
     
     [FidelitizServices programsListNotAlreadySuscribe:[NSString stringWithFormat:@"%@",[[[UserSession currentSession] user] fidelitizId]] withSuccessBlock:^(id context) {
     [_allProgramsList removeAllObjects];
     [_allProgramsList addObjectsFromArray:context];
     
     [_tableViewAllPrograms reloadData];
     
     [self hideWaitingView];
     } failureBlock:^(Error *error) {
     
     [self hideWaitingView];
     [self displayAlertForError:error];
     }];
     */
    
#warning Error message hard coded
    Error *error = [Error errorWithMessage:@"Service unavalable : Suggested programs"  code:1 andRequestCode:-1];
    [self displayAlertForError:error];
    
    [self activateSuggestedProgramsButton];
}

- (void)showSearchTextField {
    FZRewardsLog(@"switch to opened nav bar");
    [self switchToNavBarOpened];
    
    [self loadAllPrograms];
}

- (void)loadAllPrograms {
    FZRewardsLog(@"loading all programs");
    [self showWaitingViewWithMessage:[LocalizationHelper stringForKey:@"app_please_wait" withComment:@"AllLoyaltyProgramsViewController" inDefaultBundle:FZBundleBlackBox]];
    
    if([[FZTargetManager sharedInstance] mainTarget] != FZBankSDKTarget){
        
        [RewardsServices programsListNotAlreadySuscribe:[NSString stringWithFormat:@"%@",[[[UserSession currentSession] user] fidelitizId]] withSuccessBlock:^(id context) {
            [self programsListNotAlreadySuscribeWithSuccessBlock:context];
        } failureBlock:^(Error *error) {
            FZRewardsLog(@"error while loading all programs");
            
            [self hideWaitingView];
            [self displayAlertForError:error];
            
            _needRefreshAfterError = YES;
        }];
    } else {
        
        [RewardsServices programsListNotAlreadySuscribeWithUserkey:[[UserSession currentSession] userKey] withSuccessBlock:^(id context) {
            [self programsListNotAlreadySuscribeWithSuccessBlock:context];
        } failureBlock:^(Error *error) {
            FZRewardsLog(@"error while loading all programs");
            [self hideWaitingView];
            [self displayAlertForError:error];
            
            _needRefreshAfterError = YES;
        }];
    }
}

- (void)programsListNotAlreadySuscribeWithSuccessBlock:(id) context {
    
    _needRefreshAfterError = NO;
    
    [_allProgramsList removeAllObjects];
    [_allProgramsList addObjectsFromArray:context];
    
    [_tableViewAllPrograms reloadData];
    
    [_allProgramsSavedList addObjectsFromArray:_allProgramsList];
    
    FZRewardsLog(@"nb of prog saved : %lu",(unsigned long)[_allProgramsSavedList count]);
    
    [self hideWaitingView];
}


//all programs navigation bar opened
- (void)showNearProgramsOpened {
    FZRewardsLog(@"switch to nav bar");
    [self switchToNavBar];
    [self showNearPrograms];
}

- (void)showSuggestedProgramsOpened {
    FZRewardsLog(@"switch to nav bar");
    [self switchToNavBar];
    [self showSuggestedPrograms];
}

- (void)searchInAllPrograms:(id)sender {
    
    NSString *research = [[(UITextField*)sender text] lowercaseString];
    
    if([research length] > 2){
        
        FZRewardsLog(@"searching with string : %@",research);
        
        NSMutableArray *resultProgramsList = [[NSMutableArray alloc] init];
        
        for(LoyaltyProgram* program in _allProgramsSavedList){
            
            FZRewardsLog(@"name : %@ - label : %@",[program loyaltyProgramOwnerCompanyName],[program label]);
            
            if([[[program loyaltyProgramOwnerCompanyName] lowercaseString] rangeOfString:research].location != NSNotFound && [[program loyaltyProgramOwnerCompanyName] rangeOfString:@"null"].location == NSNotFound) {
                
                FZRewardsLog(@"match !");
                
                [resultProgramsList addObject:program];
            } else if([[[program label] lowercaseString] rangeOfString:research].location != NSNotFound && [[program label] rangeOfString:@"null"].location == NSNotFound) {
                FZRewardsLog(@"match !");
                
                [resultProgramsList addObject:program];
            }
        }
        
        [_allProgramsList removeAllObjects];
        [_allProgramsList addObjectsFromArray:resultProgramsList];
        
        [_tableViewAllPrograms reloadData];
        
        [resultProgramsList release];
        
    } else if ([research length] == 0) {
        [_allProgramsList removeAllObjects];
        [_allProgramsList addObjectsFromArray:_allProgramsSavedList];
        [_tableViewAllPrograms reloadData];
    }
    
}

- (void)showYourProgramsWithAddedProgram:(LoyaltyProgram *)loyaltyProgram {
    if([delegate respondsToSelector:@selector(setSgmCtrlProgramsToYourProgramsAndShowYourPrograms)]){
        [delegate setSgmCtrlProgramsToYourProgramsAndShowYourPrograms];
    }
    
    [[self allProgramsList] removeObject:loyaltyProgram];
    [[self tableViewAllPrograms] reloadData];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_allProgramsList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProgramTableViewCell *cell = [ProgramTableViewCell dequeueReusableCellWithtableView:tableView];
    
    if (cell == nil) {
        cell = [ProgramTableViewCell loadCellWithOwner:self inDefault:FZBundleRewards];
        [cell setUpTableCellViewForAllPrograms];
    }
    
    LoyaltyProgram *program = [_allProgramsList objectAtIndex:indexPath.row];
    
    [cell setProgramName:[program label]];
    [cell setMerchantName:[program loyaltyProgramOwnerCompanyName]];
    
    [cell setLogo:[FZUIImageWithFZBinaryArray imageFromBinaryArray:[program logo] withDefautImage:[FZUIImageWithImage imageNamed:@"logo_default" inBundle:FZBundleAPI]]];
    
    if(indexPath.row %2 == 0 ){
        [cell isOdd];
    } else {
        [cell isEven];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!_isLoading){
        _isLoading = YES;
    }else{
        //Double click handle
        return;
    }
    LoyaltyProgramDetailsViewController* controller = [[self multiTargetManager] loyaltyProgramDetailsViewControllerWithProgram:_allProgramsList[indexPath.row]];
    
    [controller setFromAllPrograms:YES];
    [controller setDelegate:self];
    
    [[[FZTargetManager sharedInstance]facade]presentFromController:[[[FZTargetManager sharedInstance]facade]tabBarControllerNavigation] inAppWith:controller andMode:CustomNavigationModeBack animated:YES];
    
}

#pragma mark - MM

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_allProgramsNavBar release], _allProgramsNavBar = nil;
    [_allProgramsNavBarOpened release], _allProgramsNavBarOpened = nil;
    [_tableViewAllPrograms release], _tableViewAllPrograms = nil;
    [_viewAllProgramsNavBar release], _viewAllProgramsNavBar = nil;
    [_allProgramsList release], _allProgramsList = nil;
    [_allProgramsSavedList release], _allProgramsSavedList = nil;
    [super dealloc];
}

@end
