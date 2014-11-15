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

    // wait a second before changing values to make it easier to follow
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // duration is .3 seconds when not specified
        self.animatedLabel.text = @"300 apples";
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
