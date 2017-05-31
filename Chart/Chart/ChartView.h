//
//  ChartView.h
//  Chart
//
//  Created by zhenyong on 2017/5/30.
//  Copyright © 2017年 com.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartView : UIView
- (instancetype)initWithFrame:(CGRect)frame andDataAr:(NSArray *)dataArr;

-(void)show;
@end
