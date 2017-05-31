//
//  ChartView.m
//  Chart
//
//  Created by zhenyong on 2017/5/30.
//  Copyright © 2017年 com.demo. All rights reserved.
//

#import "ChartView.h"
@interface ChartView(){
    CGFloat Ydivision;
    CGFloat upYdivsion;    //大于0的y轴
    CGFloat downYdivsion;  //小于0的y轴
    NSString* maxValue;
    NSString* minValue;
    float absMax_value;
    int       moneySep; //分割线间距
}
/**数据源*/
@property (strong , nonatomic) NSArray *dataArr;
/**折线*/
@property (nonatomic, strong) CAShapeLayer *lineChartLayer;

@property (nonatomic, strong)UIBezierPath * path1;
/** 渐变背景视图 */
@property (nonatomic, strong) UIView *gradientBackgroundView;
/** 渐变图层 */
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
/** 颜色数组 */
@property (nonatomic, strong) NSMutableArray *gradientLayerColors;

@end
static CGFloat bounceX = 40;
static CGFloat bounceY = 20;

@implementation ChartView
- (instancetype)initWithFrame:(CGRect)frame andDataAr:(NSArray *)dataArr{
    if (self = [super initWithFrame:frame]) {
        //   self.my
        self.backgroundColor = [UIColor blueColor];
        _dataArr = dataArr;
        [self calMaxValueAndMinValue];
        [self drawGradientBackgroundView];
        [self createLabelX];
        [self createLabelY];
        [self setLineDash];
    }
    return self;
}
#pragma mark 计算最大值和最小值
-(void)calMaxValueAndMinValue{
    float max = -100000000;
    float min = 100000000;
    downYdivsion = 2;
    upYdivsion = 2;
    for (int i = 0; i < _dataArr.count; i++) {
        NSString *value = _dataArr[i];
        if (max < [value floatValue]) {
            max = [value floatValue];
        }
        if (min > [value floatValue]){
            min = [value floatValue];
        }
    }
    maxValue = [NSString stringWithFormat:@"%.0f",max];
    minValue = [NSString stringWithFormat:@"%.0f",min];
    int max_val = [maxValue intValue];
    int min_val = [minValue intValue];
    int maxV = -1;
    if (abs(min_val) <= max_val) {
        maxV = [maxValue intValue];
        absMax_value = [maxValue floatValue];
    }
    if (abs(min_val) > max_val) {
        maxV = abs([minValue intValue]);
        absMax_value = fabsf([minValue floatValue]);
    }
    
    moneySep = (maxV)/2;
    if (max_val < moneySep) {
        upYdivsion = upYdivsion -1;
    }else if (abs(min_val)<moneySep ){
        downYdivsion = downYdivsion -1;
    }
    if (min_val >= 0) {
        downYdivsion = 0;
    }
    if (max_val <= 0) {
        upYdivsion = 0;
    }
    if(maxV == 0){
        upYdivsion = 2;
        downYdivsion = 0;
        moneySep = 100;
    }
    Ydivision = upYdivsion+downYdivsion;

}

#pragma mark 添加虚线
- (void)setLineDash{
    for (NSInteger i = 0;i <= upYdivsion; i++ ) {
        CAShapeLayer * dashLayer = [CAShapeLayer layer];
        dashLayer.strokeColor = [UIColor whiteColor].CGColor;
        dashLayer.fillColor = [[UIColor clearColor] CGColor];
        // 默认设置路径宽度为0，使其在起始状态下不显示
        dashLayer.lineWidth = 1.0;
        
        
        UILabel * label1 = (UILabel*)[self viewWithTag:5000 + i];
        
        UIBezierPath * path = [[UIBezierPath alloc]init];
        path.lineWidth = 1.0;
        UIColor * color = [UIColor blueColor];
        
        [color set];
        [path moveToPoint:CGPointMake( 0, label1.center.y - bounceY)];
        [path addLineToPoint:CGPointMake(self.frame.size.width - 2*bounceX,label1.center.y - bounceY)];
        CGFloat dash[] = {10,10};
        [path setLineDash:dash count:2 phase:10];
        [path stroke];
        dashLayer.path = path.CGPath;
        [self.gradientBackgroundView.layer addSublayer:dashLayer];
    }
    for (NSInteger i = 0;i < downYdivsion; i++ ) {
        CAShapeLayer * dashLayer = [CAShapeLayer layer];
        dashLayer.strokeColor = [UIColor whiteColor].CGColor;
        dashLayer.fillColor = [[UIColor clearColor] CGColor];
        // 默认设置路径宽度为0，使其在起始状态下不显示
        dashLayer.lineWidth = 1.0;
        
        
        UILabel * label1 = (UILabel*)[self viewWithTag:6000 + i];
        
        UIBezierPath * path = [[UIBezierPath alloc]init];
        path.lineWidth = 1.0;
        UIColor * color = [UIColor blueColor];
        
        [color set];
        [path moveToPoint:CGPointMake( 0, label1.center.y - bounceY)];
        [path addLineToPoint:CGPointMake(self.frame.size.width - 2*bounceX,label1.center.y - bounceY)];
        CGFloat dash[] = {10,10};
        [path setLineDash:dash count:2 phase:10];
        [path stroke];
        dashLayer.path = path.CGPath;
        [self.gradientBackgroundView.layer addSublayer:dashLayer];
    }
    
    
}

#pragma mark 画折线图
- (void)dravLine{
    //计算每条分割线的距离
    float sep = (self.frame.size.height-bounceY*2)/Ydivision;
    //计算出x轴的y坐标
    float xDivison_y = self.frame.size.height-bounceY*2-sep*downYdivsion;
    
    
    UILabel * label = (UILabel*)[self viewWithTag:1000];
    UIBezierPath * path = [[UIBezierPath alloc]init];
    path.lineWidth = 1.0;
    self.path1 = path;
    UIColor * color = [UIColor greenColor];
    [color set];
    
    CGFloat value = [self.dataArr[0] floatValue];
    float max_v = absMax_value;
    int floor_max_v = floor(absMax_value);
    //x坐标是x轴标注的位置
    float x1 = label.frame.origin.x ;
    //y坐标 是根据当前高度对比坐标轴高度的比例算出y坐标
    float y1 ;
    if(value > 0){
        y1 = xDivison_y+bounceY-(value) /max_v*2*sep;
    }else{
        y1 = (fabs(value)) /max_v*2*sep+xDivison_y+bounceY;
    }
    if (floor_max_v == 0) {
        y1 = xDivison_y+bounceY;
    }
    
    
    [path moveToPoint:CGPointMake( x1 - bounceX, y1-bounceY  )];
    
    UIView *circle1 = [[UIView alloc]initWithFrame:CGRectMake(x1-2.5, y1-2.5, 5, 5)];
    circle1.tag = 3000+0;    //        circle.center = CGPointMake(x, y);
    
    circle1.backgroundColor = [UIColor whiteColor];
    circle1.layer.cornerRadius = 2.5;
    circle1.layer.masksToBounds = YES;
    [self addSubview:circle1];
    

    //创建折现点标记
    for (NSInteger i = 1; i< self.dataArr.count; i++) {
        UILabel * label1 = (UILabel*)[self viewWithTag:1000 + i];
        CGFloat value = [self.dataArr[i] floatValue];
        
        float x = label1.frame.origin.x;
        float y ;
        if(value > 0){
            y = xDivison_y+bounceY-(value) /max_v*2*sep;
        }else{
            y = (fabs(value)) /max_v*2*sep+xDivison_y+bounceY;
        }
        if (floor_max_v == 0) {
            y = xDivison_y+bounceY;
        }
        
        [path addLineToPoint:CGPointMake(x-bounceX,y-bounceY )];
        
        
        //画圆点
        UIView *circle = [[UIView alloc]initWithFrame:CGRectMake(x-2.5, y-2.5, 5, 5)];
        circle.tag = 3000+i;
        circle.backgroundColor = [UIColor whiteColor];
        circle.layer.cornerRadius = 2.5;
        circle.layer.shadowColor = [UIColor redColor].CGColor;
        circle.layer.shadowOffset = CGSizeMake(3, 0);
        circle.layer.shadowRadius = 100;
        circle.layer.shadowOpacity = 0.5;
        circle.clipsToBounds = YES;
        //        circle.layer.masksToBounds = YES;
        [self addSubview:circle];
        
    }
    // [path stroke];
    
    self.lineChartLayer = [CAShapeLayer layer];
    self.lineChartLayer.path = path.CGPath;
    self.lineChartLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.lineChartLayer.fillColor = [[UIColor clearColor] CGColor];
    // 默认设置路径宽度为0，使其在起始状态下不显示
    self.lineChartLayer.lineWidth = 0;
    self.lineChartLayer.lineCap = kCALineCapRound;
    self.lineChartLayer.lineJoin = kCALineJoinRound;
    
    [self.gradientBackgroundView.layer addSublayer:self.lineChartLayer];//直接添加导视图上
    //   self.gradientBackgroundView.layer.mask = self.lineChartLayer;//添加到渐变图层
    
}
#pragma mark 创建x轴的数据
- (void)createLabelX{
    CGFloat  month = 12;
    float sep = (self.frame.size.height-bounceY*2)/Ydivision;
    
    for (NSInteger i = 0; i < month; i++) {
        UILabel * LabelMonth = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width - 2*bounceX)/month * i + bounceX, self.frame.size.height-bounceY + bounceY*0.3-sep*downYdivsion, (self.frame.size.width - 2*bounceX)/month- 3, bounceY/2)];
        //       LabelMonth.backgroundColor = [UIColor greenColor];
        LabelMonth.tag = 1000 + i;
        LabelMonth.text = [NSString stringWithFormat:@"%ld月",i+1];
        LabelMonth.font = [UIFont systemFontOfSize:10];
        LabelMonth.textColor = [UIColor whiteColor];
        if(i % 2== 1)
            LabelMonth.hidden = YES;
        [self addSubview:LabelMonth];
    }
    
}
#pragma mark 创建y轴数据
- (void)createLabelY{
    float sep = (self.frame.size.height-bounceY*2)/Ydivision;
    //x轴的y坐标
    float xDivison_y = self.frame.size.height-bounceY*2-sep*downYdivsion;
    for (NSInteger i = 0; i <= upYdivsion; i++) {
        UILabel * labelYdivision = [[UILabel alloc]initWithFrame:CGRectMake(0, xDivison_y+bounceY-sep*i -bounceY/4.0, bounceX-5, bounceY/2.0)];
        //   labelYdivision.backgroundColor = [UIColor greenColor];
        labelYdivision.tag = 5000 + i;
        i == 0 ? labelYdivision.text = @"0":(labelYdivision.text = [NSString stringWithFormat:@"%.0ld",i*moneySep]);
        labelYdivision.textAlignment = NSTextAlignmentRight;
        labelYdivision.font = [UIFont systemFontOfSize:10];
        labelYdivision.textColor = [UIColor whiteColor];
        [self addSubview:labelYdivision];
    }
    for (NSInteger i = 0; i < downYdivsion; i++) {
        UILabel * labelYdivision = [[UILabel alloc]initWithFrame:CGRectMake(0, xDivison_y+bounceY-bounceY/4.0 +sep*(i+1), bounceX-5, bounceY/2.0)];
        //   labelYdivision.backgroundColor = [UIColor greenColor];
        labelYdivision.tag = 6000 + i;
        labelYdivision.textAlignment = NSTextAlignmentRight;
        labelYdivision.text = [NSString stringWithFormat:@"%.0ld",-1*(i+1)*moneySep];
        labelYdivision.font = [UIFont systemFontOfSize:10];
        labelYdivision.textColor = [UIColor whiteColor];
        [self addSubview:labelYdivision];
    }
    
}


#pragma mark 折现背景view
- (void)drawGradientBackgroundView {
    // 渐变背景视图（不包含坐标轴）
    self.gradientBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(bounceX, bounceY, self.bounds.size.width - bounceX*2, self.bounds.size.height - 2*bounceY)];
    self.gradientBackgroundView.backgroundColor = [UIColor blueColor];
    [self addSubview:self.gradientBackgroundView];
    
}




#pragma mark 显示折现动画
-(void)show{
    [self.lineChartLayer removeFromSuperlayer];
    for (NSInteger i = 0; i < 12; i++) {
        UILabel * label = (UILabel*)[self viewWithTag:3000 + i];
        [label removeFromSuperview];
    }

    
    [self dravLine];
    
    self.lineChartLayer.lineWidth = 2;
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 5;
    pathAnimation.repeatCount = 1;
    pathAnimation.removedOnCompletion = YES;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [self.lineChartLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}

@end
