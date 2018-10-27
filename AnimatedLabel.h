//
//  AnimatedLabel.h b
//  AnimatedLabel
//
//  Created by Anders Borum on 15/11/14.
//  Copyright (c) 2014 Anders Borum. All rights reserved.
//

  
#import <UIKit/UIKit.h>

@interface AnimatedLabel : UILabel

// Changes are animated when called inside animation block and change between
// current text and new text allows animation (animationContextFrom: returns non-nil)
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
