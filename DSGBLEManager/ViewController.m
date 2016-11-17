//
//  ViewController.m
//  DSGBLEManager
//
//  Created by 刘爽 on 16/10/26.
//  Copyright © 2016年 刘爽. All rights reserved.
//

#import "ViewController.h"
#import "LSBLEManager.h"
@interface ViewController ()<LSBLEManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [LSBLEManager shared].deleagte = self;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
    [self.view addSubview:button];
    [button setTitle:@"dianjifasasasasasa" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(100, 200, 150, 50)];
    [self.view addSubview:button2];
    [button2 setTitle:@"2342342342342" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonAction2) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(100, 300, 150, 50)];
    [self.view addSubview:button3];
    [button3 setTitle:@"csedfsdserfcvsdcve" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(buttonAction3) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated{
    [[LSBLEManager shared]discoverPeripherals];
}
- (void)buttonAction{
    [[LSBLEManager shared]discoverPeripherals];
}
- (void)buttonAction2{
    NSString *cmd = @"z;\r\n";
    [[LSBLEManager shared] send:[cmd dataUsingEncoding:NSUTF8StringEncoding] response:^(unsigned char *s, unsigned int length) {
        NSString *str = [NSString stringWithCharacters:(unsigned short*)s length:length];
        NSLog(@"%@",str);
        NSLog(@"%s",__func__);
    }];
}
- (void)buttonAction3{
    NSString *cmd = @"g1;\r\n";
    [[LSBLEManager shared] send:[cmd dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)LSBLEManagerDeviceDidConnected{
    NSLog(@"%s",__func__);
}
- (void)LSBLEManagerDeviceDidDiscovered:(NSArray *)peripherals{
    NSLog(@"%s",__func__);
    [[LSBLEManager shared] connect2Peripheral:peripherals.lastObject];
}
- (void)LSBLEManagerDeviceDidReceiveData:(unsigned char *)dat length:(int)length{
    NSLog(@"%s",__func__);
}
- (void)LSBLEManagerDeviceDidDisConnected{
    NSLog(@"%s",__func__);
}
@end
