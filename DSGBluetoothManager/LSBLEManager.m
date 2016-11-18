//
//  LSBLEManager.m
//  TenCount
//
//  Created by 刘爽 on 16/10/15.
//  Copyright © 2016年 redbear. All rights reserved.
//

#import "LSBLEManager.h"
#import "BLE.h"
@interface LSBLEManager()<BLEDelegate>
{
    
}

@property (nonatomic, assign) NSTimeInterval timeOut;
@property (nonatomic, strong) BLE *BLE;
@property (nonatomic, copy) LSBLEManagerBlock responseBlock;
@end
static id returnAlloc;

@implementation LSBLEManager

+ (instancetype)shared{
    
    return [[self alloc]init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    if (returnAlloc == nil) {
        @synchronized(self) {
            returnAlloc = [super allocWithZone:zone];
        }
    }
    return returnAlloc;
}

- (instancetype)init{
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.BLE = [[BLE alloc]init];
            [self.BLE controlSetup];
            self.BLE.delegate = self;
            self.centralManager = self.BLE.CM;
        });
    }
    return self;
}

- (void)setDiscoverTimeOut:(NSTimeInterval)time{
    self.timeOut = time;
}

- (BOOL)isLSBLEManagerConnected{
    return self.BLE.isConnected;
}

- (void)discoverPeripherals{
    [self.BLE findBLEPeripherals:self.timeOut ? self.timeOut : 5];
    [self.BLE.peripherals removeAllObjects];
}

- (void)connect2Peripheral:(CBPeripheral *)peripheral{

    [self.BLE connectPeripheral:peripheral];
    self.connectedPeripheral = self.BLE.activePeripheral;
}

- (void)disConnectPeripheral{
    [self.BLE.CM cancelPeripheralConnection:self.BLE.activePeripheral];
}

- (void)send:(NSData *)data response:(LSBLEManagerBlock)response{
    [self.BLE write:data];
    self.responseBlock = response;
}

- (void)send:(NSData *)data{
    [self.BLE write:data];
}
#pragma BLE -- delegate
- (void)bleDidConnect{
    
    if ([self.deleagte respondsToSelector:@selector(LSBLEManagerDeviceDidConnected)]) {
        [self.deleagte LSBLEManagerDeviceDidConnected];
    }
}
- (void)bleDidDisconnect{
    
    if ([self.deleagte respondsToSelector:@selector(LSBLEManagerDeviceDidDisConnected)]) {
        [self.deleagte LSBLEManagerDeviceDidDisConnected];
    }
}
- (void)bleDidReceiveData:(unsigned char *)data length:(int)length{
    
    
    if (self.responseBlock) {
        __weak LSBLEManager *weakSelf = self;
        weakSelf.responseBlock(data,length);
        weakSelf.responseBlock = nil;
    }else{
        if ([self.deleagte respondsToSelector:@selector(LSBLEManagerDeviceDidReceiveData:length:)]) {
            [self.deleagte LSBLEManagerDeviceDidReceiveData:data length:length];
        }
    }
}



- (void)bleDidDiscovered:(NSArray *)peripherals{
    if ([self.deleagte respondsToSelector:@selector(LSBLEManagerDeviceDidDiscovered:)]) {
        [self.deleagte LSBLEManagerDeviceDidDiscovered:peripherals];
        self.peripherals = peripherals;
    }
    
}
@end
