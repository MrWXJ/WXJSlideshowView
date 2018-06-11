//
//  WXJSlideshowView.m
//  WXJ_All_Code
//
//  Created by WXJ on 2018/5/13.
//  Copyright © 2018年 WXJ. All rights reserved.
//

#import "WXJSlideshowView.h"

#define MaxSections 1000
static CGFloat ScrollInterval = 3.0f;
static NSString *WXJSlideshowCellId = @"WXJSlideshowCellId";

@interface WXJSlideshowView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) SlideDidSelectIndexPath didSelectIndexPath;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) UIPageControl *pageControl;

@end

@implementation WXJSlideshowView

/**
 初始化WXJSlideshowView

 @param frame 构建的尺寸
 @param dataSource 数据源
 @param didSelectIndexPath 点击事件
 @return WXJSlideshowView
 */
- (instancetype)initWithFrame:(CGRect)frame
                   dataSource:(NSArray *)dataSource
           didSelectIndexPath:(SlideDidSelectIndexPath)didSelectIndexPath {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = dataSource;
        self.didSelectIndexPath = didSelectIndexPath;
        [self buildUICollectionView];
    }
    return self;
}

/**
 构建UICollectionView
 */
- (void)buildUICollectionView {
    //1.生成UICollectionViewFlowLayout对象，设置为水平滚动
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    
    //2.初始化UICollectionView对象
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator= NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.bounces = NO;
    
    //3.注册cell
    [_collectionView registerClass:[WXJSlideshowCell class] forCellWithReuseIdentifier:WXJSlideshowCellId];
    
    //4.添加到view
    [self addSubview:_collectionView];
    
    //5.pageControl
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 30.0f, self.bounds.size.width, 30.0f)];
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.numberOfPages = self.dataSource.count;
    [self addSubview:_pageControl];
    
    //6.添加定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:ScrollInterval target:self selector:@selector(nextPage) userInfo:nil repeats:true];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

#pragma mark ------ UICollectionView Delegate ------

/**
 设置collectionView的分区个数

 @param collectionView collectionView
 @return return value
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return MaxSections;
}

/**
 collectionViewCell个数

 @param collectionView collectionView
 @param section section
 @return cell个数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource count];
}

/**
 UICollectionViewCell

 @param collectionView collectionView
 @param indexPath indexPath
 @return UICollectionViewCell
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WXJSlideshowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WXJSlideshowCellId forIndexPath:indexPath];
    if (!cell) {
        cell = [[WXJSlideshowCell alloc] init];
    }
    cell.imgUrl = self.dataSource[indexPath.row];
    
    return cell;
}

/**
 UICollectionViewCellDidSelect

 @param collectionView collectionView
 @param indexPath indexPath
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectIndexPath) {
        self.didSelectIndexPath(indexPath);
    }
}

#pragma mark ------ 定时器相关操作 ------

/**
 添加定时器
 */
- (void)addTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:NULL repeats:YES];
}

/**
 定时器的相关设置
 */
- (void)nextPage {
    // 获取当前的 indexPath
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    NSIndexPath *currentIndexPathSet = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:MaxSections * 0.5];
    
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathSet atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    // 设置下一个滚动的item的indexPath
    NSInteger nextItem = currentIndexPathSet.item + 1;
    NSInteger nextSection = currentIndexPathSet.section;
    if (nextItem == self.dataSource.count) {
        // 当item等于轮播图的总个数的时候
        // item等于0, 分区加1
        // 未达到的时候永远在500分区中
        nextItem = 0;
        nextSection ++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

/**
 删除定时器
 */
- (void)removeTimer {
    [_timer invalidate];
    _timer = nil;
}

#pragma mark ------ 用户操作相关 ------

/**
 当用户滑动的时候，停止轮播

 @param scrollView scrollView
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

/**
 当用户停止滑动的时候，继续轮播

 @param scrollView scrollView
 @param decelerate decelerate
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self addTimer];
}

/**
 设置页码

 @param scrollView scrollView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 滚动时 动态设置 pageControl.currentPage
    int page = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5) % self.dataSource.count;
    self.pageControl.currentPage = page;
}

#pragma mark ------ 扩展方法 ------

/**
 显示WXJSlideshowView
 
 @param view 要显示在的view
 */
- (void)showInView:(UIView *)view {
    [view addSubview:self];
}

@end
