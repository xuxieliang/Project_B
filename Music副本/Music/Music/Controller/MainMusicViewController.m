//
//  MainMusicViewController.m
//  Music
//
//  Created by zhupeng on 15/10/28.
//  Copyright (c) 2015年 朱鹏. All rights reserved.
//

#import "MainMusicViewController.h"
#import "HeaderCell.h"
#import "UIScrollView+MJRefresh.h"
#import "NetHandler.h"
#import "NewsTopCell.h"
#import "MusicImageList.h"
#import "MusicTitleList.h"
#import "ProgramSelection.h"
#import "CategoryMusic.h"
#import "MusicListCell.h"

@interface MainMusicViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UICollectionView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *scrollImageUrlArray;
@property (nonatomic, strong) NSMutableArray *listTitleArray;
@property (nonatomic, strong) NSMutableArray *listDetailArray;

@end

@implementation MainMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self handle];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width / 5, 30);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.headerView = [[UICollectionView alloc]initWithFrame:(CGRectMake(0, 0, self.view.bounds.size.width, 30)) collectionViewLayout:flowLayout];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.headerView.delegate = self;
    self.headerView.dataSource = self;
    [self.headerView registerClass:[HeaderCell class] forCellWithReuseIdentifier:@"headerCell"];
    [self.backgroundView addSubview:self.headerView];
    
    self.tableView = [[UITableView alloc]initWithFrame:(CGRectMake(0, self.headerView.bounds.size.height, self.view.bounds.size.width, self.backgroundView.bounds.size.height - self.headerView.bounds.size.height)) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.backgroundView addSubview:self.tableView];
    
    // Do any additional setup after loading the view.
}

- (void)setupRefresh
{
    //    NSLog(@"进入了setupRefresh");
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //进入刷新状态(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    
}



#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    
    //1. 在这调用请求网络数据方法（刷新数据）
    
    [self handle];
    //2. 2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
}

- (void)handle {
    [NetHandler getDataWithUrl:@"http://mobile.ximalaya.com/mobile/discovery/v2/category/recommends?categoryId=2&contentType=album&device=iPhone&scale=2&version=4.3.20" completion:^(NSData *data) {
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSDictionary *tagsDic = [rootDic objectForKey:@"tags"];
        NSArray *tagsArray = [tagsDic objectForKey:@"list"];
        self.listTitleArray = [NSMutableArray array];
        for (NSDictionary *dic in tagsArray) {
            MusicTitleList *titleList = [[MusicTitleList alloc]init];
            [titleList setValuesForKeysWithDictionary:dic];
            [self.listTitleArray addObject:titleList.tname];
        }
        
        self.scrollImageUrlArray = [NSMutableArray array];
        NSDictionary *focusDictionary = [rootDic objectForKey:@"focusImages"];
        NSArray *focusArray = [focusDictionary objectForKey:@"list"];
        for (NSDictionary *dic in focusArray) {
            MusicImageList *imageList = [[MusicImageList alloc]init];
            [imageList setValuesForKeysWithDictionary:dic];
            [self.scrollImageUrlArray addObject:imageList.pic];
        }
        
        NSDictionary *categoryDic = [rootDic objectForKey:@"categoryContents"];
        NSArray *categoryArray = [categoryDic objectForKey:@"list"];
        self.listDetailArray = [NSMutableArray array];
        for (NSDictionary *dic in categoryArray) {
            CategoryMusic *categoryMusic = [[CategoryMusic alloc]init];
            [categoryMusic setValuesForKeysWithDictionary:dic];
            [self.listDetailArray addObject:categoryMusic];
        }
        
        [self.tableView reloadData];
        [self.headerView reloadData];
        [self.tableView headerEndRefreshing];
    }];
}


#pragma mark-- collectionView数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listTitleArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headerCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.listTitleArray[indexPath.item];
    return cell;
}

#pragma mark-- tableView数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return 3;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listDetailArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }else {
        return ((CategoryMusic *)self.listDetailArray[section]).title;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"cell1";
    static NSString *reuseIdentifier2 = @"cell2";
    
    if (indexPath.section == 0) {
        NewsTopCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[NewsTopCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:reuseIdentifier];
        }
        cell.headerlineArray = self.scrollImageUrlArray;
        
        return cell;
    }else {
        
        MusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier2];
        if (cell == nil) {
            cell = [[MusicListCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:reuseIdentifier2];
        }
        cell.programSelection = ((CategoryMusic *)self.listDetailArray[indexPath.section]).list[indexPath.row];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 180;
    }else {
        return 100;
    }
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

@end
