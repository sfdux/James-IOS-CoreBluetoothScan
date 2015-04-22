//
//  AppDelegate.m
//  BluetoothTool
//
//  Created by JamesMac on 2/10/15.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initBlutToothServiceCharacteristic];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Init methods
-(void)initBlutToothServiceCharacteristic{
    //    [BlueToothHelper shared]
    NSDictionary *blueToothServices;
    BlueToothService *serviceSerial = [BlueToothService new];
    BlueToothService *serviceSensor = [BlueToothService new];
    BlueToothService *serviceSettings = [BlueToothService new];
    BlueToothCharacteristic *characterSerialDataOutput = [BlueToothCharacteristic new];
    BlueToothCharacteristic *characterCommand = [BlueToothCharacteristic new];
    BlueToothCharacteristic *characterSensorData = [BlueToothCharacteristic new];
    BlueToothCharacteristic *characterMetaData = [BlueToothCharacteristic new];
    BlueToothCharacteristic *characterStreaming = [BlueToothCharacteristic new];
    BlueToothCharacteristic *characterLED = [BlueToothCharacteristic new];
    BlueToothCharacteristic *characterSleepMode = [BlueToothCharacteristic new];
    BlueToothCharacteristic *characterInact = [BlueToothCharacteristic new];
    BlueToothCharacteristic *characterSampleRate = [BlueToothCharacteristic new];
    BlueToothCharacteristic *characterAccelStatus = [BlueToothCharacteristic new];
    BlueToothCharacteristic *characterAccelRate = [BlueToothCharacteristic new];
    BlueToothCharacteristic *characterAccelRanage = [BlueToothCharacteristic new];
    BlueToothCharacteristic *characterGyroStatus = [BlueToothCharacteristic new];
    BlueToothCharacteristic *characterGyroRate = [BlueToothCharacteristic new];
    BlueToothCharacteristic *characterGyroRanage = [BlueToothCharacteristic new];
    BlueToothCharacteristic *characterMagStatus = [BlueToothCharacteristic new];
    BlueToothCharacteristic *characterMagRate = [BlueToothCharacteristic new];
    
    serviceSerial.serviceName = @"SerialPort";
    serviceSerial.serviceUUID = [CBUUID UUIDWithString:@"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"];
    serviceSerial.serviceDescription = @"Custom service {Sensor data and command}";
    
    serviceSensor.serviceName = @"SensorAndCommand";
    serviceSensor.serviceUUID = [CBUUID UUIDWithString:@"00000000-0008-A8BA-E311-F48C90364D99"];
    serviceSensor.serviceDescription = @"Custom service {Sensor data and command}";
    
    serviceSettings.serviceName = @"SettingsAndStatus";
    serviceSettings.serviceUUID = [CBUUID UUIDWithString:@"00000005-0008-A8BA-E311-F48C90364D99"];
    serviceSettings.serviceDescription = @"Custom service {Service settings and status}";
    
    characterSerialDataOutput.characteristicName = @"SerialDataOutput";
    characterSerialDataOutput.service = serviceSerial;
    characterSerialDataOutput.characteristicUUID = [CBUUID UUIDWithString:@"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"];
    characterSerialDataOutput.characteristicDescription = @"{Serial data output}";
    
    
    characterCommand.characteristicName = @"Command";
    characterCommand.service = serviceSensor;
    characterCommand.characteristicUUID = [CBUUID UUIDWithString:@"00000001-0008-A8BA-E311-F48C90364D99"];
    characterCommand.characteristicDescription = @"{Enumerated command input}";
    
    characterSensorData.characteristicName = @"SensorData";
    characterSensorData.service = serviceSensor;
    characterSensorData.characteristicUUID = [CBUUID UUIDWithString:@"00000002-0008-A8BA-E311-F48C90364D99"];
    characterSensorData.characteristicDescription = @"{Sensor data} accelerometer,gyroscope, magnetometer";
    
    characterMetaData.characteristicName = @"MetaData";
    characterMetaData.service = serviceSensor;
    characterMetaData.characteristicUUID = [CBUUID UUIDWithString:@"00000004-0008-A8BA-E311-F48C90364D99"];
    characterMetaData.characteristicDescription = @"￼{Meta data} altimeter, temperature, battery";
    
    characterStreaming.characteristicName = @"Streaming";
    characterStreaming.service = serviceSettings;
    characterStreaming.characteristicUUID = [CBUUID UUIDWithString:@"00000006-0008-A8BA-E311-F48C90364D99"];
    characterStreaming.characteristicDescription = @"￼{Streaming}";
    
    characterLED.characteristicName = @"LED";
    characterLED.service = serviceSettings;
    characterLED.characteristicUUID = [CBUUID UUIDWithString:@"00000007-0008-A8BA-E311-F48C90364D99"];
    characterLED.characteristicDescription = @"￼{LED}";
    
    characterSleepMode.characteristicName = @"SleepMode";
    characterSleepMode.service = serviceSettings;
    characterSleepMode.characteristicUUID = [CBUUID UUIDWithString:@"00000008-0008-A8BA-E311-F48C90364D99"];
    characterSleepMode.characteristicDescription = @"￼{Sleep mode}";
    
    characterInact.characteristicName = @"Inact";
    characterInact.service = serviceSettings;
    characterInact.characteristicUUID = [CBUUID UUIDWithString:@"00000009-0008-A8BA-E311-F48C90364D99"];
    characterInact.characteristicDescription = @"￼{Inact. threshold}";
    
    characterSampleRate.characteristicName = @"SampleRate";
    characterSampleRate.service = serviceSettings;
    characterSampleRate.characteristicUUID = [CBUUID UUIDWithString:@"0000000A-0008-A8BA-E311-F48C90364D99"];
    characterSampleRate.characteristicDescription = @"￼{Sample rate}";
    
    characterAccelStatus.characteristicName = @"AccelStatus";
    characterAccelStatus.service = serviceSettings;
    characterAccelStatus.characteristicUUID = [CBUUID UUIDWithString:@"0000000B-0008-A8BA-E311-F48C90364D99"];
    characterAccelStatus.characteristicDescription = @"￼{Accel. on}";
    
    characterAccelRate.characteristicName = @"AccelRate";
    characterAccelRate.service = serviceSettings;
    characterAccelRate.characteristicUUID = [CBUUID UUIDWithString:@"0000000C-0008-A8BA-E311-F48C90364D99"];
    characterAccelRate.characteristicDescription = @"￼{Accel. rate}";
    
    characterAccelRanage.characteristicName = @"AccelRanage";
    characterAccelRanage.service = serviceSettings;
    characterAccelRanage.characteristicUUID = [CBUUID UUIDWithString:@"0000000D-0008-A8BA-E311-F48C90364D99"];
    characterAccelRanage.characteristicDescription = @"￼{Accel. ranage}";
    
    characterGyroStatus.characteristicName = @"GyroStatus";
    characterGyroStatus.service = serviceSettings;
    characterGyroStatus.characteristicUUID = [CBUUID UUIDWithString:@"0000000E-0008-A8BA-E311-F48C90364D99"];
    characterGyroStatus.characteristicDescription = @"￼{Gyro. on}";
    
    characterGyroRate.characteristicName = @"GyroRate";
    characterGyroRate.service = serviceSettings;
    characterGyroRate.characteristicUUID = [CBUUID UUIDWithString:@"0000000F-0008-A8BA-E311-F48C90364D99"];
    characterGyroRate.characteristicDescription = @"￼{Gyro. rate}";
    
    characterGyroRanage.characteristicName = @"GyroRanage";
    characterGyroRanage.service = serviceSettings;
    characterGyroRanage.characteristicUUID = [CBUUID UUIDWithString:@"00000010-0008-A8BA-E311-F48C90364D99"];
    characterGyroRanage.characteristicDescription = @"￼{Gyro.ranage}";
    
    characterMagStatus.characteristicName = @"MagStatus";
    characterMagStatus.service = serviceSettings;
    characterMagStatus.characteristicUUID = [CBUUID UUIDWithString:@"00000011-0008-A8BA-E311-F48C90364D99"];
    characterMagStatus.characteristicDescription = @"￼{Mag. status}";
    
    characterMagRate.characteristicName = @"MagRate";
    characterMagRate.service = serviceSettings;
    characterMagRate.characteristicUUID = [CBUUID UUIDWithString:@"00000012-0008-A8BA-E311-F48C90364D99"];
    characterMagRate.characteristicDescription = @"￼{Mag. rate}";
    
    serviceSerial.characteristics = @{
                                      @"CharacterSerialDataOutput": characterSerialDataOutput};
    
    serviceSensor.characteristics = @{
                                      @"Command": characterCommand,
                                      @"SensorData": characterSensorData,
                                      @"MetaData": characterMetaData};
    
    serviceSettings.characteristics = @{
                                        @"Streaming": characterStreaming,
                                        @"LED": characterLED,
                                        @"SleepMode": characterSleepMode,
                                        @"Inact": characterInact,
                                        @"SampleRate": characterSampleRate,
                                        @"AccelStatus": characterAccelStatus,
                                        @"AccelRate": characterAccelRate,
                                        @"AccelRanage": characterAccelRanage,
                                        @"GyroStatus": characterGyroStatus,
                                        @"GyroRate": characterGyroRate,
                                        @"GyroRanage": characterGyroRanage,
                                        @"MagStatus": characterMagStatus,
                                        @"MagRate": characterMagRate};
    
    blueToothServices = @{
                          @"Serial": serviceSerial,
                          @"Sensor":serviceSensor,
                          @"Settings": serviceSettings};
    
    [BlueToothHelper shared].services = blueToothServices;
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.aglogica.tool.BluetoothTool" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BluetoothTool" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BluetoothTool.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
