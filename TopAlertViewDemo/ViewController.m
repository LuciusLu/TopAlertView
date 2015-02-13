//
//  ViewController.m
//  TopAlertViewDemo
//
//  Created by 陆浩志 on 15-2-13.
//  Copyright (c) 2015年 MOZ. All rights reserved.
//

#import "ViewController.h"
#import "MozTopAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)btn1Action:(id)sender {
    [MozTopAlertView showWithType:MozAlertTypeInfo text:@"Info" parentView:self.view];
}

- (IBAction)btn2Action:(id)sender {
    MozTopAlertView *alertView = [MozTopAlertView showWithType:MozAlertTypeSuccess text:@"Success" parentView:self.view];
    alertView.dismissBlock = ^(){
        NSLog(@"dismissBlock");
    };
}

- (IBAction)btn3Action:(id)sender {
    [MozTopAlertView showWithType:MozAlertTypeWarning text:@"Warning" doText:@"undo" doBlock:^{
        
    } parentView:self.view];
}

- (IBAction)btn4Action:(id)sender {
    [MozTopAlertView showWithType:MozAlertTypeError text:@"Error" doText:@"undo" doBlock:^{
        
    } parentView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
