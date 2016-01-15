//
//  KSLineSlideView.m
//  KSApplication
//
//  Created by zhang on 15/12/28.
//  Copyright © 2015年 KamiSama. All rights reserved.
//

#import "KSLineSlideView.h"

@interface KSLineSlideView ()

/**
 *  @brief 单个label的大小
 */
@property(nonatomic,assign) CGSize labelSize;

/**
 *  @brief 当前view大小
 */
@property(nonatomic,assign) CGSize viewSize;

/**
 *  @brief 中间滑块的view
 */
@property(nonatomic,strong) UIView *slideView;

/**
 *  @brief 中间高亮label所在的view
 */
@property(nonatomic,strong) UIView *highlightView;

/**
 *  @brief 点击后的方法
 */
@property(nonatomic,copy) SelectBlock selectHandle;

/**
 *  @brief 选中的位置
 */
@property(nonatomic,assign) NSInteger index;

/**
 *  @brief 定时器
 */
@property(nonatomic,strong) NSTimer *timer;

@end

@implementation KSLineSlideView

/**
 *  @brief 初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _duration =0.4;
        _textColor = [UIColor grayColor];
        _textSelectedColor = [UIColor redColor];
        _selectLineColor = [UIColor redColor];
        _fontSize = 15;
        _lineHeight = 2;
        _index = 0;
    }
    return self;
}

/**
 *  @brief 初始化title数组
 */
- (NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [[NSArray alloc]init];
    }
    return _titleArr;
}

/**
 *  @brief 设置点击后的block
 */
- (void)setClickBlock:(SelectBlock)clickBlock{
    self.selectHandle = clickBlock;
}

/**
 *  @brief 初始化布局
 */
- (void)layoutSubviews{
    self.viewSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    self.labelSize = CGSizeMake(self.frame.size.width/self.titleArr.count, self.frame.size.height);
    [self layoutBottomView];
    [self layoutCenterView];
    [self layoutTopView];
    [self showAtIndex];
}

/**
 *  @brief 设置底层的放置label的view
 */
- (void)layoutBottomView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _viewSize.width, _viewSize.height)];
    if (self.titleArr) {
        [self.titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(idx*_labelSize.width, 0, _labelSize.width, _labelSize.height)];
            label.textColor = self.textColor;
            label.text = obj;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:self.fontSize];
            [view addSubview:label];
        }];
    }
    [self addSubview:view];
}

/**
 *  @brief 设置中间层放置高亮label与滑块的view
 */
- (void)layoutCenterView{
    //设置滑动的线
    self.slideView = [[UIView alloc]initWithFrame:CGRectMake(0, _viewSize.height-self.lineHeight, self.labelSize.width, self.lineHeight)];
    self.slideView.backgroundColor = self.selectLineColor;
    //设置中间放置高亮label的view
    self.highlightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _viewSize.width, _viewSize.height)];
    if (self.titleArr) {
        [self.titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(idx*_labelSize.width, 0, _labelSize.width, _labelSize.height)];
            label.textColor = self.textSelectedColor;
            label.text = obj;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:self.fontSize];
            [self.highlightView addSubview:label];
        }];
    }
    [self.highlightView addSubview:self.slideView];
    [self addSubview:self.highlightView];
}

/**
 *  @brief 设置顶层的view
 */
- (void)layoutTopView{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _viewSize.width, _viewSize.height)];
    if (self.titleArr) {
        [self.titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(idx*_labelSize.width, 0, _labelSize.width, _labelSize.height)];
            button.tag = idx;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:[self.titleArr objectAtIndex:idx] forState:UIControlStateHighlighted];
            [button setTitleColor:self.textSelectedColor forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
            [topView addSubview:button];
        }];
    }
    [self addSubview:topView];
}


/**
 *  @brief 点击后的事件
 */
- (void)buttonClick:(UIButton *)button{
    [self slideToIndex:button.tag];
    if (self.selectHandle) {
        self.selectHandle(button.tag);
    }
}

/**
 *  @brief 根据tag移动滑块的位置
 */
- (void)slideToIndex:(NSInteger)tag{
    if (tag<0) {
        tag = 0;
    }
    if (tag>=self.titleArr.count) {
        tag = self.titleArr.count - 1;
    }
    if (tag*self.labelSize.width!=self.slideView.frame.origin.x) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeAlpha:) userInfo:nil repeats:YES];
        [UIView animateWithDuration:self.duration animations:^{
            [self.slideView setFrame:CGRectMake(tag*self.labelSize.width, _viewSize.height-self.lineHeight, self.labelSize.width, self.lineHeight)];
        } completion:^(BOOL finished) {
            if (self.timer) {
                [self.timer invalidate];
                self.timer = nil;
                [self setLabelAlpha:self.slideView.frame.origin.x];
            }
        }];
    }
}

/**
 *  @brief 设置初始时选中的位置
 */
- (void)setSelectedIndex:(NSInteger)index{
    self.index = index;
    if (self.index<0) {
        self.index = 0;
    }
    if (self.index>=_titleArr.count) {
        self.index = _titleArr.count - 1;
    }
}

/**
 *  @brief 初始化时选中的的位置
 */
- (void)showAtIndex{
    [self setSlideScale:self.index*self.labelSize.width];
}

/**
 *  @brief 设置滑块的偏移量
 */
- (void)setSlideScale:(CGFloat)length{
    if (length<0) {
        length = 0;
    }
    if (length>self.highlightView.frame.size.width-_labelSize.width) {
        length = self.highlightView.frame.size.width-_labelSize.width;
    }
    [self.slideView setFrame:CGRectMake(length, _viewSize.height-self.lineHeight, self.labelSize.width, self.lineHeight)];
    [self setLabelAlpha:self.slideView.frame.origin.x];
}

/**
 *  @brief 定时器设置透明度
 */
- (void)changeAlpha:(NSTimer *)timer{
    if (self.slideView.layer.presentationLayer) {
        CALayer *animationLayer = self.slideView.layer.presentationLayer;
        [self setLabelAlpha:(animationLayer.position.x-self.labelSize.width/2.0)];
    }
}

/**
 *  @brief 设置label的透明度
 */
- (void)setLabelAlpha:(CGFloat)location{
    [self.highlightView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isMemberOfClass:[UILabel class]]) {
            CGFloat alpha = (obj.frame.origin.x - location)/obj.frame.size.width;
            if (alpha<0) {
                alpha = -alpha;
            }
            if (alpha>1) {
                alpha = 1;
            }
            obj.alpha = 1 - alpha;
        }
    }];
}

- (void)dealloc{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
