//
//  LFDrawView.m
//  LFImagePickerController
//
//  Created by LamTsanFeng on 2017/2/23.
//  Copyright © 2017年 LamTsanFeng. All rights reserved.
//

#import "LFDrawView.h"

NSString *const kLFDrawViewData = @"LFDrawViewData";

@interface LFDrawBezierPath : UIBezierPath

@property (nonatomic, strong) UIColor *color;

@end

@implementation LFDrawBezierPath


@end



@interface LFDrawView ()
{
    BOOL _isWork;
    BOOL _isBegan;
    BOOL _isFirstLine;

    CGPoint pts[5];// we now need to keep track of the four points of a Bezier segment and the first control point of the next segment
    
    uint ctr;
}
/** 笔画 */
@property (nonatomic, strong) NSMutableArray <LFDrawBezierPath *>*lineArray;
/** 图层 */
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *>*slayerArray;

@end

@implementation LFDrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

//- (void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    [[self.layer sublayers] enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        obj.frame = self.bounds;
//    }];
//}

- (void)customInit
{
    _lineWidth = 5.f;
    _lineColor = [UIColor redColor];
    _slayerArray = [@[] mutableCopy];
    _lineArray = [@[] mutableCopy];
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    self.exclusiveTouch = YES;
//    self.layer.anchorPoint = CGPointMake(0, 0);
//    self.layer.position = CGPointMake(0, 0);
}


#pragma mark - 创建图层
- (CAShapeLayer *)createShapeLayer:(LFDrawBezierPath *)path
{
    /** 1、渲染快速。CAShapeLayer使用了硬件加速，绘制同一图形会比用Core Graphics快很多。
     2、高效使用内存。一个CAShapeLayer不需要像普通CALayer一样创建一个寄宿图形，所以无论有多大，都不会占用太多的内存。
     3、不会被图层边界剪裁掉。
     4、不会出现像素化。 */
    
    CAShapeLayer *slayer = [CAShapeLayer layer];
    slayer.path = path.CGPath;
    slayer.backgroundColor = [UIColor clearColor].CGColor;
    slayer.fillColor = [UIColor clearColor].CGColor;
    slayer.lineCap = kCALineCapRound;
    slayer.lineJoin = kCALineJoinRound;
    slayer.strokeColor = path.color.CGColor;
    slayer.lineWidth = path.lineWidth;
    
    return slayer;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if ([event allTouches].count == 1) {
        _isWork = NO;
        _isBegan = YES;
        _isFirstLine = YES;
        //1、每次触摸的时候都应该去创建一条贝塞尔曲线
        LFDrawBezierPath *path = [LFDrawBezierPath new];
        //2、移动画笔
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        //设置线宽
        path.lineWidth = self.lineWidth;
        path.lineCapStyle = kCGLineCapRound; //线条拐角
        path.lineJoinStyle = kCGLineJoinRound; //终点处理
//        [path moveToPoint:point];
        //设置颜色
        path.color = self.lineColor;//保存线条当前颜色
        [self.lineArray addObject:path];
        
        CAShapeLayer *slayer = [self createShapeLayer:path];
        [self.layer addSublayer:slayer];
        [self.slayerArray addObject:slayer];
        
        ctr = 0;
        pts[ctr++] = point;
        
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (_isBegan || _isWork) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        UIView *superView = self.superview;
        while(superView) {
            if ([superView isKindOfClass:NSClassFromString(@"LFEditingView")]) {
                break;
            }
            else
            {
                superView = superView.superview;
            }
        }
        
        UIScrollView *scrollView = (UIScrollView *)superView;
        CGSize visibleSize = scrollView.visibleSize;
        CGPoint superPoint = [touch locationInView:superView];
        float zoomScale = scrollView.zoomScale;
        if(superPoint.x < scrollView.contentOffset.x)
        {
            point.x += (scrollView.contentOffset.x - superPoint.x)/zoomScale;
        }
        else if(superPoint.x > scrollView.contentOffset.x + visibleSize.width)
        {
            point.x -= (superPoint.x - (scrollView.contentOffset.x + visibleSize.width))/zoomScale;
        }
        
        if(superPoint.y < scrollView.contentOffset.y)
        {
            point.y += (scrollView.contentOffset.y - superPoint.y)/zoomScale;
        }
        else if(superPoint.y > scrollView.contentOffset.y + visibleSize.height)
        {
            point.y -= (superPoint.y - (scrollView.contentOffset.y + visibleSize.height))/zoomScale;
        }
        
        LFDrawBezierPath *path = self.lineArray.lastObject;
        NSLog(@"%f   %f",point.x,point.y);
        if (!CGPointEqualToPoint(path.currentPoint, point)) {
            if (_isBegan && self.drawBegan) self.drawBegan();
            if (self.drawProcess) self.drawProcess(point);
            _isBegan = NO;
            _isWork = YES;
            
            pts[ctr++] = point;
            if (ctr == 5) {
                [self drawLineWithRecordPoint];
            }
        }
    }
    
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    LFDrawBezierPath *path = self.lineArray.lastObject;
    if(!CGPointEqualToPoint(path.currentPoint, point)) {
        _isBegan = NO;
        _isWork = YES;
        
        pts[ctr++] = point;
    }
    
    [self drawLineWithRecordPoint];

    if (_isWork) {
        if (self.drawEnded) self.drawEnded();
    } else {
        if ((_isBegan)) {
            [self undo];
        }
    }
    _isBegan = NO;
    _isWork = NO;
    ctr = 0;
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_isWork) {
        if (self.drawEnded) self.drawEnded();
    } else {
        if ((_isBegan)) {
            [self undo];
        }
    }
    _isBegan = NO;
    _isWork = NO;
    ctr = 0;
    [super touchesCancelled:touches withEvent:event];
}

- (void)drawLineWithRecordPoint
{
    LFDrawBezierPath *path = self.lineArray.lastObject;
    if (_isFirstLine && ctr == 2) {
        [path moveToPoint:pts[0]];
        [path addLineToPoint:pts[1]];
    }
    else if (_isFirstLine && ctr == 3)
    {
        [path moveToPoint:pts[0]];
        [path addCurveToPoint:pts[2] controlPoint1:pts[0] controlPoint2:pts[1]];// this is how a Bezier curve is appended to a path. We are adding a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
    }
    else if (_isFirstLine && ctr == 4)
    {
        [path moveToPoint:pts[0]];
        [path addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]];// this is how a Bezier curve is appended to a path. We are adding a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
    }
    else if (ctr == 5)
    {
        _isFirstLine = NO;
        pts[3] = CGPointMake((pts[2].x+ pts[4].x)/2.0, (pts[2].y+ pts[4].y)/2.0);// move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment
        
        
        
        [path moveToPoint:pts[0]];
        
        [path addCurveToPoint:pts[3]controlPoint1:pts[1]controlPoint2:pts[2]];// add a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]

        // replace points and get ready to handle the next segment
        
        pts[0] = pts[3];
        
        pts[1] = pts[4];
        
        ctr = 2;
    }
    else
    {
        return;
    }
    
    CAShapeLayer *slayer = self.slayerArray.lastObject;
    slayer.path = path.CGPath;
    return;
}

- (BOOL)isDrawing
{
    return _isWork;
}

/** 是否可撤销 */
- (BOOL)canUndo
{
    return self.lineArray.count;
}

//撤销
- (void)undo
{
    [self.slayerArray.lastObject removeFromSuperlayer];
    [self.slayerArray removeLastObject];
    [self.lineArray removeLastObject];
}

//撤销所有
- (void)undoAll
{
    for (CAShapeLayer *obj in self.slayerArray) {
        [obj removeFromSuperlayer];
    }
    [self.slayerArray removeAllObjects];
    [self.lineArray removeAllObjects];
}
#pragma mark  - 数据
- (NSDictionary *)data
{
    if (self.lineArray.count) {
        return @{kLFDrawViewData:[self.lineArray copy]};
    }
    return nil;
}

- (void)setData:(NSDictionary *)data
{
    NSArray *lineArray = data[kLFDrawViewData];
    if (lineArray.count) {
        for (LFDrawBezierPath *path in lineArray) {
            CAShapeLayer *slayer = [self createShapeLayer:path];
            [self.layer addSublayer:slayer];
            [self.slayerArray addObject:slayer];
        }
        [self.lineArray addObjectsFromArray:lineArray];
    }
}

@end
