//
//  ViewController.m
//  CustomTextView
//
//  Created by *** on 2017/11/23.
//  Copyright © 2017年 ChenXJ. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Function.h"
#import "CustomTextView.h"
@interface ViewController ()

@property(nonatomic,strong)CustomTextView * cView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CustomTextView * cView = [[CustomTextView alloc]initWithFrame:CGRectMake(0, self.view.height - 50, self.view.width, 50)];
    [self.view addSubview:cView];
    _cView = cView;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_cView customResignFirstResponder];
}


@end
