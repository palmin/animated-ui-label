//
//  AnimView.h
//  AnimatedLabel
//
//  Created by Anders Borum on 09/12/14.
//  Copyright (c) 2014 Anders Borum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AnimView)

// change block is called such that ratio changes from 0.0 to 1.0 alongside UIView animation and will be called as long
// as the ratio keeps changing. Note that for spring animations the ratio can get below 0.0 and above 1.0.
//
// To animate text showing how far we are in animation you would do something like
//   [label change:^(CGFloat ratio) {
//      label.text = [NSString stringWithFormat: @"%.2f", ratio];
//   }];
-(void)change:(void (^)(CGFloat ratio))block;

@end
