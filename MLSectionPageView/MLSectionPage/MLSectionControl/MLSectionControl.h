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


typedef NSAttributedString  *(^MLSelecSectionFixItemBlock)(MLSectionControl* sectionControl, NSString *title, NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface MLSectionControl : UIControl
- (instancetype)initWithSectionControlTitles:(NSArray <NSString *>*)titles;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) MLSectionItemWidthStyle *itemWidthStyle;

@property (nonatomic, strong) NSDictionary <NSAttributedString *,id>*noSelectItemAttributes;
@property (nonatomic, strong) NSDictionary <NSAttributedString *,id>*selectItemAttributes;

@property (nonatomic, copy) MLSelecSectionFixItemBlock selecSectionFixItemBlock;


@property (nonatomic, assign) UIEdgeInsets sectionEdgeInset;
@property (nonatomic, assign) BOOL shouldFullScreenRepeat;

@end

NS_ASSUME_NONNULL_END
