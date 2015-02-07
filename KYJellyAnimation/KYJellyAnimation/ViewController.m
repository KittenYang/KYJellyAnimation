//
//  ViewController.m
//  KYJellyAnimation
//
//  Created by Kitten Yang on 2/5/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "ViewController.h"
#import "JellyView.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *sideHelperView;
@property (strong, nonatomic) IBOutlet UIView *centerHelperView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sideHelperViewTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *centerHelperViewTopConstraint;

@property (strong, nonatomic) IBOutlet JellyView *jellyView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *jellyViewTopConstraint;


@property (nonatomic,strong) CADisplayLink *displayLink;
@property  NSInteger animationCount; // 动画的数量


//以上两个Constraint是 [小方块顶部]-[父视图底部] 的距离
@end

@implementation ViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.animationCount = 0;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.animationCount = 0;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sideHelperViewTopConstraint.constant   = 0;
    self.centerHelperViewTopConstraint.constant = 0;
    self.jellyViewTopConstraint.constant        = 0;
    
    self.sideHelperView.hidden   = YES;
    self.centerHelperView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
- (IBAction)hitMeClicked:(id)sender {
    
    CGFloat actionSheetHeight = CGRectGetHeight(self.jellyView.frame);
    CGFloat hiddenTopMargin   = 0;                  //隐藏在下面的时候，这个距离为0
    CGFloat showedTopMargin   = -actionSheetHeight; //滑到上面的时候，这个距离就是ActionSheet的高度
    CGFloat newTopMargin      = abs(self.centerHelperViewTopConstraint.constant - hiddenTopMargin) < 1 ? showedTopMargin : hiddenTopMargin;
    //如果中间那个辅助小方块藏在下面时，那么它的下一个位置就是在（-actionSheetHeight）的位置，所以，设置新的约束值（newTopMargin = -actionSheetHeight）,即：（newTopMargin = showedTopMargin）;
    //只要小方块在上方，那么它的下一个位置就是回到底部隐藏的位置，也就是新的约束值newTopMargin ＝ hiddenTopMargin.
    
    
    //先处理旁边那个辅助方块的约束
    self.sideHelperViewTopConstraint.constant = newTopMargin;
    [self beforeAnimation];
    [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.9f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        [self.sideHelperView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self finishAnimation];
    }];
    
    //再处理中间那个辅助方块的约束
    self.centerHelperViewTopConstraint.constant = newTopMargin;
    [self beforeAnimation];
    [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:2.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        [self.centerHelperView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self finishAnimation];
    }];
    



    
    //方法二:使用-drawInContext:实时绘制
    /*
    KYProgressLayer *progresslayer = [KYProgressLayer layer];
    progresslayer.frame = self.view.frame;
    progresslayer.delegate = self;
    [self.view.layer addSublayer:progresslayer];
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"progress"];
    anim.duration  =  0.5;
    anim.beginTime = 0;
    anim.fromValue = @(0);
    anim.toValue   = @(1);
    anim.fillMode  = kCAFillModeForwards; //当动画结束后,layer会一直保持着动画最后的状态
    anim.removedOnCompletion = NO;//不能把这个动画移除
    [progresslayer addAnimation:anim forKey:@"progress"];
     */
}


//方法一:使用 CADisplayLink 实时绘制
//动画之前调用
-(void)beforeAnimation{
    if (self.displayLink == nil) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    self.animationCount ++;
}

//动画完成之后调用
-(void)finishAnimation{
    self.animationCount --;
    if (self.animationCount == 0) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

//实时刷新路径
-(void)displayLinkAction:(CADisplayLink *)dis{
    CALayer *sideHelperPresentationLayer   =  (CALayer *)[self.sideHelperView.layer presentationLayer];
    CALayer *centerHelperPresentationLayer =  (CALayer *)[self.centerHelperView.layer presentationLayer];
    
    CGPoint position = [[centerHelperPresentationLayer valueForKeyPath:@"position"]CGPointValue];
    
    CGRect centerRect = [[centerHelperPresentationLayer valueForKeyPath:@"frame"]CGRectValue];
    CGRect sideRect = [[sideHelperPresentationLayer valueForKeyPath:@"frame"]CGRectValue];
    
    NSLog(@"Center:%@",NSStringFromCGRect(centerRect));
    NSLog(@"Side:%@",NSStringFromCGRect(sideRect));
    

    CGFloat newJellyViewTopConstraint      =  position.y - CGRectGetMaxY(self.view.frame);


    self.jellyViewTopConstraint.constant = newJellyViewTopConstraint;
    [self.jellyView layoutIfNeeded];
    
    self.jellyView.sideToCenterDelta = centerRect.origin.y - sideRect.origin.y;
//    NSLog(@"%f",self.jellyView.sideToCenterDelta);
    [self.jellyView setNeedsDisplay];
    
    
}



//方法二实时绘制的方法
-(void)progressUpdateTo:(CGFloat)progress{
    //在这里写重绘的具体代码
}



@end






