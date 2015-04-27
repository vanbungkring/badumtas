//
//  searchStasiunTableViewController.m
//  Dompetku
//
//  Created by Indosat on 12/1/14.
//
//

#import "searchStasiunTableViewController.h"

@interface searchStasiunTableViewController ()<UISearchBarDelegate>{
    UIView *disableViewOverlay;
}
@property (nonatomic,strong)NSArray *stasiun;
@property (nonatomic,strong)NSMutableArray *stasiun_copy;
@property (nonatomic,strong)NSArray *searchResult;

@end
BOOL is_search =0;
@implementation searchStasiunTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   }
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    is_search =0;
    self.view.backgroundColor = [UIColor whiteColor];
    disableViewOverlay.backgroundColor = [UIColor blackColor];
    _stasiun = [@"Batuceper,Bekasi,Bogor,Bojong Indah,Bojonggede,Buaran,Cakung,Cawang,Cicayur,Cikini,Cikoya,Cilebut,Cilejit,Cisauk,Citayam,Daru,Depok,Depok Baru,Duren Kalibata,Duri,Gang Sentiong,Gondangdia,Jakarta Kota,Jatinegara,Jayakarta,Juanda,Jurangmangu,Kalideres,Kampung Bandan,Karet,Kebayoran,Kemayoran,Klender,Klender Baru,Kramat,Kranji,Lenteng Agung,Maja,Mangga Besar,Manggarai,Palmerah,Parung Panjang,Pasar Minggu,Pasar Minggu Baru,Pasar Senen,Pesing,Pondok Cina,Pondok Jati,Pondok Ranji,Poris,Rajawali,Rawa Buaya,Rawa Buntu,Sawah Besar,Serpong,Sudimara,Sudirman,Tanah Abang,Tangerang,Tanjung Barat,Tebet,Tenjo,Tigaraksa,Universitas Indonesia,Universitas Pancasila" componentsSeparatedByString:@","];
    
    _stasiun_copy = [[NSMutableArray alloc]init];
    [_stasiun_copy addObjectsFromArray:_stasiun];
    
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    is_search=0;
    [self.tableView reloadData];
}
- (void)hideKeyboardWithSearchBar:(UISearchBar *)searchBars
{
    [searchBars resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if ([searchText length]!=0) {
        is_search =1;
        _searchResult = nil;
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self CONTAINS[cd]%@",searchText];
        _searchResult = [_stasiun_copy filteredArrayUsingPredicate:resultPredicate];
        NSLog(@"search-->%@",_searchResult);
        [self.tableView reloadData];
    }
    else{
        is_search =0;
        [self.tableView reloadData];
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (!is_search) {
        return _stasiun_copy.count;
    }
    else{
        return _searchResult.count;
        
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    if (cell==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    if (is_search) {
        cell.textLabel.text = [_searchResult objectAtIndex:indexPath.row];
    }
    else{
        cell.textLabel.text = [_stasiun_copy objectAtIndex:indexPath.row];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *stasiunName;
    if(is_search)
        stasiunName = [_searchResult objectAtIndex:indexPath.row];
    else
        stasiunName = [_stasiun_copy objectAtIndex:indexPath.row];
    NSDictionary *data = @{@"key":_tagss,@"value":stasiunName};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"postBack" object:self userInfo:data];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

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
