//
//  ViewController.m
//  DSGBLEManager
//
//  Created by 刘爽 on 16/10/26.
//  Copyright © 2016年 刘爽. All rights reserved.
//
#import "LSAnimationButton.h"
#import "ViewController.h"
#import "LSBLEManager.h"
#import "MBProgressHUD+HM.h"
@interface ViewController ()<LSBLEManagerDelegate,LSAnimationButtonDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger kMainTableViewRowNumbers;
    NSInteger selectedRow;
}
@property (nonatomic, strong) UITableView *mainTableView;
@end

@implementation ViewController

- (UITableView *)mainTableView{
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height / 2, self.view.bounds.size.width, self.view.bounds.size.height / 2) style:UITableViewStylePlain];
        [self.view addSubview:_mainTableView];
        _mainTableView.tableFooterView = [UIView new];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = [UIColor clearColor];
        
    }
    return _mainTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImageView *imageViewBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    imageViewBG.image = [UIImage imageNamed:@"BG.jpg"];
    [self.view addSubview:imageViewBG];
    kMainTableViewRowNumbers = 0;
    [LSBLEManager shared].deleagte = self;
    LSAnimationButton *button = [[LSAnimationButton alloc]initWithFrame:CGRectMake(100, 100, 200, 50)];
    [self.view addSubview:button];
    [button setTitle:@"搜索蓝牙" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.borderWidth = 2.0;
    button.delegate = self;
    button.backgroundColor = [UIColor purpleColor];
    button.borderColor = [UIColor purpleColor];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self mainTableView];
    
}

- (void)buttonAction:(LSAnimationButton *)button{
    [button startAnimation];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return kMainTableViewRowNumbers;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        CBPeripheral *p = [LSBLEManager shared].peripherals[indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@",p.name,p.identifier.UUIDString];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",@"Connect 2 Peripheral");
    selectedRow = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    [MBProgressHUD showMessage:@"连接蓝牙"];
    [[LSBLEManager shared] connect2Peripheral:[LSBLEManager shared].peripherals[indexPath.row]];
}

//- (void)buttonAction{
//    [[LSBLEManager shared]discoverPeripherals];
//}
//- (void)buttonAction2{
//    NSString *cmd = @"z;\r\n";
//    [[LSBLEManager shared] send:[cmd dataUsingEncoding:NSUTF8StringEncoding] response:^(unsigned char *s, unsigned int length) {
//        NSString *str = [NSString stringWithCharacters:(unsigned short*)s length:length];
//        NSLog(@"%@",str);
//        NSLog(@"%s",__func__);
//    }];
//}
//- (void)buttonAction3{
//    NSString *cmd = @"g1;\r\n";
//    [[LSBLEManager shared] send:[cmd dataUsingEncoding:NSUTF8StringEncoding]];
//}


- (void)LSBLEManagerDeviceDidConnected{
    NSLog(@"%s",__func__);
    [MBProgressHUD showSuccess:@"Connected Success"];
}
- (void)LSBLEManagerDeviceDidDiscovered:(NSArray *)peripherals{
    NSLog(@"%s",__func__);
    LSAnimationButton *button = [self.view viewWithTag:123];
    [button stopAnimation];
    kMainTableViewRowNumbers = peripherals.count;
    
//    [[LSBLEManager shared] connect2Peripheral:peripherals.lastObject];
}
- (void)LSBLEManagerDeviceDidReceiveData:(unsigned char *)dat length:(int)length{
    NSLog(@"%s",__func__);
    NSLog(@"%s",dat);
}
- (void)LSBLEManagerDeviceDidDisConnected{
    NSLog(@"%s",__func__);
}

- (void)LSAnimationButtonDidStartAnimation:(LSAnimationButton *)AnimationButton{
    [[LSBLEManager shared] discoverPeripherals];
    AnimationButton.tag = 123;
}
- (void)LSAnimationButtonDidFinishAnimation:(LSAnimationButton *)AnimationButton{
    [_mainTableView reloadData];
}
@end
