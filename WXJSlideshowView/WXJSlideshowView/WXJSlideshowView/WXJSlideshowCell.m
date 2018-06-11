//
//  WXJSlideshowCell.m
//  WXJ_All_Code
//
//  Created by WXJ on 2018/5/13.
//  Copyright © 2018年 WXJ. All rights reserved.
//

#import "WXJSlideshowCell.h"

@interface WXJSlideshowCell ()

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation WXJSlideshowCell

/**
 初始化WXJSlideshowCell

 @param frame frame
 @return WXJSlideshowCell
 */
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

/**
 构建UI
 */
- (void)buildUI {
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_imageView];
}

/**
 加载图片

 @param imgUrl 图片地址
 */
- (void)setImgUrl:(NSString *)imgUrl {
    if ([imgUrl hasPrefix:@"http://"]||[imgUrl hasPrefix:@"https://"]) {
        NSURL *url = [NSURL URLWithString:imgUrl];
        [_imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    } else {
        _imageView.image = [UIImage imageNamed:imgUrl];
    }
}


@end
