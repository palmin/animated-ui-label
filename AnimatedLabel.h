//
//  AnimatedLabel.h
//  AnimatedLabel
//
//  Created by Anders Borum on 15/11/14.
//  Copyright (c) 2014 Anders Borum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimatedLabel : UILabel

// change from previous text value to given one with animation in duration seconds.
-(void)setText:(NSString *)text duration:(NSTimeInterval)duration;

// calls setText:duration: with duration=0.3, but I would live to somehow get the duration
// value from the innermost animation block. If you know how, please write me at @palmin
-(void)setText:(NSString *)text;

// Determine whether animation makes sense and pre-calculate object that makes
// it faster to calculate texts in-between source- and target- texts.
// When nil is returned no animation is performed, and if there is nothing to
// cache the empty string could be returned.
//
// Default implementation assumes the texts starts with a number and then have
// a shared trailer such that "100 apples" -> "50 apples" has the trailer " apples"
// and half-way in animation the text will be "75 apples" and returns NSArray with
// NSNUmber for source and target value and shared trailing string as third element,
// but only textAtRatio:context:from:to: needs to worry about these details.
-(id)animationContextFrom:(NSString*)sourceText to:(NSString*)targetText;

// Override to control how text changes between source and target value,
// where ratio starts at 0.0 (all fromText) and ends at 1.0 (all targetText).
//
// Default implementation assumes the texts starts with a number and then have
// a shared trailer such that "100 apples" -> "50 apples" has the trailer " apples"
// and half-way in animation the text will be "75 apples".
-(NSString*)textAtRatio:(CGFloat)ratio context:(id)context
                   from:(NSString*)sourceText to:(NSString*)targetText;

@end
