//
//  MLSectionControl.h
//  MLSectionPageView
//
//  Created by 戴明亮 on 2018/11/1.
//  Copyright © 2018年 ML Day. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MLSectionControl;


typedef NS_ENUM(NSInteger, MLSectionItemWidthStyle) {
    MLSectionItemWidthStyleFix,
    MLSectionItemWidthStyleDynamic
};

// 装饰
typedef NS_ENUM(NSInteger,MLSectionDecorateStyle) {
    MLSectionDecorateStyleStripe,
    MLSectionDecorateStyleBox,
    MLSectionDecorateStyleNone
};

// 线条的样式
typedef NS_ENUM(NSInteger, MLStripeIndicatorWidthStyle) {
    MLStripeIndicatorWidthFullSection,
    MLStripeIndicatorWidthEqualText
};


typedef void(^MLSelectForIndexBlock)(NSInteger index);

typedef NSAttributedString  *(^MLSelecSectionFixItemBlock)(MLSectionControl* sectionControl, NSString *title, NSInteger index,BOOL selected);

NS_ASSUME_NONNULL_BEGIN

@interface MLSectionControl : UIControl
- (instancetype)initWithSectionControlTitles:(NSArray <NSString *>*)titles;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) MLSectionItemWidthStyle itemWidthStyle;

@property (nonatomic, strong) NSDictionary <NSAttributedString *,id>*noSelectItemAttributes;

@property (nonatomic, strong) NSDictionary <NSAttributedString *,id>*selectItemAttributes;


@property (nonatomic, copy) MLSelecSectionFixItemBlock selecSectionFixItemBlock;

// section 扩展
@property (nonatomic, assign) UIEdgeInsets sectionEdgeInset;

// 当总宽度不够时是否允许平铺
@property (nonatomic, assign) BOOL shouldFullScreenRepeat;

// 选中盒子的颜色
@property (nonatomic, strong) UIColor *sectionItemBoxLayerBgColor;
// 选中线条的颜色
@property (nonatomic, strong) UIColor *sectionItemStripeLayerBgColor;


// 装饰的样式
@property (nonatomic, assign) MLSectionDecorateStyle sectionDecorateStyle;

// 指示器宽度的样式
@property (nonatomic, assign) MLStripeIndicatorWidthStyle  stripeIndicatorWidthStyle;

// 是否允许点击
@property (nonatomic, getter=isUserEnabled) BOOL userEnabled;

// 选中索引返回的block
@property (nonatomic, copy) MLSelectForIndexBlock selectForIndexBlock;

// 横条的高度
@property (nonatomic, assign) CGFloat sectionStripeHeight;

@property (nonatomic, readonly) NSInteger selectionIndex;

// 移动到指定的位置
- (void)moveSectionItemToPostionIndex:(NSInteger)index WithAnimated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
