//
//  ViewController.m
//  DSLStepper
//
//  Created by 邓顺来 on 2017/2/25.
//  Copyright © 2017年 邓顺来. All rights reserved.
//

#import "ViewController.h"
#import "DSLStepper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DSLStepper *stepper = [[DSLStepper alloc] initWithFrame:CGRectMake(100, 100, 130, 30)];
    stepper.minimum = 10;
    stepper.maximum = 500;
    [self.view addSubview:stepper];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
