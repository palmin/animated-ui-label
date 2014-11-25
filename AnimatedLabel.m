//
//  AnimatedLabel.m
//  AnimatedLabel
//
//  Created by Anders Borum on 15/11/14.
//  Copyright (c) 2014 Anders Borum. All rights reserved.
//

#import "AnimatedLabel.h"

@interface AnimatedLabel () {
    // we use this view to act upon implicit animations, by changing alpha value from 0.25 to 0.75
    // and deriving har far we are in animation (0.0 to 1.0) from this. We have som padding to allow
    // animation to get below and above 1.
    UIView* inner;
    
    NSTimeInterval lastChange; // when there hasn't been changes for a while,
                               // we stop looking in each run loop
    CGFloat lastRatio;
}

@property (nonatomic, strong) id animationContext;
@property (nonatomic, strong) NSString* sourceText;
@property (nonatomic, strong) NSString* targetText;

@end

@implementation AnimatedLabel

-(void)awakeFromNib {
    [super awakeFromNib];
    
    inner = [[UIView alloc] initWithFrame:CGRectZero];
    inner.backgroundColor = [UIColor clearColor];
    inner.opaque = NO;
    [self addSubview:inner];
    
    self.targetText = super.text;
}

-(void)setText:(NSString *)text {
    // we do not animate when there are no changes or no previous value
    if(super.text.length == 0 || [super.text isEqualToString:text]) {
        super.text = text;
        return;
    }
    
    // store information and precalculate context
    self.sourceText = super.text;
    self.targetText = text;
    lastChange = [NSDate timeIntervalSinceReferenceDate];
    self.animationContext = [self animationContextFrom:self.sourceText to:self.targetText];

    // trigger core animation changes
    [UIView performWithoutAnimation:^{
        lastRatio = 0;
        inner.alpha = 0.25;
    }];
    inner.alpha = 0.75;
    
    // we do not animate if there is no valid context
    if(self.animationContext == nil) {
        super.text = text;
        return;
    }

    // schedule update for next run-loop
    [self performSelector:@selector(refreshAnimation) withObject:nil afterDelay:0];
}

-(NSString*)text {
    return self.targetText;
}

-(id)animationContextFrom:(NSString*)sourceText to:(NSString*)targetText {
    // context is array containing source NSNumber, target NSNumber and shared
    // trailer NSString or nil if trailer does not match
    double sourceValue = 0, targetValue = 0;
    
    // get leading number and trailer from sourceText
    NSScanner* scanner = [NSScanner scannerWithString:sourceText];
    scanner.locale = [NSLocale currentLocale];
    if(![scanner scanDouble:&sourceValue]) return nil;
    NSString* sourceTrailer = [scanner.string substringFromIndex: scanner.scanLocation];
    
    // get leading number and trailer from targetText
    scanner = [NSScanner scannerWithString:targetText];
    scanner.locale = [NSLocale currentLocale];
    if(![scanner scanDouble:&targetValue]) return nil;
    NSString* targetTrailer = [scanner.string substringFromIndex: scanner.scanLocation];

    // make sure trailers match
    if(![sourceTrailer isEqualToString:targetTrailer]) {
        return nil;
    }
    
    // we have context
    return @[@(sourceValue), @(targetValue), sourceTrailer];
}


-(NSString*)textAtRatio:(CGFloat)ratio context:(id)context
               from:(NSString*)sourceText to:(NSString*)targetText {
    // unwrap context
    NSArray* array = context;
    NSNumber* source = array[0];
    NSNumber* target = array[1];
    NSString* trailer = array[2];
    
    // calculate interpolated value
    double value = source.doubleValue + ratio * (target.doubleValue - source.doubleValue);
    return [NSString stringWithFormat:@"%d%@", (int)value, trailer];
}

-(void)refreshAnimation {
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    
    // look for changes in presentation layer
    CGFloat opacity = [inner.layer.presentationLayer opacity];
    CGFloat ratio = (opacity - 0.25) * 2.0;
    if(ratio != lastRatio) {
        lastChange = now;
        lastRatio = ratio;
    }
    
    // animatio finishes when there has been no changes for a while
    if(now - lastChange >= 0.4) {
        // animation has finished
        super.text = self.targetText;
        return;
    }
    
    // insert transient value
    super.text = [self textAtRatio:ratio context:self.animationContext
                              from:self.sourceText to:self.targetText];
    
    // schedule update for next run-loop
    [self performSelector:@selector(refreshAnimation) withObject:nil afterDelay:0];
}

@end
