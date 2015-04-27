//
//  FavoritTableViewController.m
//  Dompetku
//
//  Created by Indosat on 12/6/14.
//
//

#import "FavoritTableViewController.h"
#import "transactionFavorite.h"
#import "FavoriteTableViewCell.h"
#import "BayarSharedDetailViewController.h"
#import "BeliSharedDetailViewController.h"
#import <SWRevealViewController.h>
@interface FavoritTableViewController ()<SWRevealViewControllerDelegate>
@property (nonatomic,strong)NSMutableArray *userFavorite;
@end

@implementation FavoritTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefaultNavigationBar];
    self.tableView.tableFooterView  = [[UIView alloc]init];
    _userFavorite = [[NSMutableArray alloc]initWithArray:[transactionFavorite getItems]];
    [self.tableView reloadData];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    self.tableView.backgroundColor =[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];

    self.title = @"Favorite";
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.revealViewController.delegate = self;
    //    netraUserModel *modelUser = [netraUserModel getUserProfile];
    
}
- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        self.view.userInteractionEnabled = YES;
    } else {
        self.view.userInteractionEnabled = NO;
    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        self.view.userInteractionEnabled = YES;
    } else {
        self.view.userInteractionEnabled = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _userFavorite.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if(indexPath.row%2==0){
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
        cell.backgroundColor =[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    }
    else{
        
        cell.contentView.backgroundColor  =[UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1];
        cell.backgroundColor =[UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1];
    }
    
    cell.fav = [_userFavorite objectAtIndex:indexPath.row];
    // Configure the cell...
    
    return cell;
}
// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        transactionFavorite *t = [_userFavorite objectAtIndex:indexPath.row];
        t.isDeleted = 1;
        t.updatedAt = [NSDate date];
        [transactionFavorite save:t withRevision:YES];
        [_userFavorite removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    transactionFavorite *t = [_userFavorite objectAtIndex:indexPath.row];
    transactionFavorite *ts = [transactionFavorite getFavoriteByGuid:t.guid];
    NSLog(@"ts-->%@",ts);
    if([ts.state isEqualToString:@"Bayar"]){
        BayarSharedDetailViewController *bayar  = [[BayarSharedDetailViewController alloc]init];
        bayar.subMerchantId = ts.merchantID;
        bayar.title = ts.merchant;
        bayar.tagPass =ts.tags;
        bayar.fielTextdPass  =ts.fieldInformation;
        
        [self.navigationController pushViewController:bayar animated:YES];
    }
    else{
        BeliSharedDetailViewController *bayar  = [[BeliSharedDetailViewController alloc]init];
        bayar.subMerchantId = ts.merchantID;
        bayar.title = ts.merchant;
        bayar.tagPass =ts.tags;
        bayar.fielTextdPass  =ts.fieldInformation;
        
        [self.navigationController pushViewController:bayar animated:YES];
    }
    
}
@end
