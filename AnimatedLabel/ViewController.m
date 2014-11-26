//
//  ViewController.m
//  AnimatedLabel
//
//  Created by Anders Borum on 15/11/14.
//  Copyright (c) 2014 Anders Borum. All rights reserved.
//

#import "ViewController.h"
#import "AnimatedLabel.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet AnimatedLabel *animatedLabel;

@end

@implementation ViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // wait between animations to make it easier to follow
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:2 animations:^{
            self.animatedLabel.text = @"400 apples";
            self.animatedLabel.center = CGPointMake(self.animatedLabel.center.x, 400);
        }];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:3 delay:0
             usingSpringWithDamping:0.4 initialSpringVelocity:-1 options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.animatedLabel.text = @"100 apples";
                             self.animatedLabel.center = CGPointMake(self.animatedLabel.center.x, 100);
                         } completion:nil];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
