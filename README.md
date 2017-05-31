# LineChart
ios 折线图绘制
总结一下最近项目中需要使用到的折线图的展示，首先说下折线图演示的一下几种情况
1 当数据出现有正数和负数，那么折现就要x 轴的上方和下面都要展示
2 当数据只为正数，折线只在x轴上方演示
3 当数据只为负数 ，折现则只在x轴下方演示
4 当数据全为0 ，那么就只显示一条横线（具体演示如下图所示）
![Untitled.gif](http://upload-images.jianshu.io/upload_images/1306084-d2242d0028592772.gif?imageMogr2/auto-orient/strip)

需求大致了解，那么我先把需求细化（这个demo 上下方最多只画两条线）
1 如何画数据分割线呢，每一条线应该标多大呢

(1)首先我们分析画线会有大体几种情况，如果有可能会有如下几种情形
先拿一正一负来举例c
12 个月的数据10，200,-3000,400,1300,-801,650
12个月的数据10，200,-3000,400,1600,-801,650
12个月的数据10，200,3000,400,-1600,-801,650
12 个月的数据10，200,3000,400,-1300,-801,650

我们要根据不同的情况画出y轴显示对应的分割线如下图
![Untitled1.gif](http://upload-images.jianshu.io/upload_images/1306084-35f0d70ca9da1539.gif?imageMogr2/auto-orient/strip)
因此该显示多少条分割线是根据数据来判断来看看具体实现的代码

``` python
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
```

上面的代码主要是计算x轴上下方该显示的分割线，这里我用两个变量downYdivsion  upYdivsion ;
来记录x轴上下方的分割线的数量，当所有数据都不大于分割线的所标的数值，则不显示这条分割线。

接下来再看看绘画折线的部分，先上一下代码段
```
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
    
   //根据路径划线 
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
```
上面代码主要根据数据算出对应的x，y坐标，来描绘出路径

简书地址
http://www.jianshu.com/p/434501258ed1
