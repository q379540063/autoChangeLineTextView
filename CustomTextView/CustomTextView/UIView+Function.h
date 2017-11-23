//
//  UIView+Function.h
//  u76ho
//
//  Created by m-air-01 on 15/12/25.
//  Copyright (c) 2015年 LV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Function)
/**
 *  视图左侧(view.frame.origin.x)
 */
@property (nonatomic, assign) CGFloat left;
/**
 *  视图顶部(view.frame.origin.y)
 */
@property (nonatomic, assign) CGFloat top;
/**
 *  宽度(view.frame.size.width)
 */
@property (nonatomic, assign) CGFloat width;
/**
 *  高度(view.frame.size.height)
 */
@property (nonatomic, assign) CGFloat height;
/**
 *  视图右侧(origin.x + size.width)---set方法改变宽度，x不变
 */
@property (nonatomic, assign) CGFloat right;
/**
 *  视图底部(origin.y + size.height)---set方法改变高度，y不变
 */
@property (nonatomic, assign) CGFloat bottom;

@end
