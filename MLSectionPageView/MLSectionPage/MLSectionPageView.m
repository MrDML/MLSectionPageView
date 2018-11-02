//
//  MLSectionPageView.m
//  MLSectionPageView
//
//  Created by 戴明亮 on 2018/11/1.
//  Copyright © 2018年 ML Day. All rights reserved.
//

#import "MLSectionPageView.h"
#import "MLSectionControl/MLSectionControl.h"
#define SectionControl_Height 44
@interface MLSectionPageView ()
@property (nonatomic, strong) MLSectionControl *sectionControl;
@end

@implementation MLSectionPageView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithWithActiveTitles:(NSArray <NSString *>*)activeTitles WithInactiveTitles:(NSArray <NSString *>*)inactiveTitles{
    
   self = [self initWithFrame:CGRectZero];
    if (self) {
        self.activeTitles = activeTitles;
        self.inactiveTitles = inactiveTitles;
        [self initialize];
        
    }
    return self;
    
}




- (void)layoutSubviews{
    [super layoutSubviews];
   
}



- (void)initialize{
    
   
    
}


- (void)loadSectionControl{
    
 
    if (!self.sectionControl) {
        
        self.sectionControl = [[MLSectionControl alloc] initWithSectionControlTitles:self.activeTitles];
        self.sectionControl.frame = CGRectMake(0, 0, self.bounds.size.width - 20,SectionControl_Height);
        self.sectionControl.backgroundColor = [UIColor orangeColor];
        
        
        self.sectionControl.selectItemAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]};
        self.sectionControl.noSelectItemAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blackColor]};
        
//        self.sectionControl.selecSectionFixItemBlock = ^NSAttributedString *(MLSectionControl *sectionControl, NSString *title, NSInteger index, BOOL selected) {
//
//            NSAttributedString *str = nil;
//            if (selected) {
//                str = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]}];
//
//                if (index == 3) {
//                    str = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blueColor]}];
//                }
//
//            }else{
//                str = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blackColor]}];
//            }
//
//            return str;
//        };
      
        [self addSubview:self.sectionControl];
    }

}

- (void)loadSectionPageView{
    
}

- (void)loadSectionTagBox{
    
}


- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    // load sectionControl
    [self loadSectionControl];
    
    // load sectionPageView
    [self loadSectionPageView];
    
    // load sctionTagBox
    [self loadSectionTagBox];
    
}

#pragma mark - setter
- (void)setActiveTitles:(NSArray<NSString *> *)activeTitles{
    if (activeTitles == nil)return;
    _activeTitles = activeTitles;
    
}

- (void)setInactiveTitles:(NSArray<NSString *> *)inactiveTitles{
    if (inactiveTitles == nil) return;
    _inactiveTitles = inactiveTitles;
}


@end
