//
//  DaftarMerchantCollectionViewController.m
//  Dompetku
//
//  Created by Indosat on 12/6/14.
//
//

#import "DaftarMerchantCollectionViewController.h"
#import "MerchantList.h"
#import <UIImageView+AFNetworking.h>
#import "CollectionViewCell.h"
#import <MBProgressHUD.h>
#import <SWRevealViewController.h>
@interface DaftarMerchantCollectionViewController ()
@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic)int curPage;
@property (nonatomic)int maxPage;
@property (nonatomic)int maxcontentPage;
#define ITEMS_PAGE_SIZE 10
#define LOADING_CELL_IDENTIFIER = @"data";

@end

@implementation DaftarMerchantCollectionViewController
static NSString * const reuseIdentifier = @"CollCell";
const int kLoadingCellTag = 1273;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"Daftar Merchant";
    _curPage = 1;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    _array = [[NSMutableArray alloc]init];
    // Register cell classes
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self fetchData:_curPage];
    SWRevealViewController *reveal = self.revealViewController;
    reveal.panGestureRecognizer.enabled = NO;
    // Do any additional setup after loading the view.
}
-(void)fetchData:(NSInteger )page{
    [MerchantList getAllMerchant:_curPage pag:^(NSArray *posts, NSError *error) {
        if(!error){
            _maxPage =[[[[NSArray arrayWithArray:posts]objectAtIndex:0]objectForKey:@"total_page"]integerValue];
            [_array addObjectsFromArray:[[[NSArray arrayWithArray:posts]objectAtIndex:0]objectForKey:@"detail"]];
            NSLog(@"array->%d",_array.count);
            [self.collectionView reloadData];
        }
        else{
            [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Terjadi Kesalahan Pada Server, Silahkan Coba Beberapa Saat Lagi"];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    _maxcontentPage = _maxPage *ITEMS_PAGE_SIZE;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark <UICollectionViewDataSource>


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    
    // return one plus current count to trigger the fetchingMoreItems
    if (_curPage == 1) {
        NSLog(@"data1");
        return 1;
    }
    
    else if (_curPage < _maxPage) {
        NSLog(@"data2");
        return _array.count+1;
    }
    else{
        NSLog(@"data3");
        return _array.count;
    }
}


- (UICollectionViewCell *)itemCellForIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSLog(@"nama-->%@",[[_array objectAtIndex:indexPath.row]objectForKey:@"list_merchant_nama"]);
    
    if([[[_array objectAtIndex:indexPath.row]objectForKey:@"list_merchant_img"] isEqualToString:@""]){
        cell.imageView.hidden = YES;
        cell.merchantLabel.hidden = NO;
        cell.merchantLabel.text = [[_array objectAtIndex:indexPath.row]objectForKey:@"list_merchant_nama"];
    }
    else{
        cell.imageView.hidden = NO;
        
        cell.merchantLabel.hidden = YES;
        [cell.imageView setImageWithURL:[NSURL URLWithString:[[_array objectAtIndex:indexPath.row]objectForKey:@"list_merchant_img"]] placeholderImage:[UIImage imageNamed:@"Icon-57"]];
    }
    return cell;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < _array.count) {
        NSLog(@"indexpath item->%d",indexPath.item);
        NSLog(@"data->%d",_array.count - ITEMS_PAGE_SIZE-1);
        if(_curPage<_maxPage){
            _curPage++;
            [self fetchData:_curPage];
        }
        return [self itemCellForIndexPath:indexPath];
    } else {
        return [self loadingCellForIndexPath:indexPath];
    }
}

- (UICollectionViewCell *)loadingCellForIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = (CollectionViewCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]
                                                  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = cell.center;
    //    [cell addSubview:activityIndicator];
    //
    //    [activityIndicator startAnimating];
    cell.tag  = kLoadingCellTag;
    return cell;
}

//-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"data-->%d",_curPage);
//    if (cell.tag == kLoadingCellTag) {
//
//        if(_curPage<_maxPage){
//            _curPage++;
//            [self fetchData:_curPage];
//        }
//
//    }
//}
#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSURL *url = [NSURL URLWithString:[[_array objectAtIndex:indexPath.row]objectForKey:@"list_merchant_url"]];
    [[UIApplication sharedApplication] openURL:url];
}
/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

@end
