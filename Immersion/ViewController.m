//
//  ViewController.m
//  Immersion
//
//  Created by HuangYiFeng on 7/20/15.
//  Copyright © 2015 HYF. All rights reserved.
//

#import "ViewController.h"

NSTimeInterval const DEFAULT_TIME_INTERVAL = 15 * 60;

@interface ViewController ()

//Model
@property(nonatomic, assign)NSInteger currentPhase;
@property(nonatomic, assign)NSTimeInterval currentPhaseRest;
@property(nonatomic, strong)NSTimer *timer;

//UI
@property(nonatomic, strong)IBOutletCollection(UILabel) NSArray *labels;

//- (void)initViewComponent;
//- (void)initModelComponent;

- (void)resetTimer;

- (IBAction)startTapHandler:(id)sender;
- (IBAction)stopTapHandler:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (void)resetTimer
{
    _currentPhase = 0;
    _currentPhaseRest = DEFAULT_TIME_INTERVAL;
    [_labels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel *label = (UILabel *)obj;
        label.text = 
    }];
}


#pragma mark - Action

- (void)startTapHandler:(id)sender
{
    
}

- (void)stopTapHandler:(id)sender
{
    
}

@end
