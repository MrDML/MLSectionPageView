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



@property (nonatomic, strong) CALayer *sectionItemBoxLayer;
@property (nonatomic, strong) CALayer *sectionItemStripeLayer;



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

- (void)initializeDefaultValue{
    
    self.scrollView = [[MLSectionScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.scrollView.scrollsToTop = NO;
    [self addSubview:self.scrollView];
    
    self.sectionEdgeInset = UIEdgeInsetsMake(0, 10, 0,10);
    self.sectionStripeHeight = 0;
    self.userEnabled = YES;
    self.sectionItemBoxLayer = [CALayer layer];
    
    [self.sectionItemBoxLayer masksToBounds];
    self.sectionItemStripeLayer = [CALayer layer];
    
    self.sectionItemStripeLayerBgColor = [UIColor redColor];
    self.sectionItemBoxLayerBgColor = [UIColor redColor];
    
//     self.itemWidthStyle = MLSectionItemWidthStyleDynamic;
    self.sectionDecorateStyle = MLSectionDecorateStyleStripe;
    self.sectionDecorateStyle = MLSectionDecorateStyleBox;
    self.sectionStripeHeight = 5;
    self.stripeIndicatorWidthStyle = MLStripeIndicatorWidthEqualText;
//     self.shouldFullScreenRepeat = YES;
    
    self.backgroundColor = [UIColor orangeColor];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
}



- (void)layoutSubviews{
    [super layoutSubviews];
    [self updateSectionItemFrame];
    [self setNeedsDisplay];
    [self layoutIfNeeded];
   
}

#pragma mark 绘制子控件
- (void)drawRect:(CGRect)rect {
    // 填充一个背景色
    [self.backgroundColor setFill];
    UIRectFill(self.bounds);
    
    self.sectionItemStripeLayer.backgroundColor = self.sectionItemStripeLayerBgColor.CGColor;
    self.sectionItemBoxLayer.backgroundColor = self.sectionItemBoxLayerBgColor.CGColor;
    
    self.scrollView.layer.sublayers = nil;
    
  
  
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect textRect = CGRectZero;
        CGSize titleSize = [self calculatingTitleWidthForIndex:idx];
        CGFloat titleHeight = titleSize.height;
        CGFloat titleWidth = titleSize.width;
        
        BOOL notStyleNotBox = self.sectionDecorateStyle == MLSectionDecorateStyleStripe;
        
        
        CGFloat offsetTitleY = (self.frame.size.height -  (notStyleNotBox * self.sectionStripeHeight) - titleHeight)/ 2;
        
        
        
        CGFloat titleX =  self.sectionWidth * idx +  (self.sectionWidth - titleWidth) / 2;
        
        
        if (self.itemWidthStyle == MLSectionItemWidthStyleFix) {
  
        
            textRect = CGRectMake(titleX, offsetTitleY, titleWidth, titleHeight);
            
        }else{
            CGFloat offsetX = 0;
            int i = 0;
            for (NSNumber *width in self.sectionItemWidthArray) {
                if (idx == i) {
                    break;
                }
                offsetX += [width floatValue];
                i++;
            }
            
            textRect = CGRectMake(offsetX, offsetTitleY, titleWidth, titleHeight);
            
        }
        
        
        
        CATextLayer *textLayer = [[CATextLayer alloc] init];
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        textLayer.frame = textRect;
        
        textLayer.string = [self convertAttributedString:idx];
        [self.scrollView.layer addSublayer:textLayer];
        
        
    }];
    
    

    // 盒子样式只有在 MLSectionItemWidthStyleFix 模式下才会有作用
    if (self.itemWidthStyle == MLSectionItemWidthStyleFix) {

        if (self.sectionDecorateStyle == MLSectionDecorateStyleBox) {
            if (self.sectionItemBoxLayer.superlayer == nil) {

                self.sectionItemBoxLayer.frame = [self setItemBoxLayerFrame];
                
                self.sectionItemBoxLayer.cornerRadius = self.sectionItemBoxLayer.frame.size.height / 2;
                // 设置透明度
                self.sectionItemBoxLayer.opacity = 0.8;
                [self.scrollView.layer insertSublayer:self.sectionItemBoxLayer atIndex:0];;

            }
        }else{
            if (self.sectionItemStripeLayer.superlayer == nil) {
               self.sectionItemStripeLayer.frame =  [self setItemItemStripeFrame];
                [self.scrollView.layer addSublayer:self.sectionItemStripeLayer];

            }

        }

    }else{
        if (self.sectionItemStripeLayer.superlayer == nil) {
            self.sectionItemStripeLayer.frame =  [self setItemItemStripeFrame];
            [self.scrollView.layer addSublayer:self.sectionItemStripeLayer];
            
        }

    }
 
    
}


// 设置boxFrame
- (CGRect)setItemBoxLayerFrame{

    
    CGSize titleSize = [self calculatingTitleWidthForIndex:self.selectionIndex];
    
    CGFloat X = (self.sectionWidth * self.selectionIndex)+((self.sectionWidth - titleSize.width)/2) - 10;
    CGFloat Y = (self.frame.size.height - titleSize.height)/2 - 6;
    CGFloat W = titleSize.width + 2 * 10;
    CGFloat H = titleSize.height + 2 * 6;
    
    
    return CGRectMake(X, Y, W, H);

}


// 设置横条frame
- (CGRect)setItemItemStripeFrame{
    
    
    if (self.itemWidthStyle == MLSectionItemWidthStyleFix) {
        
        if (self.stripeIndicatorWidthStyle == MLStripeIndicatorWidthEqualText) {
             CGSize titleSize = [self calculatingTitleWidthForIndex:self.selectionIndex];
            CGFloat offsetX = 0;
            int i = 0;
            for (NSNumber *width in self.sectionItemWidthArray) {
                
                if (self.selectionIndex == i) {
                    break;
                }
                offsetX += [width floatValue];
                i ++;
            }
            CGFloat X = offsetX + (self.sectionWidth - titleSize.width)/2;
            CGFloat Y = self.frame.size.height - self.sectionStripeHeight;
            CGFloat W = titleSize.width;
            CGFloat H = self.sectionStripeHeight;
            return CGRectMake(X, Y, W, H);
            
        }else{
            
           
            CGFloat X = self.selectionIndex * self.sectionWidth;
            CGFloat Y = self.frame.size.height - self.sectionStripeHeight;
            CGFloat W = self.sectionWidth;
            CGFloat H = self.sectionStripeHeight;
             return CGRectMake(X, Y, W, H);
        }

    }else{
        
        CGSize titleSize = [self calculatingTitleWidthForIndex:self.selectionIndex];
        CGFloat offsetX = 0;
        int i = 0;
        for (NSNumber *width in self.sectionItemWidthArray) {
            
            if (self.selectionIndex == i) {
                break;
            }
            offsetX += [width floatValue];
            i ++;
        }
        CGFloat X = offsetX;
        CGFloat Y = self.frame.size.height - self.sectionStripeHeight;
        CGFloat W = titleSize.width;
        CGFloat H = self.sectionStripeHeight;
        return CGRectMake(X, Y, W, H);
        
    }
    

}


// 更新frame
- (void)updateSectionItemFrame{
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    if (self.titles.count <= 0) return;
    NSInteger count = self.titles.count;

    self.sectionWidth =   self.frame.size.width / count;
    NSMutableArray *itemWidthArray = [NSMutableArray array];
    if (self.itemWidthStyle == MLSectionItemWidthStyleFix) {
        
        [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGSize size = [self calculatingTitleWidthForIndex:idx];
            CGFloat titleWidth = size.width + self.sectionEdgeInset.left + self.sectionEdgeInset.right;
            self.sectionWidth = MAX(self.sectionWidth, titleWidth);
        }];
        
    }else{
        
        
        [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGFloat titleWidth = [self calculatingTitleWidthForIndex:idx].width + self.sectionEdgeInset.left + self.sectionEdgeInset.right;
        
            [itemWidthArray addObject:[NSNumber numberWithFloat:titleWidth]];
            
        }];
        self.sectionItemWidthArray = itemWidthArray.copy;

    }
    
    
    CGFloat totalWidth = 0;
    if (self.itemWidthStyle == MLSectionItemWidthStyleFix) {
        totalWidth =  self.sectionWidth * self.titles.count;
    }else{
        for (NSNumber *width in self.sectionItemWidthArray) {
            totalWidth += [width floatValue];
        }
    }

    // 当求出的宽度没有达到屏幕的总宽度
    if (self.shouldFullScreenRepeat&& totalWidth < self.frame.size.width) {
        CGFloat spaceWidth = self.frame.size.width - totalWidth;
        CGFloat averageWidth = spaceWidth / count;
        
        CGFloat combinationWidth = 0;
        int i = 0;
        for (NSNumber *width in self.sectionItemWidthArray) {
            combinationWidth = [width floatValue] + averageWidth;
            [itemWidthArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:combinationWidth]];
            i ++;
        }
        self.sectionItemWidthArray = itemWidthArray.copy;
        totalWidth = self.frame.size.width;
        
    }
    self.scrollView.contentSize = CGSizeMake(totalWidth, self.frame.size.height);
    
}

// 计算文字size
- (CGSize)calculatingTitleWidthForIndex:(NSInteger)index{
    
    if (index > self.titles.count)return CGSizeZero;
    
   id title = self.titles[index];
    BOOL selected = (self.selectionIndex == index);
    if ([title isKindOfClass:[NSString class]]) {

        if (self.selecSectionFixItemBlock) {
           
           NSAttributedString *str =  self.selecSectionFixItemBlock(self, title, index,selected);
            return str.size;
            
        }else{
            
            NSDictionary *attributs = selected ?[self selectedItemStyleAttributes] :[self noSelectedItemStyleAttributes];
            NSAttributedString *str =  [[NSAttributedString alloc] initWithString:title attributes:attributs];
            return [str size];
        }
       
        
    }else if ([title isKindOfClass:[NSAttributedString class]]){
        if (self.selecSectionFixItemBlock) {
            
            NSAttributedString *str =  self.selecSectionFixItemBlock(self, title, index,selected);
            return str.size;
            
        }else{
            return [(NSAttributedString *)title size];
        }
        
        
    }else{
         return  CGSizeZero;
    }
    
    return  CGSizeZero;
    
}

# pragma mark - 点击效果
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint locationPoint  = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.frame, locationPoint)) {
        
          // 寻找索引值
        NSInteger index= 0;
        if (self.itemWidthStyle == MLSectionItemWidthStyleFix) {
             index = (locationPoint.x + self.scrollView.contentOffset.x) / self.sectionWidth;
           
        }else{
            
            CGFloat location_X = (locationPoint.x + self.scrollView.contentOffset.x);
            int i = 0;
            for (NSNumber *width in self.sectionItemWidthArray) {
                location_X -= [width floatValue];
                index = i;
                if (location_X < 0) {
                    break;
                }
              
                i ++;
            }
        }
        
        if (self.isUserEnabled == YES) {
              [self moveSectionItemToPostionIndex:index WithAnimated:YES];
        }

    }

    
}


// 移动到指定的位置
- (void)moveSectionItemToPostionIndex:(NSInteger)index WithAnimated:(BOOL)animated{
    
    self.selectionIndex = index;
   // 判断是否有添加, 当程序已启动就设置选中的第几个时，需要移动到指定的位置，这里可以不需要动画的执行
    // 盒子样式只有在 MLSectionItemWidthStyleFix 模式下才会有作用
    if (self.itemWidthStyle == MLSectionItemWidthStyleFix) {
        
        if (self.sectionDecorateStyle == MLSectionDecorateStyleBox) {
            if (self.sectionItemBoxLayer.superlayer == nil) {
                
               
                
                self.sectionItemBoxLayer.cornerRadius = self.sectionItemBoxLayer.frame.size.height / 2;
                // 设置透明度
                self.sectionItemBoxLayer.opacity = 0.8;
                [self.scrollView.layer insertSublayer:self.sectionItemBoxLayer atIndex:0];
                
                [self moveSectionItemToPostionIndex:index WithAnimated:NO];
                
            }
        }else{
            if (self.sectionItemStripeLayer.superlayer == nil) {
                
                [self.scrollView.layer addSublayer:self.sectionItemStripeLayer];
                
            }
            
        }
        
    }else{
        if (self.sectionItemStripeLayer.superlayer == nil) {
           
            [self.scrollView.layer addSublayer:self.sectionItemStripeLayer];
            
        }
        
    }
    [self scrollRectToVisible:index animated:animated];
    
    if (animated) {
        
        // 清空隐式动画
        self.sectionItemStripeLayer.actions = nil;
        self.sectionItemBoxLayer.actions = nil;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.2];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        self.sectionItemBoxLayer.frame = [self setItemBoxLayerFrame];
        self.sectionItemStripeLayer.frame = [self setItemItemStripeFrame];
        [CATransaction commit];
    }else{

        NSDictionary *actions = [NSDictionary dictionaryWithObjectsAndKeys:[NSNull null],@"postion",[NSNull null],@"bounds", nil];
        self.sectionItemBoxLayer.actions = actions;
        self.sectionItemStripeLayer.actions = actions;
        self.sectionItemBoxLayer.frame = [self setItemBoxLayerFrame];
        self.sectionItemStripeLayer.frame = [self setItemItemStripeFrame];

    }
    
    [self setNeedsDisplay];
    [self layoutIfNeeded];
    [self sendActionsForControlEventsForIndex:index];

}

// 响应点击事件
- (void)sendActionsForControlEventsForIndex:(NSInteger)index{
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    if (self.selectForIndexBlock) {
        self.selectForIndexBlock(index);
    }
}

// 滚动到Rect可见的位置
- (void)scrollRectToVisible:(NSInteger)index animated:(BOOL)animated{
    
    CGRect visibleRect = CGRectZero;
    CGFloat offsetWidth = 0;
    
    if (self.itemWidthStyle == MLSectionItemWidthStyleFix) {
        
        visibleRect = CGRectMake(self.selectionIndex * self.sectionWidth, 0, self.sectionWidth, self.bounds.size.height);
        
        offsetWidth = self.frame.size.width/2 - self.sectionWidth/2;
        
        
    }else{
        
        CGFloat offset_X = 0;
        int i = 0;
        for (NSNumber *width in self.sectionItemWidthArray) {
            if (self.selectionIndex == i) {
                break;
            }
            offset_X += [width floatValue];
            i ++;
        }
        
         visibleRect = CGRectMake(offset_X, 0, [self.sectionItemWidthArray[self.selectionIndex] floatValue], self.bounds.size.height);
        
        offsetWidth = self.frame.size.width/2 - ([self.sectionItemWidthArray[self.selectionIndex] floatValue])/2;

        
    }
    
    CGRect rect = visibleRect;
    rect.origin.x = visibleRect.origin.x - offsetWidth;
    rect.size.width = visibleRect.size.height + 2 * offsetWidth;
    visibleRect = rect;
    
    [self.scrollView scrollRectToVisible:visibleRect animated:animated];
    
    
    
}




#pragma mark - 选中和非选中状态下的文字样式
- (NSDictionary *)noSelectedItemStyleAttributes{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,[UIColor blackColor],NSForegroundColorAttributeName,nil];

    if (self.noSelectItemAttributes) {
        [attributes addEntriesFromDictionary:self.noSelectItemAttributes];
    }
    return attributes;
}

- (NSDictionary *)selectedItemStyleAttributes{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName,nil];

    
    if (self.selectItemAttributes) {
        [attributes addEntriesFromDictionary:self.selectItemAttributes];
    }
    return attributes;
}

// 将字符串转换成 NSAttributedString 类型
- (NSAttributedString *)convertAttributedString:(NSInteger)index{
    
    if (index > self.titles.count) {
        return nil;
    }
 
    id title = self.titles[index];
    BOOL selected = (self.selectionIndex == index);
    if ([title isKindOfClass:[NSString class]] && self.selecSectionFixItemBlock
         == nil) {
        
        NSDictionary *attributes = selected?[self selectedItemStyleAttributes]:[self noSelectedItemStyleAttributes];
        NSAttributedString *attributString = [[NSAttributedString alloc] initWithString:title attributes:attributes];
        return attributString;
        
    }else if ([title isKindOfClass:[NSString class]] &&self.selecSectionFixItemBlock != nil){
        return self.selecSectionFixItemBlock(self, title, index,selected);
        
        
    }else if ([title isKindOfClass:[NSAttributedString class]]){
        return (NSAttributedString *)title;
    }else{
        return nil;
    }
 
}

#pragma mark - Setter
- (void)setTitles:(NSArray *)titles{
    if (titles == nil) return;
    _titles = titles;
    [self updateSectionItemFrame];
    [self layoutIfNeeded];
    [self setNeedsDisplay];
    
}

#pragma marrk - Getter







@end




