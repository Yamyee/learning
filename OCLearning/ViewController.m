//
//  ViewController.m
//  OCLearning
//
//  Created by yamyee on 2021/7/7.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSArray<NSDictionary<NSString *,NSString *> *> *datas;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 50;
    
    self.datas = @[@{@"title":@"定时器",@"cls":@"TimerViewController"},
                   @{@"title":@"读写锁",@"cls":@"RWLockViewController"},
                   @{@"title":@"异步绘制",@"cls":@"DrawRectViewController"}
    ];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    cell.textLabel.text = self.datas[indexPath.row][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cls = self.datas[indexPath.row][@"cls"];
    UIViewController *vc = [[NSClassFromString(cls) alloc]init];
    vc.title = self.datas[indexPath.row][@"title"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIViewController *vc = [[NSClassFromString(@"TimerViewController") alloc]init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}
@end
