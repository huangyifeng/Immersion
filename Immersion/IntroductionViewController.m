//
//  IntroductionViewController.m
//  Immersion
//
//  Created by HuangYiFeng on 7/23/15.
//  Copyright (c) 2015 HYF. All rights reserved.
//

#import "IntroductionViewController.h"

@interface IntroductionViewController ()

@property(nonatomic, weak)IBOutlet UIWebView *webView;

- (IBAction)close:(id)sender;

@end

@implementation IntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *urlString = @"http://www.zhihu.com/question/31877598/answer/53667346";
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (void)close:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
