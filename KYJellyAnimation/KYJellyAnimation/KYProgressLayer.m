//
//  KYProgressLayer.m
//  KYJellyAnimation
//
//  Created by Kitten Yang on 2/6/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "KYProgressLayer.h"

@implementation KYProgressLayer

-(id)initWithLayer:(id)layer{
    self = [super initWithLayer:layer];
    if (self) {
        KYProgressLayer *otherLayer = (KYProgressLayer *)layer;
        self.progress = otherLayer.progress;
        self.delegate = otherLayer.delegate;
    }
    return self;
}


//这个方法的意思是 当前属性改变是是否需要重绘？
//显然我们是需要重绘的。一旦属性progress改变，就要通知CALayer
//所以复写 needsDisplayForKey: 这样我们自定义的属性progress
+(BOOL)needsDisplayForKey:(NSString *)key{
    if ([key isEqualToString:@"progress"]) {
        return YES; //如果是我们自定义的属性progress改变了，那么就需要重绘
    }else{
        return [super needsDisplayForKey:key];  //否则，遵循父类
    }
}


//如果上面needsDisplayForKey方法重绘返回YES,那么就用这个方法来重绘
-(void)drawInContext:(CGContextRef)ctx{
    if(self.delegate){
        [self.delegate progressUpdateTo:self.progress];
    }
}



@end
