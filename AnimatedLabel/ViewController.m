//
//  ViewController.m
//  AnimatedLabel
//
//  Created by Anders Borum on 15/11/14.
//  Copyright (c) 2014 Anders Borum. All rights reserved.
//

#import "ViewController.h"
#import "AnimView.h"

@interface ViewController ()

@property (nonatomic, assign) int state;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textTop;

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIView* box1;
@property (strong, nonatomic) IBOutlet UIView* box2;

@end

@implementation ViewController

- (IBAction)tap:(UITapGestureRecognizer*)tap {
    if(tap.state != UIGestureRecognizerStateRecognized) return;
    
    self.state = self.state + 1;
    switch (self.state % 5) {
        case 1:
            [self writerAnim];
            break;
            
        case 2:
            [self easingAnim];
            break;

        case 3:
            [self springAnim];
            break;

        case 4:
            [self fadeAnim1];
            break;

        case 0:
            [self fadeAnim2];
            break;
    }
}

- (void)writerAnim {
    NSString* text = @"100 apples";

    [UIView animateWithDuration:3 animations:^{
        self.box1.backgroundColor = self.box2.backgroundColor = [UIColor blackColor];

        [self.label change:^(CGFloat ratio) {
            self.label.text = [text substringToIndex: fmax(0, ratio) * text.length];
        }];
    }];
}

- (void)easingAnim {
    [UIView animateWithDuration:2 animations:^{
        self.label.text = @"400 apples";
        self.textTop.constant = 400;
        [self.view layoutIfNeeded];
    }];
}

- (void)springAnim {
    [UIView animateWithDuration:3 delay:0
         usingSpringWithDamping:0.4 initialSpringVelocity:-1 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.label.text = @"100 apples";
                         self.textTop.constant = 100;
                         [self.view layoutIfNeeded];
                     } completion:nil];
}

-(UIColor*)interpolateColor:(UIColor*)source toColor:(UIColor*)target ratio:(CGFloat)ratio {
    CGFloat hue1, saturation1, brightness1, alpha1;
    [source getHue:&hue1 saturation:&saturation1 brightness:&brightness1 alpha:&alpha1];

    CGFloat hue2, saturation2, brightness2, alpha2;
    [target getHue:&hue2 saturation:&saturation2 brightness:&brightness2 alpha:&alpha2];

    return [UIColor colorWithHue:(1.0 - ratio) * hue1 + ratio * hue2
                      saturation:(1.0 - ratio) * saturation1 + ratio * saturation2
                      brightness:(1.0 - ratio) * brightness1 + ratio * brightness2
                           alpha:(1.0 - ratio) * alpha1 + ratio * alpha2];
}

-(void)fadeAnim1 {
    UIColor* source = self.box1.backgroundColor;
    UIColor* target = [UIColor orangeColor];

    [UIView animateWithDuration:3 animations:^{
        self.box1.backgroundColor = target;

        [self.box2 change:^(CGFloat ratio) {
            self.box2.backgroundColor = [self interpolateColor:source toColor:target ratio:ratio];
        }];
    }];
}

-(void)fadeAnim2 {
    UIColor* source = self.box1.backgroundColor;
    UIColor* target = [UIColor blueColor];
    
    [UIView animateWithDuration:5 animations:^{
        self.box1.backgroundColor = target;

        [self.box2 change:^(CGFloat ratio) {
            self.box2.backgroundColor = [self interpolateColor:source toColor:target ratio:ratio];
        }];
    }];
}

@end
