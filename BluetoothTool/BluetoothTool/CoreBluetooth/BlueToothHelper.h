//
//  BlueToothHelper.h
//
//  Created by JamesMac on 5/20/14.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BlueToothAction.h"

@class BlueToothService;
@class BlueToothCharacteristic;

@protocol BlueToothHelperDelegate <NSObject>
@required
- (void)blueToothHelper: (CBCentralManagerState) state
          didNotSupported:(NSError *)error;

@optional
- (void)blueToothHelper: (CBPeripheral *)peripheral
          didDiscovered:(NSError *)error;

- (void)blueToothHelper:  (CBPeripheral *)peripheral
           didConnected:(NSError *)error;

- (void)blueToothHelper:  (CBPeripheral *)peripheral
           didFailToConnected:(NSError *)error;

- (void)blueToothHelper:  (CBPeripheral *)peripheral
     didWriteValue:(NSError *)error;

- (void)blueToothHelper:  (CBPeripheral *)peripheral
           didReadValue: (NSData *) value withError: (NSError *)error;
@end

typedef enum
{
    BLUETOOTH_STATUS_DISCONNECTED = 0,
    BLUETOOTH_STATUS_FAIL_TO_CONNECT = 1,
    BLUETOOTH_STATUS_CONNECTED = 2
}BLUE_TOOTH_STATUS;



@interface BlueToothHelper : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate> {
    BlueToothAction * _blueToothAction;
}
@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) NSMutableArray *discoveredPeripherals;
@property (nonatomic, strong) NSMutableArray *discoveredPeripheralIdentifiers;
@property (nonatomic, strong) NSDictionary *services;
@property (nonatomic, strong) id<BlueToothHelperDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *connectedPeripheralIdentifiers;
@property (nonatomic, strong) NSMutableArray *connectedPeripherals;
@property (nonatomic, strong) BlueToothAction *blueToothAction;
@property (nonatomic, strong) NSArray *retrievedPeripherals;
+ (BlueToothHelper *)shared;
- (void) startScan;
- (void) stopScan;
-(void) connectPeripheral:(CBPeripheral *)peripheral;
-(BOOL) reconnectPeripheral: (NSUUID*) peripheralIdentifier;
-(void) reconnectPeripherals: (NSArray*) peripheralIdentifiers;
- (BOOL) supportLEHardware;
-(void) changeSettings: (CBPeripheral *)  peripheral settingsType: (BLUE_TOOTH_SETTINGS_TYPE) settingsType settingsValue: (uint16_t) settingsValue;
-(void) getSettings: (CBPeripheral *)  peripheral settingsType: (BLUE_TOOTH_SETTINGS_TYPE) settingsType;
-(void) sendCommand: (CBPeripheral *)  peripheral command: (uint16_t) command;
-(void) subscriptSensorData: (CBPeripheral *) peripheral;
//-(NSArray*) knownPeripheral: (NSArray *) peripheralIdentifiers;
//-(NSArray*) connectedPeripheral: (NSArray *) peripheralIdentifiers;
@end
