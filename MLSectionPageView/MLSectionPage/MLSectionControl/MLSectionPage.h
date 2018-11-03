//
//  MLSectionPage.h
//  MLSectionPageView
//
//  Created by ML Dai on 2018/11/3.
//  Copyright © 2018 ML Day. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MLSectionPage;

typedef NS_ENUM(NSInteger,MLPageTransitionStyle) {
    MLPageTransitionStyleScroll,
    MLPageTransitionStyleTable
};


@protocol MLSectionPageDelegate <UIScrollViewDelegate>


- (void)pagerView:(MLSectionPage *)pagerView willMoveToPage:(UIView *)page atIndex:(NSInteger)index;

- (void)pagerView:(MLSectionPage *)pagerView didMoveToPage:(UIView *)page atIndex:(NSInteger)index;


- (void)pagerView:(MLSectionPage *)pagerView willDisplayPage:(UIView *)page atIndex:(NSInteger)index;


- (void)pagerView:(MLSectionPage *)pagerView didEndDisplayingPage:(UIView *)page atIndex:(NSInteger)index;

@end

@protocol MLSectionPageDataSource <NSObject>

@required
- (NSInteger)numbersSectionPage:(MLSectionPage*)page forPageIndex:(NSInteger)index;
- (nullable __kindof UIView *)pagerView:(MLSectionPage *)pagerView viewForPageAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MLSectionPage : UIScrollView
@property (nonatomic, assign) MLPageTransitionStyle transitionStyle;
@property (nonatomic, weak) IBOutlet id <MLSectionPageDelegate> delegate;
@property (nonatomic, weak) IBOutlet id <MLSectionPageDataSource>datasource;
@end

@interface UIView (MLUIViewIdentifire)


@property (nonatomic, copy,readonly, nullable) NSString *reuseIdentifier;


- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier;


- (instancetype)initWithFrame:(CGRect)frame reuseIdentifier:(nullable NSString *)reuseIdentifier;


- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder reuseIdentifier:(nullable NSString *)reuseIdentifier;


- (void)prepareForReuse;
- (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
