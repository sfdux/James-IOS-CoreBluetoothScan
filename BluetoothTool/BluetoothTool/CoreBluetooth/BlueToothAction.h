//
//  BlueToothAction.h
//
//  Created by JamesMac on 5/27/14.
//

#import <Foundation/Foundation.h>
@class BlueToothService;
@class BlueToothCharacteristic;

typedef enum{
    ACCEL_STATUS = 0,
    ACCEL_RATE = 1,
    ACCEL_RANAGE = 2,
    GYRO_STATUS = 3,
    GYRO_RATE = 4,
    GYRO_RANAGE = 5,
    MAG_STATUS = 6,
    MAG_RATE = 7,
    SLEEP_MODE = 8
}BLUE_TOOTH_SETTINGS_TYPE;

typedef enum{
    WRITE = 0,
    READ = 1,
    NOTIFY = 2
} BLUE_TOOTH_ACTION_TYPE;

@interface BlueToothAction : NSObject
@property (nonatomic, strong) BlueToothService *currentService;
@property (nonatomic, strong) BlueToothCharacteristic *currentCharacteristic;
@property (nonatomic) BLUE_TOOTH_SETTINGS_TYPE settingsType;
@property (nonatomic) BLUE_TOOTH_ACTION_TYPE currentActionType;
@property (nonatomic) uint16_t writingValue;
@end
