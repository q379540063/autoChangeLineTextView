//
//  CommentCustomTextView.m
//  TextViewDemo
//
//  Created by  on 2017/10/31.
//  Copyright © 2017年 ChenXJ. All rights reserved.
//

#import "CustomTextView.h"
#import "UIView+Function.h"
#define textFont [UIFont systemFontOfSize:16]

@interface CTextView:UITextView

@end

@implementation CTextView

//设置 @" "为了设置行间距 加载时候在清空
-(void)layoutSubviews{
    if ([self.text isEqualToString:@" "]) {
        self.text = @"";
    }
}

@end

@interface CustomTextView()<UITextViewDelegate>{
    CGFloat _keyBoardHeight;
    BOOL    _keyBoardIsShow;
    CGRect  _originRect;
    CGFloat _oringTextHeight;
}

/**
 键盘未弹起时候 底部的 请输入您的评价 _commentText View
 */
@property(nonatomic,strong)UIView * inputLabelView;


/**
 键盘弹起时  输入框的 父 View
 */
@property(nonatomic,strong)UIView * inputView;

/**
 textView 中占位 label 键盘弹起时候的 holderLabel
 */
@property(nonatomic,strong) UILabel * placeHolderLabel;


/**
 下面功能View 匿名  发送
 */
@property(nonatomic,strong)UIView * bottomView;

/**
 输入 textView
 */
@property(nonatomic,strong)CTextView * textView;

/**
 是否滚动状态 textView 滚动
 */
@property (nonatomic, assign, getter=isSrolling) BOOL srolling;

@end

@implementation CustomTextView

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    _textView.delegate = nil;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _originRect = frame;
        [self setUpViews];
        [self addTargetForKeyBorad];
    }
    return self;
}
-(void)setUpViews{
    _inputLabelView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 50)];
    [self addSubview:_inputLabelView];
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _inputLabelView.width, 1.0)];
    lineView.backgroundColor = [UIColor blackColor];
    [_inputLabelView addSubview:lineView];
    
    UIView * writeLabelView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _inputLabelView.width - 20, _inputLabelView.height - 16)];
    writeLabelView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
    [writeLabelView addGestureRecognizer:tap];
    writeLabelView.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0];
    [_inputLabelView addSubview:writeLabelView];
    writeLabelView.center = CGPointMake(_inputLabelView.width/2, _inputLabelView.height/2);
    writeLabelView.layer.cornerRadius = 15;
    
    UIImage * image = [UIImage imageNamed:@"write.png"];
    UIImageView * writeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    writeImageView.image = image;
    [writeLabelView addSubview:writeImageView];
    writeImageView.center = CGPointMake(writeLabelView.height/2, writeLabelView.height /2);
    
    UILabel * placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(writeImageView.right + 10, 0, writeLabelView.width - writeImageView.right - 20, writeLabelView.height)];
    placeLabel.font = [UIFont systemFontOfSize:13.0f];
    placeLabel.textColor = [UIColor grayColor];
    placeLabel.text = @"请输入";
    [writeLabelView addSubview:placeLabel];

    
    UIView * inputView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 50)];
    inputView.backgroundColor = [UIColor whiteColor];
    inputView.hidden = YES;
    [self addSubview:inputView];
    _inputView = inputView;
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, inputView.width, 1.0)];
    lineView2.backgroundColor = [UIColor grayColor];
    [inputView addSubview:lineView2];
    
    CTextView * textView = [[CTextView alloc]initWithFrame:CGRectMake(0, 0, inputView.width - 20, inputView.height - 20)];
    _oringTextHeight = textView.height;
    _textView = textView;
    textView.font = textFont;
    //不然设置的行间距不起作用
    textView.text=@" ";
    //设置控件文字的上下距离
    textView.textContainerInset = UIEdgeInsetsMake(5, 0, 5, 0);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:textFont,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    textView.delegate = self;
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    textView.center = CGPointMake(inputView.width/2, inputView.height/2);
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    textView.layer.borderWidth = 1.0f;
    [inputView addSubview:textView];
    
    _placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(textView.left + 5, 0, 200, textView.height)];
    _placeHolderLabel.font = [UIFont systemFontOfSize:13.0f];
    _placeHolderLabel.center = CGPointMake(_placeHolderLabel.center.x, textView.center.y);
    [inputView addSubview:_placeHolderLabel];
    _placeHolderLabel.textColor = [UIColor grayColor];
    _placeHolderLabel.text = @"请输入";
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _inputLabelView.bottom, self.width, 30)];
    _bottomView.hidden = YES;
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bottomView];
}

/**
 自己激活输入框
 */
-(void)tapView{
    [self.textView becomeFirstResponder];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _originRect = frame;
}

#pragma keyBorad
-(void)addTargetForKeyBorad{
    //监听当键盘将要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


/**
 当键盘出现
 */
- (void)keyboardWillShow:(NSNotification *)notification
{
    if (!_textView.isFirstResponder) {//当前输入框是焦点
        return;
    }
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    _keyBoardHeight = height;
    _keyBoardIsShow = YES;
    [self resetViewFrame];
}
/**
 当键退出
 */
- (void)keyboardWillHide:(NSNotification *)notification
{
    _keyBoardHeight = 0.0f;
    _keyBoardIsShow = NO;
    [self resetViewFrame];
}

/**
 键盘弹起重新计算高度
 */
-(void)resetViewFrame{
    if (_keyBoardIsShow) {
        self.center = CGPointMake(self.center.x, _originRect.origin.y + _originRect.size.height/2 - _keyBoardHeight);
        _inputView.hidden = NO;
        _bottomView.hidden = NO;
    }else{
        self.frame = _originRect;
        _inputView.hidden = YES;
        _bottomView.hidden = YES;
    }
}

-(void)resetView{
    if (_textView.text.length > 0) {
        _placeHolderLabel.hidden = YES;
    }else{
        _placeHolderLabel.hidden = NO;
    }
    CGFloat textHeight = _textView.contentSize.height>98?98:_textView.contentSize.height;
    textHeight = MAX(textHeight, _oringTextHeight);
    _inputView.frame = CGRectMake(0, -(textHeight - _oringTextHeight), _inputView.width, 50 + (textHeight - _oringTextHeight));
    if (_textView.contentSize.height > 98) {
        [_textView setContentOffset:CGPointMake(0, _textView.contentSize.height-98)];
    }
}


#pragma  textViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    [self resetView];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _srolling = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _srolling = NO;
}

/**
 之前方法会跳动，此方法是网上找到，后来找不到地址，无法添加原来地址，作者看到可留言

 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /**
     *  判断是否拖动来设置frame
     */
    if(!_srolling){
        if(_textView.contentSize.height>98){
            [_textView setContentOffset:CGPointMake(0, _textView.contentSize.height-98)];
        }else{
            [_textView setContentOffset:CGPointMake(0, 0)];
        }
    }
}

-(BOOL)customResignFirstResponder{
    return [_textView resignFirstResponder];
}
@end

