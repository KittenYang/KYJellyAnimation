//
//  JellyView.m
//  KYJellyAnimation
//
//  Created by Kitten Yang on 2/6/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "JellyView.h"



@implementation JellyView{
    UIColor *fillColor;

}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.sideToCenterDelta = 0;
        fillColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    CGFloat yOffset = 30.0;
    CGFloat width   = CGRectGetWidth(rect);
    CGFloat height  = CGRectGetHeight(rect);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0, yOffset)]; //去设置初始线段的起点
    CGPoint controlPoint = CGPointMake(width / 2, yOffset + self.sideToCenterDelta);
//    NSLog(@"controlPoint:%@",NSStringFromCGPoint(controlPoint));
    [path addQuadCurveToPoint:CGPointMake(width, yOffset) controlPoint:controlPoint];
    [path addLineToPoint:CGPointMake(width, height)];
    [path addLineToPoint:CGPointMake(0.0, height)];
    [path closePath];

    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path.CGPath);
    [fillColor set];
    CGContextFillPath(context);
}




@end
