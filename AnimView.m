//
//  AnimView.m
//  AnimatedLabel
//
//  Created by Anders Borum on 09/12/14.
//  Copyright (c) 2014 Anders Borum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimView : UIView {
    NSTimeInterval lastChange; // when there hasn't been changes for a while,
                               // we stop looking in each run loop
    CGFloat lastRatio;
}
@property (nonatomic, copy) void (^change)(CGFloat ratio);

@end

@implementation AnimView

-(void)refreshAnimation {
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    
    // look for changes in presentation layer
    CGFloat opacity = [self.layer.presentationLayer opacity];
    CGFloat ratio = (opacity - 0.25) * 2.0;
    
    // fix starting ratio, where presentation layer hasn't yet updated opacity
    if(lastRatio < 0.0 && ratio < 0.0) ratio = 0;
    
    if(ratio != lastRatio) {
        lastChange = now;
        lastRatio = ratio;
        
        self.change(ratio);
    }
    
    // animation finishes when there has been no changes for a while
    if(now - lastChange >= 0.4) {
        // animation has finished, we clean up by removing view
        [self removeFromSuperview];
        return;
    }
    
    // schedule update for next run-loop
    [self performSelector:@selector(refreshAnimation) withObject:nil afterDelay:0];
}

-(instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;

        lastChange = [NSDate timeIntervalSinceReferenceDate];
        lastRatio = -1;
    }
    return self;
}

@end

@implementation UIView (AnimView)

-(void)change:(void (^)(CGFloat ratio))block {
    AnimView* animator = [AnimView new];
    animator.change = block;
    
    // make alpha value of animator change along with current animation block from 0.25 -> 0.75
    [UIView performWithoutAnimation:^{
        animator.alpha = 0.25;
        [self addSubview:animator];
    }];
    animator.alpha = 0.75;
    
    // start polling each run-loop
    [animator refreshAnimation];
}

@end
