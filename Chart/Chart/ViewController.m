//
//  ViewController.m
//  Chart
//
//  Created by zhenyong on 2017/5/29.
//  Copyright © 2017年 com.demo. All rights reserved.
//

#import "ViewController.h"
#import "ChartView.h"

@interface ViewController ()
@property (strong ,nonatomic) ChartView *chareView ;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    float width = [UIScreen mainScreen].bounds.size.width;
    NSArray *titleArr = @[@"一正一负",@"正",@"负",@"为0"];
    for (int i = 0; i < 4; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(width/4*i, 20, width/3, 100)];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(showChart:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
    }
    
}
- (void)showChart:(UIButton *)button{
    float width = [UIScreen mainScreen].bounds.size.width;

    if(_chareView ){
        [_chareView removeFromSuperview];
        _chareView = nil;
    }
    if (button.tag == 0) {
        _chareView = [[ChartView alloc]initWithFrame:CGRectMake(0, 200, width, 400) andDataAr:@[@"0",@"200",@"-3000",@"400",@"1300",@"-801",@"650"]];
    }
    if (button.tag == 1) {
        _chareView = [[ChartView alloc]initWithFrame:CGRectMake(0, 200, width, 400) andDataAr:@[@"0",@"200",@"1700",@"400",@"1500"]];
    }
    if (button.tag == 2) {
        _chareView = [[ChartView alloc]initWithFrame:CGRectMake(0, 200, width, 400) andDataAr:@[@"-670",@"-200",@"-2200",@"-400",@"-1500",@"-1489",@"-129",@"-148",@"-1269",@"-139",@"-148",@"-819"]];
    }
    if (button.tag == 3) {
        _chareView = [[ChartView alloc]initWithFrame:CGRectMake(0, 200, width, 400) andDataAr:@[@"0",@"0",@"0",@"0",@"0"]];
    }

    [self.view addSubview:_chareView];
    [_chareView show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
