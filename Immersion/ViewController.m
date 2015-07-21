//
//  ViewController.m
//  Immersion
//
//  Created by HuangYiFeng on 7/20/15.
//  Copyright © 2015 HYF. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Util.h"

NSTimeInterval const DEFAULT_TIME_INTERVAL = 15 * 60;
NSString const *IMMERSION_NOW_INTERVAL = @"immersion_now_interval";

@interface ViewController ()

//Model
@property(nonatomic, assign)NSInteger currentPhase;
@property(nonatomic, assign)NSTimeInterval currentPhaseRest;
@property(nonatomic, strong)NSTimer *timer;
@property(nonatomic, assign)BOOL isRunning;

//UI
@property(nonatomic, strong)IBOutletCollection(UILabel) NSArray *labels;

//- (void)initViewComponent;
//- (void)initModelComponent;

- (void)resetTimer;
- (void)startTimer;
- (void)resumeApp;
- (void)registerLocalNotification;

- (IBAction)startTapHandler:(id)sender;
- (IBAction)stopTapHandler:(id)sender;
- (void)timerHandler;
- (void)showAlert:(NSString *)message;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resumeApp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (void)resetTimer
{
    _isRunning = NO;
    _currentPhase = 0;
    _currentPhaseRest = DEFAULT_TIME_INTERVAL;
    NSString *timeString = [NSString stringFromTimeInterval:DEFAULT_TIME_INTERVAL];
    [_labels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel *label = (UILabel *)obj;
        label.text = timeString;
    }];
    [_timer invalidate];
    
    //clear defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:IMMERSION_NOW_INTERVAL];
    [defaults synchronize];
    
    //local notification
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)startTimer
{
    if (_isRunning)
    {
        return;
    }
    
    _isRunning = YES;
    
    //For resume app
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSTimeInterval nowInterval  = [[NSDate date] timeIntervalSinceReferenceDate];
    [defaults setObject:[NSNumber numberWithDouble:nowInterval] forKey:IMMERSION_NOW_INTERVAL];
    [defaults synchronize];
    
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerHandler) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    
    [self registerLocalNotification];
}

- (void)resumeApp
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *intervalNum = [defaults objectForKey:IMMERSION_NOW_INTERVAL];
    NSTimeInterval lastInterval = [intervalNum doubleValue];
    
    if (!intervalNum || 0 == lastInterval)
    {
        [self resetTimer];
    }
    else
    {
        NSTimeInterval nowInterval = [[NSDate date] timeIntervalSinceReferenceDate];
        _currentPhase = (nowInterval - lastInterval) / DEFAULT_TIME_INTERVAL;
        if (3 < _currentPhase)
        {
            [self resetTimer];
        }
        else
        {
            _currentPhaseRest = DEFAULT_TIME_INTERVAL - ((int)(nowInterval - lastInterval) % (int)DEFAULT_TIME_INTERVAL);
            [_labels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                UILabel *label = (UILabel *)obj;
                if (idx < _currentPhase) {
                    label.text = [NSString stringFromTimeInterval:0];
                }else
                {
                    label.text = [NSString stringFromTimeInterval:DEFAULT_TIME_INTERVAL];
                }
            }];
            _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerHandler) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        }
    }
}

- (void)showAlert:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)registerLocalNotification
{
    void(^addOneLocalNotification)(NSInteger , NSDate *) = ^void(NSInteger idx, NSDate * date)
    {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = date;
        localNotification.alertBody = [NSString stringWithFormat:@"阶段%ld已完成", idx];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    };
    
    for (int i = 1; i < 5; i++)
    {
        NSDate *alertDate = [NSDate dateWithTimeIntervalSinceNow:DEFAULT_TIME_INTERVAL * i];
        addOneLocalNotification(i, alertDate);
    }
}

#pragma mark - Action

- (void)startTapHandler:(id)sender
{
    [self startTimer];
}

- (void)stopTapHandler:(id)sender
{
    [self resetTimer];
}

- (void)timerHandler
{
    if (0 == _currentPhaseRest)
    {
        if (_currentPhase == 3)
        {
            [self resetTimer];
            [self showAlert:@"计时器结束"];
        }
        else
        {
            _currentPhase++;
            _currentPhaseRest = DEFAULT_TIME_INTERVAL;
            NSString *message = [NSString stringWithFormat:@"阶段%ld已完成",_currentPhase];
            [self showAlert:message];
        }
    }
    _currentPhaseRest--;
    
    UILabel *label = [_labels objectAtIndex:_currentPhase];
    label.text = [NSString stringFromTimeInterval:_currentPhaseRest];
    
}

@end
