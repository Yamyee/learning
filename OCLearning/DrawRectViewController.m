//
//  DrawRectViewController.m
//  OCLearning
//
//  Created by yamyee on 2021/7/19.
//

#import "DrawRectViewController.h"
#import "DrawView.h"
@interface DrawRectViewController ()

@end

@implementation DrawRectViewController
- (void)loadView
{
    [super loadView];
    self.view = [[DrawView alloc]init];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
