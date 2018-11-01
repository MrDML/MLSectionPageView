//
//  MLSectionPageView.h
//  MLSectionPageView
//
//  Created by 戴明亮 on 2018/11/1.
//  Copyright © 2018年 ML Day. All rights reserved.
//

#import <UIKit/UIKit.h>

#define StatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

#define ScreeWidth [UIScreen mainScreen].bounds.size.width

#define ScreeHeight [UIScreen mainScreen].bounds.size.height

NS_ASSUME_NONNULL_BEGIN


@interface MLSectionPageView : UIView

- (instancetype)initWithWithActiveTitles:(NSArray <NSString *>*)activeTitles WithInactiveTitles:(NSArray <NSString *>*)inactiveTitles;

@property (nonatomic, strong) NSArray <NSString *>*activeTitles;
@property (nonatomic, strong) NSArray <NSString *>*inactiveTitles;
@end

NS_ASSUME_NONNULL_END
