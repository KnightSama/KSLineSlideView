//
//  KSLineSlideView.h
//  KSApplication
//
//  Created by zhang on 15/12/28.
//  Copyright © 2015年 KamiSama. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 标签被选中时的block
 */
typedef void(^SelectBlock)(NSInteger index);

@interface KSLineSlideView : UIView

/**
 *  @brief 未选中的文字颜色
 */
@property(nonatomic,strong) UIColor *textColor;

/**
 *  @brief 选中的文字颜色
 */
@property(nonatomic,strong) UIColor *textSelectedColor;

/**
 *  @brief 滑动横线的颜色
 */
@property(nonatomic,strong) UIColor *selectLineColor;

/**
 *  @brief 滑动横线的高度
 */
@property(nonatomic,assign) CGFloat lineHeight;

/**
 *  @brief 滑动的动画时间
 */
@property(nonatomic,assign) NSTimeInterval duration;

/**
 *  @brief 标题的字体大小
 */
@property(nonatomic,assign) CGFloat fontSize;

/**
 *  @brief 包含的标题
 */
@property(nonatomic,strong) NSArray *titleArr;

/**
 *  @brief 根据tag移动滑块的位置
 */
- (void)slideToIndex:(NSInteger)tag;

/**
 *  @brief 设置滑块的偏移
 */
- (void)setSlideScale:(CGFloat)length;

/**
 *  @brief 设置初始时选中的位置
 */
- (void)setSelectedIndex:(NSInteger)index;

/**
 *  @brief 设置点击后的block
 */
- (void)setClickBlock:(SelectBlock)clickBlock;
@end
