//
//  ViewController.m
//  MLSectionPageView
//
//  Created by 戴明亮 on 2018/11/1.
//  Copyright © 2018年 ML Day. All rights reserved.
//

#import "ViewController.h"
#import "MLSectionPage/MLSectionPageView.h"



@interface ViewController ()
@property (nonatomic, strong) MLSectionPageView *sectionPageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSArray *titles = @[@"one",@"Two",@"Three",@"Four",@"Five",@"Six"];

    self.sectionPageView = [[MLSectionPageView alloc] init];
    self.sectionPageView.frame = CGRectMake(0, StatusBarHeight + 44, ScreeWidth, ScreeHeight - (StatusBarHeight + 44));
    
    self.sectionPageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.sectionPageView];
    
    
}


@end
