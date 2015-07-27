//
//  HHZViewController.h
//  UICollectionVC
//
//  Created by 黄含章 on 15/7/24.
//  Copyright (c) 2015年 HHZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHZCollectionViewCell.h"
#import "HHZScrollView.h"

@interface HHZViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView *collectionView;

@end
