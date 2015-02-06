//
//  KYProgressLayer.h
//  KYJellyAnimation
//
//  Created by Kitten Yang on 2/6/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@protocol KYProgressLayerDelegate <NSObject>

-(void)progressUpdateTo:(CGFloat)progress;

@end

@interface KYProgressLayer : CALayer

@property CGFloat progress;

@property(weak)id<KYProgressLayerDelegate>delegate;

@end
