//
//  RWLockViewController.m
//  OCLearning
//
//  Created by yamyee on 2021/7/19.
//

#import "RWLockViewController.h"

@interface RWLockViewController()
{
    dispatch_queue_t _queue;
}
@property (nonatomic,strong)NSLock *rLock;
@property (nonatomic,strong)NSLock *wLock;
@property (nonatomic,assign)NSInteger count;
@end

@implementation RWLockViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    _queue = dispatch_queue_create("com.rwlock.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    
    _wLock = [[NSLock alloc]init];
    _rLock = [[NSLock alloc]init];
    _count = 0;
}

#pragma mark - dispatch_barrier_async

- (void)read
{
    dispatch_async(_queue, ^{
        
    });
}

- (void)write
{
    //栅栏函数，在此函数之前的异步任务全部执行完毕再走此函数
    dispatch_barrier_async(_queue, ^{
        
    });
}

#pragma mark - NSLock count

- (void)rLock_count
{
    [_rLock lock];
    _count ++;
    if (_count > 0) {
        [_wLock lock];
    }
    [_rLock unlock];
}

- (void)rUnlock_count
{
    [_rLock lock];
    _count --;
    if (_count <= 0) {
        [_wLock unlock];
    }
    [_rLock unlock];
}

- (void)read_count:(dispatch_block_t)block
{
    [self rLock_count];
    block();
    [self rUnlock_count];
}

- (void)wLock_count
{
    [_rLock lock];
}

- (void)wUnlock_count
{
    [_wLock unlock];
}

- (void)write_count:(dispatch_block_t)block
{
    [self wLock_count];
    block();
    [self wUnlock_count];
}

#pragma mark -

@end
