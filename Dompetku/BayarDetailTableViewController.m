//
//  BayarDetailTableViewController.m
//  Dompetku
//
//  Created by Indosat on 12/21/14.
//
//

#import "BayarDetailTableViewController.h"
#import "ModelBeli+Bayar.h"
#import "BeliSharedDetailViewController.h"
#import "BayarCell.h"
#import <UIImageView+AFNetworking.h>
#import "BayarSharedDetailViewController.h"
#import "ModelBeli+BayarManager.h"
#import "BayarDetailTableViewController.h"
@interface BayarDetailTableViewController ()
@property (nonatomic,strong)NSArray *data;
@end

@implementation BayarDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ModelBeli_BayarManager *m =_merchantSub;
    _data = m.jsonSub;
    [self.tableView reloadData];
    NSLog(@"data--->%@",_data);
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    // [ModelBeli_Bayar getByParentID:[NSString stringWithFormat:@"%d",_merchantId]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //ny additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(resetTab)
     name:@"resetTab"
     object:nil];
    
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)resetTab{
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BayarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if(indexPath.row%2==0){
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
        cell.backgroundColor =[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    }
    else{
        
        cell.contentView.backgroundColor  =[UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1];
        cell.backgroundColor =[UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1];
    }
    
    cell.label.text = [[_data objectAtIndex:indexPath.row]objectForKey:@"sub_merchant_nama"];
    cell.label.hidden = YES;
    if([[[_data objectAtIndex:indexPath.row]objectForKey:@"img_path"] isEqualToString:@""] ||[[[_data objectAtIndex:indexPath.row]objectForKey:@"sub_merchant_nama"] isEqual:[NSNull null]]){
        cell.label.hidden = NO;
    }
    
    [cell.avatar setImageWithURL:[NSURL URLWithString:[[_data objectAtIndex:indexPath.row]objectForKey:@"img_path"]] placeholderImage:[UIImage imageNamed:@"icon-57"]];
    // Configure the cell...
    cell.avatar.contentMode = UIViewContentModeScaleAspectFit;
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SubMerchant *s = [_data objectAtIndex:indexPath.row];
    BayarSharedDetailViewController *b = [[BayarSharedDetailViewController alloc]init];
    b.transactionNameParent = _merchantState;
    b.subMerchantId = [[_data objectAtIndex:indexPath.row]objectForKey:@"sub_merchant_id"];
    b.parentId = [NSString stringWithFormat:@"%d",_merchantId];
    b.title = [[_data objectAtIndex:indexPath.row]objectForKey:@"sub_merchant_nama"];
    [self.navigationController pushViewController:b animated:YES];
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
