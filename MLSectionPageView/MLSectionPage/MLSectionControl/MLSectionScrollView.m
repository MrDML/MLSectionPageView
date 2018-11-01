//
//  MLSectionScrollView.m
//  MLSectionPageView
//
//  Created by 戴明亮 on 2018/11/1.
//  Copyright © 2018年 ML Day. All rights reserved.
//

#import "MLSectionScrollView.h"

@implementation MLSectionScrollView


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.isDragging) {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }else{
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.isDragging) {
        [self.nextResponder touchesMoved:touches withEvent:event];
    }else{
        [super touchesMoved:touches withEvent:event];
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.isDragging) {
        [self.nextResponder touchesEnded:touches withEvent:event];
    }else{
        [super touchesEnded:touches withEvent:event];
    }
}

@end
