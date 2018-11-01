//
//  MLSectionControl.m
//  MLSectionPageView
//
//  Created by 戴明亮 on 2018/11/1.
//  Copyright © 2018年 ML Day. All rights reserved.
//

#import "MLSectionControl.h"
#import "MLSectionScrollView.h"




@interface MLSectionControl ()
@property (nonatomic, strong) MLSectionScrollView *scrollView;
@property (nonatomic, strong) NSArray <NSString *>*titles;
// 当前选中的索引
@property (nonatomic, assign) NSInteger selectionIndex;
// 选中section的宽度
@property (nonatomic, assign) CGFloat sectionWidth;

@property (nonatomic, strong)NSMutableArray *sectionItemWidthArray;

// 横条的高度
@property (nonatomic, assign) CGFloat sectionStripeHeight;


@end

@implementation MLSectionControl


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeDefaultValue];
    }
    return self;
}


- (instancetype)initWithSectionControlTitles:(NSArray <NSString *>*)titles{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.titles = titles;
         [self initializeDefaultValue];
    }
    return self;
}




- (void)layoutSubviews{
    [super layoutSubviews];
    [self updateSectionItemFrame];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


- (void)updateSectionItemFrame{
    self.scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    if (self.titles.count <= 0) return;
    NSInteger count = self.titles.count;

    self.sectionWidth =   self.frame.size.width / count;

    if (self.itemWidthStyle == MLSectionItemWidthStyleFix) {
        
        [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGSize size = [self calculatingTitleWidthForIndex:idx];
            CGFloat titleWidth = size.width + self.sectionEdgeInset.left + self.sectionEdgeInset.right;
            self.sectionWidth = MAX(self.sectionWidth, titleWidth);
        }];
        
    }else{
        
        NSMutableArray *itemWidthArray = [NSMutableArray array];
        [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGFloat titleWidth = [self calculatingTitleWidthForIndex:idx].width + self.sectionEdgeInset.left + self.sectionEdgeInset.right;
        
            [itemWidthArray addObject:[NSNumber numberWithFloat:titleWidth]];
            
        }];
        self.sectionItemWidthArray = itemWidthArray.copy;

    }

    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    CGFloat totalWidth = 0;
    if (self.itemWidthStyle == MLSectionItemWidthStyleFix) {
        totalWidth =  self.sectionWidth * self.titles.count;
    }else{
        for (NSNumber *width in self.sectionItemWidthArray) {
            totalWidth += [width floatValue];
        }
        
        
        // 当求出的宽度没有达到屏幕的总宽度
        if (totalWidth > 0 && totalWidth < self.frame.size.width) {
            CGFloat spaceWidth = self.frame.size.width - totalWidth;
            
        }
        
    }
    
    
    

//    self.scrollView.scrollEnabled
    
    self.scrollView.contentSize = CGSizeMake(totalWidth, self.frame.size.height);
    
    
}



// 计算文字size
- (CGSize)calculatingTitleWidthForIndex:(NSInteger)index{
    
    if (index > self.titles.count)return CGSizeZero;
    
   id title = self.titles[index];
    
    if ([title isKindOfClass:[NSString class]]) {

        if (self.selecSectionFixItemBlock) {
           
           NSAttributedString *str =  self.selecSectionFixItemBlock(self, title, index);
            return str.size;
            
        }else{
            BOOL selected = (self.selectionIndex == index);
            NSDictionary *attributs = selected ? [self noSelectedItemStyleAttributes]:[self selectedItemStyleAttributes];
            NSAttributedString *str =  [[NSAttributedString alloc] initWithString:title attributes:attributs];
            return str.size;
        }
       
        
    }else if ([title isKindOfClass:[NSAttributedString class]]){
        if (self.selecSectionFixItemBlock) {
            
            NSAttributedString *str =  self.selecSectionFixItemBlock(self, title, index);
            return str.size;
            
        }else{
            return [(NSAttributedString *)title size];
        }
        
        
    }else{
         return  CGSizeZero;
    }
    
    return  CGSizeZero;
    
}


#pragma mark - 选中和非选中状态下的文字样式
- (NSDictionary *)noSelectedItemStyleAttributes{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:NSFontAttributeName,[UIFont systemFontOfSize:14],NSForegroundColorAttributeName,[UIColor blackColor],nil];

    if (self.noSelectItemAttributes) {
        [attributes addEntriesFromDictionary:self.noSelectItemAttributes];
    }
    return attributes;
}

- (NSDictionary *)selectedItemStyleAttributes{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self noSelectedItemStyleAttributes]];
    
    if (self.selectItemAttributes) {
        [attributes addEntriesFromDictionary:self.selectItemAttributes];
    }
    return attributes;
}




- (void)initializeDefaultValue{
    
    self.scrollView = [[MLSectionScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.backgroundColor = [UIColor blueColor];
    [self addSubview:self.scrollView];

    
}


- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
}



#pragma mark 绘制子控件
- (void)drawRect:(CGRect)rect {
    
    self.backgroundColor = [UIColor orangeColor];
    
    // 填充一个背景色
    [self.backgroundColor setFill];
    UIRectFill(self.bounds);
    
    self.scrollView.layer.sublayers = nil;
    
    
    if (self.itemWidthStyle == MLSectionItemWidthStyleFix) {
        
  
        
        [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGSize titleSize = [self calculatingTitleWidthForIndex:idx];
            CGFloat titleHeight = titleSize.height;
            CGFloat titleWidth = titleSize.width;
            
            CGFloat titleX = self.sectionWidth * idx +  (self.sectionWidth - titleWidth) / 2;
            CGFloat titleY = (self.frame.size.height - self.sectionStripeHeight - titleHeight)/ 2;
            

            
            CATextLayer *textLayer = [[CATextLayer alloc] init];
            textLayer.alignmentMode = kCAAlignmentCenter;
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            textLayer.frame = CGRectMake(titleX, titleY, titleWidth, titleHeight);
            
            textLayer.string = [self convertAttributedString:idx];
            
            [self.scrollView.layer addSublayer:textLayer];
            
            
        }];
        
       
        
        
        
    }else{
        
        
        
        
    }
    

    
}


- (NSAttributedString *)convertAttributedString:(NSInteger)index{
    
    if (index > self.titles.count) {
        return nil;
    }
 
    id title = self.titles[index];
    if ([title isKindOfClass:[NSString class]] && self.selecSectionFixItemBlock
         == nil) {
         BOOL selected = (self.selectionIndex == index);
        NSDictionary *attributes = selected?[self selectedItemStyleAttributes]:[self noSelectedItemStyleAttributes];
        NSAttributedString *attributString = [[NSAttributedString alloc] initWithString:title attributes:attributes];
        return attributString;
        
    }else if ([title isKindOfClass:[NSString class]] &&self.selecSectionFixItemBlock != nil){

        return self.selecSectionFixItemBlock(self, title, index);
        
        
    }else if ([title isKindOfClass:[NSAttributedString class]]){
        return (NSAttributedString *)title;
    }else{
        return nil;
    }
 
}




#pragma mark Setter
- (void)setTitles:(NSArray *)titles{
    if (titles == nil) return;
    _titles = titles;
    
    [self updateSectionItemFrame];
}


@end




