//
//  ViewController.m
//  MLSectionPageView
//
//  Created by 戴明亮 on 2018/11/1.
//  Copyright © 2018年 ML Day. All rights reserved.
//

#import "ViewController.h"
#import "MLSectionPage/MLSectionPageView.h"
//#import <ob>


@interface ViewController ()
@property (nonatomic, strong) MLSectionPageView *sectionPageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    NSArray *titles = @[@"猜你喜欢",@"娱乐",@"八卦",@"休息时间",@"新闻",@"段子",@"猜你",@"精彩",@"视频",@"电影",@"资讯",@"体育",@"科技",@"文学",@"体育",@"科技",@"文学",@"体育",@"科技",@"文学",@"体育",@"科技",@"文学",@"体育",@"科技",@"文学"];

    self.sectionPageView = [[MLSectionPageView alloc] initWithWithActiveTitles:titles WithInactiveTitles:titles];
    self.sectionPageView.frame = CGRectMake(0, StatusBarHeight + 44, ScreeWidth, ScreeHeight - (StatusBarHeight + 44));

    self.sectionPageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.sectionPageView];
    
    
}


@end
