//
//  BlueToothCharacteristic.h
//
//  Created by JamesMac on 5/26/14.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@class BlueToothService;

@interface BlueToothCharacteristic : NSObject
@property BlueToothService *service;
@property NSString *characteristicName;
@property CBUUID *characteristicUUID;
@property NSString *characteristicDescription;
@end
