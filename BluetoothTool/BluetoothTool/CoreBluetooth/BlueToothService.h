//
//  BlueToothService.h
//
//  Created by JamesMac on 5/26/14.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BlueToothService : NSObject
@property NSString *serviceName;
@property CBUUID *serviceUUID;
@property NSDictionary *characteristics;
@property NSString *serviceDescription;
@end