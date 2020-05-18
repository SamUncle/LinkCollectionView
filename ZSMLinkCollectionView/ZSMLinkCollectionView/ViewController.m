//
//  ViewController.m
//  ZSMLinkCollectionView
//
//  Created by zsm on 2020/5/18.
//  Copyright © 2020 zsm. All rights reserved.
//
#define ZSMScreenHeight [UIScreen mainScreen].bounds.size.height
#define ZSMScreenWidth [UIScreen mainScreen].bounds.size.width
#import "ViewController.h"
#import "ZsmTopCollectionCell.h"
#import "ZsmTypeCell.h"
@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) UICollectionView *topCV;
@property (weak, nonatomic) UICollectionView *bottomCV;
@property (nonatomic, strong) NSMutableArray *datas;

// 用来保存当前左边tableView选中的行数
@property (strong, nonatomic) NSIndexPath *currentSelectIndexPath;

@end

@implementation ViewController
#pragma mark - lazy
// Load Datas
- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
        for (NSInteger i = 1; i <= 10; i++) {
            [_datas addObject:[NSString stringWithFormat:@"第%zd分区", i]];
        }
    }
    return _datas;
}
#pragma mark - private
- (void)setBaseTableView {
    // top

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(ZSMScreenWidth / 3.0,  100);
    
    UICollectionView * topCV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 80, ZSMScreenWidth, 100) collectionViewLayout:layout];

    topCV.delegate = self;
    topCV.dataSource = self;
    [self.view addSubview:topCV];
    self.topCV = topCV;
   

    if (@available(iOS 11.0, *)) {
        topCV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
//            self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [topCV registerNib:[UINib nibWithNibName:NSStringFromClass([ZsmTypeCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ZsmTypeCell class])];
    
    // bottom
    UICollectionViewFlowLayout *b_layout = [[UICollectionViewFlowLayout alloc] init];

    b_layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    b_layout.itemSize = CGSizeMake(ZSMScreenWidth / 3.0,  100);
    UICollectionView *bottomCV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 230, ZSMScreenWidth, 100) collectionViewLayout:b_layout];
    [bottomCV registerNib:[UINib nibWithNibName:NSStringFromClass([ZsmTopCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ZsmTopCollectionCell class])];
    [self.view addSubview:bottomCV];
    self.bottomCV = bottomCV;
    
    // delegate && dataSource
    bottomCV.delegate = self;
    bottomCV.dataSource = self;
    
    // 默认选择上边collectionView的第一行
    [topCV selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:(UICollectionViewScrollPositionTop)];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseTableView];
}
#pragma mark - Collection View

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if (collectionView == self.topCV) return 1;
    return self.datas.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.topCV) return self.datas.count;
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.topCV){
        ZsmTypeCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZsmTypeCell class]) forIndexPath:indexPath];

        cell.lab.text = self.datas[indexPath.row];
        return cell;
    }
    else {
        ZsmTopCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZsmTopCollectionCell class]) forIndexPath:indexPath];

        cell.lab.text = [NSString stringWithFormat:@"%@ ----- 第%zd行", self.datas[indexPath.section], indexPath.row + 1];
    
        return cell;
    }
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 如果点击的是右边的tableView，不做任何处理
    if (collectionView == self.bottomCV) return;
    
    // 点击左边的tableView，设置选中右边的tableView某一行。左边的tableView的每一行对应右边tableView的每个分区
    [self.bottomCV selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.item] animated:YES scrollPosition:UICollectionViewScrollPositionTop];
    [self.bottomCV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.item] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
    self.currentSelectIndexPath = indexPath;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{ // 监听tableView滑动
    [self selectTopTableViewWithScrollView:scrollView];
}
- (void)selectTopTableViewWithScrollView:(UIScrollView *)scrollView {
    
    if (self.currentSelectIndexPath) {
        return;
    }
    // 如果现在滑动的是上边的collectionview，不做任何处理
    if ((UICollectionView *)scrollView == self.topCV)
    {
     return;
    }
    // 滚动右边tableView，设置选中左边的tableView某一行。indexPathsForVisibleRows属性返回屏幕上可见的cell的indexPath数组，利用这个属性就可以找到目前所在的分区
    [self.topCV selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.bottomCV.indexPathsForVisibleItems.firstObject.section inSection:0] animated:YES scrollPosition:(UICollectionViewScrollPositionCenteredHorizontally)];
    [self.topCV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.bottomCV.indexPathsForVisibleItems.firstObject.section inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    // 重新选中一下当前选中的行数，不然会有bug
    if (self.currentSelectIndexPath) self.currentSelectIndexPath = nil;
}

@end
