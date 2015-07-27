//
//  HHZCollectionViewCell.m
//  UICollectionVC
//
//  Created by 黄含章 on 15/7/24.
//  Copyright (c) 2015年 HHZ. All rights reserved.
//

#import "HHZCollectionViewCell.h"

@implementation HHZCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor magentaColor];
        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, CGRectGetWidth(self.frame) - 10, CGRectGetWidth(self.frame) - 10)];
        self.imageV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.imageV];
        
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.imageV.frame), CGRectGetWidth(self.frame) - 10, 20)];
        self.label.backgroundColor = [UIColor purpleColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
        
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = CGRectMake(5, CGRectGetMaxY(self.label.frame), CGRectGetWidth(self.frame) - 10,30);
        [self.btn setTitle:@"希尔瓦娜斯" forState:UIControlStateNormal];
        self.btn.backgroundColor = [UIColor blackColor];
        [self addSubview:self.btn];
        
    }
    return self;
}

@end
