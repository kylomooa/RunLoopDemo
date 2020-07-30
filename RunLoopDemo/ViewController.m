//
//  ViewController.m
//  RunLoopDemo
//
//  Created by maoqiang on 2020/7/30.
//  Copyright © 2020 maoqiang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *excute;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//监听runloop的事件分发
-(void)addObserDemo{
    CFRunLoopObserverRef obser = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"RunLoop进入");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"RunLoop要处理Timers了");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"RunLoop要处理Sources了");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"RunLoop要休息了");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"RunLoop醒来了");
                break;
            case kCFRunLoopExit:
                NSLog(@"RunLoop退出了");
                break;

            default:
                break;
        }
    });
    
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), obser, kCFRunLoopCommonModes);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CFRunLoopStop(CFRunLoopGetCurrent());
    });
}


//阻塞线程，等待返回值
-(NSInteger)asyncDemo{
    
    __block NSInteger i = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        i = 10;
        CFRunLoopStop(CFRunLoopGetCurrent());
    });
    
    if (i != 10) {
        NSLog(@"i = %@",@(i));
        CFRunLoopRun();
        NSLog(@"res");
    }
    
    return i;
}

- (IBAction)btnAction:(id)sender {
//    [self addObserDemo];
    NSLog(@"result = %@",@([self asyncDemo]));
}
@end
