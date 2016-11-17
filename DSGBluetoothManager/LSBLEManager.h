//
//  LSBLEManager.h

//
//  Created by 刘爽 on 16/10/15.
//  Copyright © 2016年 redbear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLE.h"
@protocol LSBLEManagerDelegate <NSObject>
/**
 *  required Method,必须实现的方法
 */
@required
- (void)LSBLEManagerDeviceDidDiscovered:(NSArray *)peripherals;

@optional
- (void)LSBLEManagerDeviceDidConnected;
- (void)LSBLEManagerDeviceDidDisConnected;
- (void)LSBLEManagerDeviceDidReceiveData:(unsigned char *)dat length:(int)length;

@end

typedef void(^LSBLEManagerBlock)(unsigned char *s,unsigned int length);

@interface LSBLEManager : NSObject

@property (nonatomic, weak) id <LSBLEManagerDelegate> deleagte;
@property (nonatomic, strong) CBPeripheral *connectedPeripheral;
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) NSArray *peripherals;
/**
 *  单利对象，用来获取蓝牙管理器
 *
 *  @return 返回蓝牙管理器
 */
+ (LSBLEManager *)shared;
/**
 *  设置蓝牙搜索超时时间
 *
 *  @param time 时间
 */
- (void)setDiscoverTimeOut:(NSTimeInterval)time;

/**
 *  搜索蓝牙设备
 *  这个方法在需要搜索或者重新搜索蓝牙的时候调用即可；
 */
- (void)discoverPeripherals;
/**
 *  是否已连接
 *
 *  @return
 */
- (BOOL)isLSBLEManagerConnected;
/**
 *  connect to Peripheral
 */
- (void)connect2Peripheral:(CBPeripheral *)peripheral;
/**
 *  disconnect Peripheral
 */
- (void)disConnectPeripheral;
/**
 *  send data to peripheral with one times return
 */
- (void)send:(NSData *)data response:(LSBLEManagerBlock)response;
/**
 *  send data to peripheral with multiple return
 */
- (void)send:(NSData *)data;
@end
