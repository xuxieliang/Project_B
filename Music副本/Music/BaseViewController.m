//
//  BaseViewController.m
//  Music
//
//  Created by zhupeng on 15/10/28.
//  Copyright (c) 2015年 朱鹏. All rights reserved.
//

#import "BaseViewController.h"
#import "UIColor+AddColor.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.topView = [[UIView alloc]initWithFrame:(CGRectMake(0, 0, self.view.bounds.size.width, 64))];
    self.topView.backgroundColor = [UIColor silverColor];
    self.topView.alpha = 0.6;
    [self.view addSubview:self.topView];
    
    self.button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.button.frame = CGRectMake(10, 30, 25, 25);
    [self.button setBackgroundImage:[UIImage imageNamed:@"back_nomal"] forState:(UIControlStateNormal)];
    [self.button setBackgroundImage:[UIImage imageNamed:@"back_click"] forState:(UIControlStateHighlighted)];
    [self.topView addSubview:self.button];
    
    self.backgroundView = [[UIView alloc]initWithFrame:(CGRectMake(0, self.topView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.topView.bounds.size.height))];
    [self.view addSubview:self.backgroundView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
