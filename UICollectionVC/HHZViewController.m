//
//  HHZViewController.m
//  UICollectionVC
//
//  Created by 黄含章 on 15/7/24.
//  Copyright (c) 2015年 HHZ. All rights reserved.
//

#import "HHZViewController.h"

//顶部scrollHeadView 的高度,先给写死
static const CGFloat ScrollHeadViewHeight = 200;
//app的高度
#define WNXAppWidth ([UIScreen mainScreen].bounds.size.width)
//app的宽度
#define WNXAppHeight ([UIScreen mainScreen].bounds.size.height)

@interface HHZViewController()

/** 记录scrollView上次偏移的Y距离 */
@property (nonatomic, assign) CGFloat                    scrollY;
/** 记录scrollView上次偏移X的距离 */
@property (nonatomic, assign) CGFloat                    scrollX;
/** 最底部的scrollView，用来掌控所有控件的滚动 */
@property (nonatomic, strong) UIScrollView               *backgroundScrollView;
/** 用来装顶部的scrollView用的View */
@property (nonatomic, strong) UIView                     *topView;
/** 记录当前展示的tableView 计算顶部topView滑动的距离 */
@property (nonatomic, weak  ) UITableView                *showingTableView;
/** 导航条的背景view */
@property (nonatomic, strong) UIView                     *naviView;
/** 返回按钮 */
@property (nonatomic, strong) UIButton                   *backBtn;
/** 分享按钮 */
@property (nonatomic, strong) UIButton                   *sharedBtn;
/** 导航条的title */
@property (nonatomic, strong) UILabel                    *titleLabel;
/** 导航条下边的副标题 */
@property (nonatomic, strong) UILabel                    *subTitleLabel;
/** 副标题旁边的小图片 */
@property (nonatomic, strong) UIImageView                *smallImageView;

@property(nonatomic,strong)HHZScrollView *topScrollView;

@end

@implementation HHZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAndLayoutUI];
    
    [self setUpNavigtionBar];
}

-(void)initAndLayoutUI {
    //隐藏系统的导航条，由于需要自定义的动画，自定义一个view来代替导航条
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //将view的自动添加scroll的内容偏移关闭
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置背景色
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化最底部的scrollView,装tableView用
    self.backgroundScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.backgroundScrollView];
    self.backgroundScrollView.backgroundColor = [UIColor whiteColor];
    self.backgroundScrollView.pagingEnabled = YES;
    self.backgroundScrollView.bounces = NO;
    self.backgroundScrollView.showsHorizontalScrollIndicator = NO;
    self.backgroundScrollView.delegate = self;
    self.backgroundScrollView.contentSize = CGSizeMake(WNXAppWidth * 2, 0);
    
    //添加CollectionView
    float AD_height = 0.f;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, AD_height + 10.f);;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(ScrollHeadViewHeight, 0, 0, 0);
    //这侧Cell和ReusableVeiw
    [self.collectionView registerClass:[HHZCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    //添加顶部的图片scrollView
    NSArray *arr = @[[UIImage imageNamed:@"2"],[UIImage imageNamed:@"4"],[UIImage imageNamed:@"5"]];
    self.topScrollView = [HHZScrollView scrollHeadViewWithImages:arr];
    [self.topScrollView setFrame:CGRectMake(0, 0, WNXAppWidth, ScrollHeadViewHeight)];
    
    //添加顶部view用做topScrollView的父控件，因为在topScrollView内部youpageView应该在同一父控件中，方便后面做拉伸动画
    self.topView = [[UIView alloc] initWithFrame:self.topScrollView.bounds];
    self.topView.backgroundColor = [UIColor clearColor];
    [self.topView addSubview:self.topScrollView];
    [self.view addSubview:self.topView];
    

}

//初始化导航条上的内容
- (void)setUpNavigtionBar {
    //初始化山寨导航条
    self.naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WNXAppWidth, 64)];
    self.naviView.backgroundColor = [UIColor purpleColor];
    self.naviView.alpha = 0.0;
    [self.view addSubview:self.naviView];
    
//    //添加返回按钮
//    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.backBtn.frame = CGRectMake(5, 30, 25, 25);
//    [self.backBtn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [self.view addSubview:self.backBtn];
//    
//    //分享按钮
//    self.sharedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.sharedBtn.frame = CGRectMake(WNXAppWidth - 36, 34, 26, 17);
//    [self.sharedBtn setImage:[UIImage imageNamed:@"queen"] forState:UIControlStateNormal];
//    [self.sharedBtn addTarget:self action:@selector(sharedBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.sharedBtn];
    
    //添加导航条上的大文字
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setFrame:CGRectMake(30, 32, WNXAppWidth - 35 - 50, 25)];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont systemFontOfSize:19];
    self.titleLabel.text = @"我可没时间陪你玩游戏";
    self.titleLabel.textColor = [UIColor magentaColor];
    [self.view addSubview:self.titleLabel];
    
    //添加导航条下面的小图片
    self.smallImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"queen"]];
    self.smallImageView.frame = CGRectMake(30, 60, 14, 18);
    [self.view addSubview:self.smallImageView];
    
    //添加副标题
    self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 60, WNXAppWidth - 180, 20)];
    self.subTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.subTitleLabel.textColor = [UIColor magentaColor];
    self.subTitleLabel.font = [UIFont systemFontOfSize:16];
    self.subTitleLabel.text = @"希尔瓦娜斯&Queen";
    [self.view addSubview:self.subTitleLabel];
}

#pragma mark - 隐藏系统的导航条
- (void)viewDidAppear:(BOOL)animated
{
    //防止拖动一下就出现导航条的情况
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    //防止拖动一下就出现导航条的情况
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - UICollectionViewDataSource
//定义战士UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}

//战士的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"cell";
    HHZCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    cell.imageV.image = [UIImage imageNamed:@"queen.png"];
    cell.label.text = [NSString stringWithFormat:@"Queen%ld",indexPath.row];
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
//    [headerView addSubview:_headerView];
    return headerView;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-20)/2, ([UIScreen mainScreen].bounds.size.width-20)/2+50);
}

//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 5, 5);
}

//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//        UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        cell.backgroundColor = [UIColor redColor];
    NSLog(@"选择了女王%ld",indexPath.row);
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//实现功能的繁琐计算
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        self.showingTableView = (UITableView *)scrollView;
        
        //记录出上一次滑动的距离，因为是在tableView的contentInset中偏移的ScrollHeadViewHeight，所以都得加回来
        CGFloat offsetY = scrollView.contentOffset.y;
        CGFloat seleOffsetY = offsetY - self.scrollY;
        self.scrollY = offsetY;
        
        //修改顶部的scrollHeadView位置 并且通知scrollHeadView内的控件也修改位置
        CGRect headRect = self.topView.frame;
        headRect.origin.y -= seleOffsetY;
        self.topView.frame = headRect;
        
        //根据偏移量计算出alpha的值，渐隐，当偏移量大于-180时候计算消失的值
        CGFloat startF = -180;
        //出事的便宜Y值为顶部控件的高度
        CGFloat initY = ScrollHeadViewHeight;
        //缺少的那一段渐变Y值
        CGFloat lackY = initY + startF;
        //自定义导航条高度
        CGFloat naviH = 64;
        
        //渐隐alpha值
        CGFloat alphaScaleHide = 1 - (offsetY + initY- lackY) / (initY- naviH  - lackY);
        //渐现alph值
        CGFloat alphaScaleShow = (offsetY + initY - lackY) /  (initY - naviH  - lackY) ;
        if (alphaScaleShow >= 0.98) {
            //显示导航条
            [UIView animateWithDuration:0.04 animations:^{
                self.naviView.alpha = 1;
            }];
        } else {
            self.naviView.alpha = 0;
        }
        self.topScrollView.naviView.alpha = alphaScaleShow;
        self.subTitleLabel.alpha = alphaScaleHide;
        self.smallImageView.alpha = alphaScaleHide;
        
        CGFloat scaleTopView = 1 - (offsetY + ScrollHeadViewHeight) / 100;
        scaleTopView = scaleTopView > 1 ? scaleTopView : 1;
        
        //算出头部的变形
        CGAffineTransform transform = CGAffineTransformMakeScale(scaleTopView, scaleTopView );
        CGFloat ty = (scaleTopView - 1) * ScrollHeadViewHeight;
        self.topView.transform = CGAffineTransformTranslate(transform, 0, -ty * 0.26);
    }
}

@end
