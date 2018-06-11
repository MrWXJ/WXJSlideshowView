//
//  ViewController.m
//  WXJSlideshowView
//
//  Created by MrWXJ on 2018/6/11.
//  Copyright © 2018年 MrWXJ. All rights reserved.
//

#import "ViewController.h"
#import "WXJSlideshowView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *arr = @[@"2.jpg",@"2.jpg",@"2.jpg"];
    [[[WXJSlideshowView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) dataSource:arr didSelectIndexPath:^(NSIndexPath *indexPath) {
        NSLog(@"indexPath=%ld",indexPath.row);
    }] showInView:self.view];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
