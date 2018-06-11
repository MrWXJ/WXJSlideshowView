//
//  WXJSlideshowView.h
//  WXJ_All_Code
//
//  Created by WXJ on 2018/5/13.
//  Copyright © 2018年 WXJ. All rights reserved.
//

/**
 封装的无限轮播控件
 */

/**
 使用说明:(1)设置Frame;(2)设置数据源;(3)根据需要设置跳转操作;(4)显示View
 [[[WXJSlideshowView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 200) dataSource:arr didSelectIndexPath:^(NSIndexPath *indexPath) {
 NSLog(@"indexPath=%ld",indexPath.row);
 }] showInView:self.view];
 */

#import <UIKit/UIKit.h>
#import "WXJSlideshowCell.h"

/**
 DidSelectIndexPath

 @param indexPath indexPath
 */
typedef void(^SlideDidSelectIndexPath)(NSIndexPath *indexPath);

@interface WXJSlideshowView : UIView

/**
 初始化WXJSlideshowView
 
 @param frame 构建的尺寸
 @param dataSource 数据源
 @param didSelectIndexPath 点击事件
 @return WXJSlideshowView
 */
- (instancetype)initWithFrame:(CGRect)frame
                   dataSource:(NSArray *)dataSource
           didSelectIndexPath:(SlideDidSelectIndexPath)didSelectIndexPath;

/**
 显示WXJSlideshowView
 
 @param view 要显示在的view
 */
- (void)showInView:(UIView *)view;

@end
