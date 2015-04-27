//
//  HistoryTransaksiTableViewController.m
//  Dompetku
//
//  Created by Indosat on 12/22/14.
//
//

#import "HistoryTransaksiTableViewController.h"
#import "transactionMapping.h"
#import "HistoryTableViewCell.h"
@interface HistoryTransaksiTableViewController ()

@end

@implementation HistoryTransaksiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView  = [[UIView alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTabel)
                                                 name:@"successFetch"
                                               object:nil];
   
    self.title  =@"History Transaksi";
    [self reloadTabel];
}

-(void)reloadTabel{
    NSLog(@"reload table");
    [self.tableView reloadData];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    if(_isMore)
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar-logo"] forBarMetrics:UIBarMetricsDefault];
    else
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
        
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [transactionMapping sharedDataManager].historyTransaction.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if(indexPath.row%2==0){
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
        cell.backgroundColor =[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    }
    else{
        
        cell.contentView.backgroundColor  =[UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1];
        cell.backgroundColor =[UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1];
    }
    cell.userProfile =[[transactionMapping sharedDataManager].historyTransaction objectAtIndex:indexPath.row];
    // Configure the cell...
    
    return cell;
}


@end
