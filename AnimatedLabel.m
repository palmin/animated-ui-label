//
//  AnimatedLabel.m
//  AnimatedLabel
//
//  Created by Anders Borum on 15/11/14.
//  Copyright (c) 2014 Anders Borum. All rights reserved.
//

#import "AnimatedLabel.h"

@interface AnimatedLabel ()
@property (nonatomic, assign) NSTimeInterval animationStarted;
@property (nonatomic, assign) NSTimeInterval animationDuration;

@property (nonatomic, strong) id animationContext;
@property (nonatomic, strong) NSString* sourceText;
@property (nonatomic, strong) NSString* targetText;

@end

@implementation AnimatedLabel

-(void)awakeFromNib {
    [super awakeFromNib];
    self.targetText = super.text;
}

-(void)setText:(NSString *)text duration:(NSTimeInterval)duration {
    // we do not start animation when animation has no length
    if(duration <= 0.0) {
        super.text = text;
        return;
    }

    // we do not animate when there are no changes or no previous value
    if(super.text.length == 0 || [super.text isEqualToString:text]) {
        super.text = text;
        return;
    }
    
    // store information and precalculate context
    self.sourceText = super.text;
    self.targetText = text;
    self.animationDuration = duration;
    self.animationStarted = [NSDate timeIntervalSinceReferenceDate];
    self.animationContext = [self animationContextFrom:self.sourceText to:self.targetText];
    
    // we do not animate if there is no valid context
    if(self.animationContext == nil) {
        super.text = text;
        return;
    }

    // schedule update for next run-loop
    [self performSelector:@selector(refreshAnimation) withObject:nil afterDelay:0];
}

-(void)setText:(NSString *)text {
    // TODO: It would be really nice to derive duration from current animation block
    [self setText:text duration:0.3];
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
    NSTimeInterval secondsGone = [NSDate timeIntervalSinceReferenceDate] - self.animationStarted;
    CGFloat ratio = secondsGone / self.animationDuration;
    
    if(ratio >= 1.0) {
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
