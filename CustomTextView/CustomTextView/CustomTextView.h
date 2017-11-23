//
//  CommentCustomTextView.h
//  TextViewDemo
//
//  Created by  on 2017/10/31.
//  Copyright © 2017年 ChenXJ. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomTextView : UIView

@property(nonatomic,assign)NSUInteger numberOfLines;

-(instancetype) init __attribute__((unavailable("init not available should use initWithFrame:")));

/**
 失去焦点

 @return return value description
 */
-(BOOL)customResignFirstResponder;


@end

