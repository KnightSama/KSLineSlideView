//
//  ViewController.m
//  KSLineSlideView
//
//  Created by zhang on 16/1/15.
//  Copyright © 2016年 KnightSama. All rights reserved.
//

#import "ViewController.h"
#import "KSLineSlideView.h"

@interface ViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scroll;

@property(nonatomic,strong) KSLineSlideView *slideView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.slideView = [[KSLineSlideView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    self.slideView.titleArr = @[@"首页",@"第二",@"第三",@"第四"];
    __weak ViewController *tempSelf = self;
    [self.slideView setClickBlock:^(NSInteger index) {
        [UIView animateWithDuration:tempSelf.slideView.duration animations:^{
            tempSelf.scroll.contentOffset = CGPointMake(index*self.view.frame.size.width, 0);
        }];
    }];
    [self.navigationController.view addSubview:self.slideView];
    
    self.scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    self.scroll.delegate = self;
    self.scroll.contentSize = CGSizeMake(self.scroll.frame.size.width*4, self.scroll.frame.size.height);
    self.scroll.pagingEnabled = YES;
    self.scroll.bounces = NO;
    [self.view addSubview:self.scroll];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  @brief 初始化各视图
 */
- (void)createViews{
    CGFloat width = self.scroll.frame.size.width;
    CGFloat height = self.scroll.frame.size.height;
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    firstView.backgroundColor = [UIColor greenColor];
    [self.scroll addSubview:firstView];
    
    UIView *secondView = [[UIView alloc]initWithFrame:CGRectMake(width, 0, width, height)];
    secondView.backgroundColor = [UIColor purpleColor];
    [self.scroll addSubview:secondView];
    
    UIView *thirdView = [[UIView alloc]initWithFrame:CGRectMake(width*2, 0, width, height)];
    thirdView.backgroundColor = [UIColor blueColor];
    [self.scroll addSubview:thirdView];
    
    UIView *fourthView = [[UIView alloc]initWithFrame:CGRectMake(width*3, 0, width, height)];
    fourthView.backgroundColor = [UIColor redColor];
    [self.scroll addSubview:fourthView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.slideView setSlideScale:scrollView.contentOffset.x/4.0];
}

@end
