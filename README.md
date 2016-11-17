# LSBLEManager    

这是我自己在做公司蓝牙项目的时候用到的库,项目完成之后,把它封装了一下,现在拿出来给大家分享;
## 它主要有以下几个特点
 1.使用简单,就算是完全没看过Apple API 文档的人都能秒上手;
 2.不用你再去关心CBCentralManager,还有系统API里面的各种逼逼,也不用去理会系统API的各种代理;
 3.蓝牙管理中心采用单例模式,在整个项目当中可以随时拿到当前的蓝牙设备;
 4.蓝牙的数据响应分为两种模式,第一种是发送一次数据就立即要得到数据的模式,第二种是,发送一次数据就开始不停的接收蓝牙返回的数据,发送的数据就像水龙头开关。

# English
This LSBLEManager framework is what I have use in my project for my company . After finish the project I decided to share this framework;
## It's mainly composed of following characteristics
 1.It's easy to use ,even you have never see the API documentation of Apple about Bluetooth,also you can use it to your project immediately;
 2.You could ignore the CBCentralManager,and the Apple's API,and you also could ignore the so much delegate about the system Bluetooth framework;
 3.Design the ManagerCenter by singleton pattern,you can get the current connected Bluetooth device immediately and everywhere!
 4.The Bluetooth data response contain two kinds,one of the kinds is that we could received data immediately by send something to peripheral,the other one is that we just only send a massage to peripheral once ,then we could received data endless;
 
# 使用方法/How to use
```

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
```
## 在搜索蓝牙之前记得设置代理,并且做好代理方法/before searching device must setting the delegate
```
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
```
这个几个代理方法是在日常的工作中使用强度非常高/those methods intensity of using is very high in daily work;
## 第一种使用场景,发送数据会立即返回数据/send data to peripheral will get return immediately
```
NSString *cmd = @"z;\r\n";
[[LSBLEManager shared] send:[cmd dataUsingEncoding:NSUTF8StringEncoding] response:^(unsigned char *s, unsigned int length) {
        NSString *str = [NSString stringWithCharacters:(unsigned short*)s length:length];
        NSLog(@"%@",str);
        NSLog(@"%s",__func__);
    }];
```
send 发送数据,response 为peripheral返回的数据
## 第二种使用场景,发送数据之后不停的接收/send data to peripheral and received data endless
```
NSString *cmd = @"g1;\r\n";
[[LSBLEManager shared] send:[cmd dataUsingEncoding:NSUTF8StringEncoding]];
接收数据在代理方法中,这个代理方法可以不停的响应peripheral发送的数据    
- (void)LSBLEManagerDeviceDidReceiveData:(unsigned char *)dat length:(int)length{
    NSLog(@"%s",__func__);
}
```