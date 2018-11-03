//
//  MLSectionPage.m
//  MLSectionPageView
//
//  Created by ML Dai on 2018/11/3.
//  Copyright © 2018 ML Day. All rights reserved.
//

#import "MLSectionPage.h"
#import <objc/runtime.h>


@interface MLforwarder : NSObject<UIScrollViewDelegate>
@property (nonatomic, weak) id<MLSectionPageDelegate>delegate;
@property (nonatomic, weak) MLSectionPage *page;

@end

@implementation MLforwarder



- (id)forwardingTargetForSelector:(SEL)aSelector{
    
    
    if ([self.delegate respondsToSelector:aSelector]) {
        return self.delegate;
    }
    
    if ([self.page respondsToSelector:aSelector]) {
        return self.page;
    }
    
    return  [super forwardingTargetForSelector:aSelector];
}




- (BOOL)respondsToSelector:(SEL)aSelector{
    if ([self.delegate respondsToSelector:aSelector]) {
        return YES;
    }
    if ([self.page respondsToSelector:aSelector]) {
        return YES;
    }
    return  [super respondsToSelector:aSelector];
    
}


@end


@interface MLSectionPage ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableDictionary <NSNumber *, UIView*>*pages;
@property (nonatomic, strong) NSMutableDictionary   *registration;
@property (nonatomic, strong) NSMutableArray        *reuseQueue;
@end


@implementation MLSectionPage{
    NSInteger _count;
    NSInteger _index;
    MLforwarder *_forwarder;
}

@dynamic delegate;


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    
    _forwarder = [[MLforwarder alloc] init];
    super.delegate = _forwarder;
    
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.scrollsToTop = NO;
    self.directionalLockEnabled = NO;
    
    self.pages = [NSMutableDictionary dictionary];
    self.registration = [NSMutableDictionary dictionary];
    self.reuseQueue = [NSMutableArray array];
}



- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (_count <= 0) {
        [self reloadData];
    }
    
 
    
    
    CGSize size = self.bounds.size;
    size.width = size.width * _count;
    if (!CGSizeEqualToSize(size, self.contentSize)) {
        
        
        // 保持原样
        CGFloat width = self.bounds.size.width * _count;
        [super setContentOffset:CGPointMake(width, self.frame.size.height) animated:NO];

        for (NSNumber *key in [self.pages allKeys]) {
            UIView *view = self.pages[key];

            view.frame = CGRectMake( self.frame.size.width * [key integerValue], 0, self.frame.size.width, self.frame.size.height);
        }
        
    }

}


- (void)reloadData{
    
    for ( NSNumber *key in [self.pages allKeys]) {
        UIView *view = self.pages[key];
        [view removeFromSuperview];
    }
    
    [self.pages removeAllObjects];

    if ([self.datasource respondsToSelector:@selector(numbersSectionPage:forPageIndex:)]) {
        _count = [self.datasource numbersSectionPage:self forPageIndex:_index];
    }
   
    if (_count > 0) {
        _index = MIN(_count - 1, _index);
        [self loadPagesIndex:_index];
        [self setNeedsLayout];
    }

}



- (void)showSectionPageAtIndex:(NSInteger)index animated:(BOOL)animated{
    
    if (index > 0 && index < _count && index != _count ) {
        
        animated = (self.transitionStyle == MLPageTransitionStyleTable)? NO : animated;
        
        [self setContentOffset:CGPointMake(self.frame.size.width * index, self.frame.size.height) animated:animated];
    }
    
}


- (UIView *)pageAtIndex:(NSInteger)index{
    UIView *view = self.pages[[NSNumber numberWithInteger:index]];
    return view;
}



- (void)loadPagesIndex:(NSInteger)index{
    
    
    void (^loadPage)(NSInteger index) = ^(NSInteger index){
        
        if (!self.pages[@(index)] && index >= 0 && index < self->_count) {
            
            
            UIView *pageView =  [self.datasource pagerView:self viewForPageAtIndex:index];
            
            pageView.frame = CGRectMake(self.frame.size.width * index, 0, self.frame.size.width, self.frame.size.height);
            
            
            if ([self.delegate respondsToSelector:@selector(pagerView:willDisplayPage:atIndex:)]) {
                [self.delegate pagerView:self willDisplayPage:pageView atIndex:index];
            }
            
            [self addSubview:pageView];
            [self setNeedsLayout];
        
            self.pages[[NSNumber numberWithInteger:index]] = pageView;
            
        }

    };
    
    loadPage(index);
    
    if (self.transitionStyle == MLPageTransitionStyleScroll) {
        loadPage(index - 1);
        loadPage(index + 1);
    }
    
    
}


- (void)unHiddenPage{
    
    NSMutableArray *movePageKeys = [NSMutableArray array];
    for (NSNumber *key in self.pages.allKeys) {

        NSInteger index = [key integerValue];
        if (index != _index) {
            
            if (((index != _index - 1) && (index != _index + 1))|| self.transitionStyle == MLPageTransitionStyleTable) {
                UIView *page = self.pages[key];
                
                if ([self.delegate respondsToSelector:@selector(pagerView:didEndDisplayingPage:atIndex:)]) {
                    [self.delegate pagerView:self didEndDisplayingPage:page atIndex:index];
                }
                
                [page removeFromSuperview];

                if (page.reuseIdentifier) {
                    [self.reuseQueue addObject:page];
                }

                 [movePageKeys addObject:key];
                
            }
        }
    }

    [self.pages removeObjectsForKeys:movePageKeys];
    
}




- (void)willMovePageToindex:(NSInteger)index{
    [self loadPagesIndex:index];
    
    if ([self.delegate respondsToSelector:@selector(pagerView:willMoveToPage:atIndex:)]) {
        [self.delegate pagerView:self willMoveToPage:self.pages[@(index)] atIndex:index];
    }
    
}



- (void)didMovePageToindex:(NSInteger)index{
    
    if ([self.delegate respondsToSelector:@selector(pagerView:didMoveToPage:atIndex:)]) {
        [self.delegate pagerView:self didMoveToPage:self.pages[@(index)] atIndex:index];
    }
    
    [self unHiddenPage];
    
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger point_X = scrollView.contentOffset.x;
    NSInteger width = scrollView.bounds.size.width;
    _index = point_X / width;
    
    [self willMovePageToindex:_index];
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.delegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    
    NSInteger point_X = targetContentOffset->x;
    NSInteger width = scrollView.bounds.size.width;
    _index = point_X / width;
    
    [self didMovePageToindex:_index];
    
    if ([self.delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }

}


// 该代理方法的执行，是需要执行contentOffset这个方法并且 setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated  animated= yes 才会执行
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self didMovePageToindex:_index];
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.delegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}


// 这个方法主要处理手动的调用，代理方法是执行手势滚动
- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated{
    
    
    

    if (!fmod(contentOffset.x, self.frame.size.width)) {
        
        NSInteger index = contentOffset.x / self.frame.size.width;
        _index = index;
        [self willMovePageToindex:index];
        [super setContentOffset:contentOffset animated:animated];
       
        if (animated) {
    
        }else{
            
            // animated 为no时不会执行代理方法，所以这里需要手动的执行
            [self didMovePageToindex:index];
            
        }
 
    }else{
         [super setContentOffset:contentOffset animated:animated];
    }
    
    
}



- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pangesture =(UIPanGestureRecognizer *) gestureRecognizer;
       CGPoint velocity =  [pangesture velocityInView:self];
        if (fabs(velocity.x) > fabs(velocity.y)) {
            return YES;
        }else{
            return NO;
        }
        
    }
    
    
    return YES;
}


- (void)registerNib:(UINib *)nib forPageReuseIdentifier:(NSString *)identifier{
    [self.registration setValue:nib forKey:identifier];
}

- (void)registerClass:(Class)pageClass forPageReuseIdentifier:(NSString *)identifier{
    
    [self.registration setValue:NSStringFromClass(pageClass) forKey:identifier];
}


- (UIView *)dequeueReusablePageWithIdentifier:(NSString *)identifier {
    
    UIView *pageView = nil;
    for (UIView *obj in self.reuseQueue) {

        if (obj.reuseIdentifier == identifier) {
            pageView = obj;
            return obj;
            break;
        }
        
    }
    
    if (pageView == nil) {
        
      id builder =  self.registration[identifier];
        if ([builder isKindOfClass:[UINib class]]) {
           pageView = [(UINib *)builder instantiateWithOwner:self options:nil].firstObject;
        }else if ([builder isKindOfClass:[NSString class]]){
          pageView =  [[NSClassFromString((NSString *)builder) alloc] init];
        }else{
          pageView = [[UIView alloc] init];
        }
        
        objc_setAssociatedObject(self, @selector(identifier), pageView, OBJC_ASSOCIATION_COPY);
        
    }else{
        [self.reuseQueue removeObject:pageView];
        // 进行预加载
        [pageView prepareForReuse];
    }
    
    
    
    return pageView;
    
    
}


- (void)setDelegate:(id<MLSectionPageDelegate>)delegate{
    super.delegate = nil;
    _forwarder.delegate = delegate;
    super.delegate = _forwarder;
}


- (id<MLSectionPageDelegate>)delegate{
    return _forwarder.delegate;
}


- (UIView *)selectedPage {
    NSNumber *key = [NSNumber numberWithInteger:_index];
    return self.pages[key];
}

- (NSInteger)indexForSelectedPage {
    return _index;
}

- (void)setTransitionStyle:(MLPageTransitionStyle)transitionStyle {
    _transitionStyle = transitionStyle;
    //the tab behavior disable the scroll
    self.scrollEnabled = (transitionStyle != MLPageTransitionStyleTable);
}

- (NSArray<UIView *> *)loadedPages {
    return [self.pages allValues];
}

- (CGFloat)progress {
    CGFloat position  = self.contentOffset.x;
    CGFloat width     = self.bounds.size.width;
    
    return position / width;
}

@end





@implementation UIView (MLUIViewIdentifire)



const char * identifierKey = "identifierKey";

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier{
    self = [self init];
    if (self) {
     
        objc_setAssociatedObject(self, @selector(identifier), reuseIdentifier, OBJC_ASSOCIATION_COPY);
        
    }
    
    return self;
    
}


- (instancetype)initWithFrame:(CGRect)frame reuseIdentifier:(nullable NSString *)reuseIdentifier{
    self = [self initWithFrame:frame];
    if (self) {
         objc_setAssociatedObject(self, @selector(identifier), reuseIdentifier, OBJC_ASSOCIATION_COPY);
    }
    return self;
}


- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder reuseIdentifier:(nullable NSString *)reuseIdentifier{
    self = [self initWithCoder:aDecoder];
    if (self) {
        objc_setAssociatedObject(self, @selector(identifier), reuseIdentifier, OBJC_ASSOCIATION_COPY);
    }
    return self;
}


- (void)prepareForReuse{
    
}


- (NSString *)reuseIdentifier {
    return objc_getAssociatedObject(self, @selector(reuseIdentifier));
}


@end
