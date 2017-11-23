//
//  UIView+Function.m
//  u76ho
//
//  Created by m-air-01 on 15/12/25.
//  Copyright (c) 2015年 LV. All rights reserved.
//

#import "UIView+Function.h"

@implementation UIView (Function)
- (void)setLeft:(CGFloat)left {
    
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (void)setTop:(CGFloat)top {
    
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width {
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height {
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setRight:(CGFloat)right {
    
    CGRect frame = self.frame;
    frame.size.width = right - frame.origin.x;
    self.frame = frame;
}

- (void)setBottom:(CGFloat)bottom {
    
    CGRect frame = self.frame;
    frame.size.height = bottom - frame.origin.y;
    self.frame = frame;
}

- (CGFloat)left {
    
    return self.frame.origin.x;
}

- (CGFloat)top {
    
    return self.frame.origin.y;
}

- (CGFloat)width {
    
    return self.frame.size.width;
}

- (CGFloat)height {
    
    return self.frame.size.height;
}

- (CGFloat)right {
    
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)bottom {
    
    return self.frame.origin.y + self.frame.size.height;
}

@end
