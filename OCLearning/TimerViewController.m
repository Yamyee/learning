//
//  TimerViewController.m
//  OCLearning
//
//  Created by yamyee on 2021/7/7.
//

#import "TimerViewController.h"

#define WEAK(target) __weak typeof(target) weak##target = target;

static void runLoopOserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
//    kCFRunLoopEntry = (1UL << 0),                 0
//    kCFRunLoopBeforeTimers = (1UL << 1),          2
//    kCFRunLoopBeforeSources = (1UL << 2),         4
//    kCFRunLoopBeforeWaiting = (1UL << 5),         32
//    kCFRunLoopAfterWaiting = (1UL << 6),          64
//    kCFRunLoopExit = (1UL << 7),                  128
//    kCFRunLoopAllActivities = 0x0FFFFFFFU
    NSString *ac = @"";
    switch (activity) {
        case kCFRunLoopEntry:
            ac = @"kCFRunLoopEntry";
            break;
        case kCFRunLoopBeforeTimers:
            ac = @"kCFRunLoopBeforeTimers";
            break;
        case kCFRunLoopBeforeSources:
            ac = @"kCFRunLoopBeforeSources";
            break;
        case kCFRunLoopBeforeWaiting:
            ac = @"kCFRunLoopBeforeWaiting";
            break;
        case kCFRunLoopAfterWaiting:
            ac = @"kCFRunLoopAfterWaiting";
            break;
        case kCFRunLoopExit:
            ac = @"kCFRunLoopExit";
            break;
        case kCFRunLoopAllActivities:
            ac = @"kCFRunLoopAllActivities";
            break;
        default:
            break;
    }
    NSLog(@"current activity : %@",ac);
}

@interface TimerViewController ()
{
    dispatch_source_t _source;
    CFRunLoopObserverRef _observer;
}
@property (nonatomic,weak)NSTimer *timer;
@property (nonatomic,copy)void(^timerBlock)(NSTimer *_Nonnull);

@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.grayColor;
    
    _observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, runLoopOserverCallBack, NULL);
    CFRunLoopAddObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
    
    WEAK(self);
    ///scheduledTimerWithTimeInterval 自动加到runloop defaultMode
        //就算用weakself,依然会有内存泄漏
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakself selector:@selector(onTimer:) userInfo:nil repeats:YES];
    
    //用block 则不存在内存泄漏，调用路径都是runloop do timer
    //_timerBlock = nil;但是timerBlock 置空也不会有任何效果，timerBlock依然执行
    //timer 内存泄漏的原因是runloop 强引用了self / block
    //scheduledTimerWithTimeInterval 循环引用的解法一般可以用NSProxy ，不再赘述
//    _timerBlock = ^(NSTimer * _Nonnull timer){
//        [weakself performSelector:@selector(onTimer:) withObject:timer afterDelay:1];
//    };
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:_timerBlock];
    
    // dispatch_source_t 调用时机 kCFRunLoopAfterWaiting kCFRunLoopBeforeTimers 之间
    
    
    _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_source, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_source, ^{
        NSLog(@"i'm hear %@",weakself);
    });
    dispatch_resume(_source);
}

- (void)onTimer:(NSTimer *)timer
{
    NSLog(@"i'm hear %@",self);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    _timerBlock = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
