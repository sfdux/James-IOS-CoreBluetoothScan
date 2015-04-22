//
//  BlueToothHelper.m
//
//  Created by JamesMac on 5/20/14.
//

#import "BlueToothHelper.h"
#import "BlueToothService.h"
#import "BlueToothCharacteristic.h"

//static eventHardwareBlock privateBlock;
NSString * const centralManagerIdentifier = @"AgLogicaCentralManagerIdentifier";
NSString * const BTErrorDomain = @"BTErrorDomain";
@implementation BlueToothHelper {
    NSString *_stateMesssage;
}
@synthesize manager;
@synthesize discoveredPeripherals;
@synthesize services;
@synthesize delegate;
@synthesize connectedPeripherals;
@synthesize blueToothAction;
@synthesize retrievedPeripherals;

+ (BlueToothHelper *)shared{
    static BlueToothHelper *class;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        class = [BlueToothHelper new];
    });
    
    return class;
}

-(void)writeFile: (NSString*) text{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:@"test.txt"];
    
    NSString* writeContent = text;
    [writeContent writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

-(NSString*)readFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:@"test.txt"];
    
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    return  content;
}

- (id)init{
    if ((self = [super init]))
    {
        self.discoveredPeripherals = [NSMutableArray new];
        self.connectedPeripherals = [NSMutableArray new];
        self.connectedPeripheralIdentifiers = [NSMutableArray new];
//        self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{ CBCentralManagerOptionRestoreIdentifierKey:centralManagerIdentifier }];
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], CBCentralManagerOptionShowPowerAlertKey,
                                 centralManagerIdentifier,CBCentralManagerOptionRestoreIdentifierKey,
                                 nil];
        self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:options];
    }
    
    return self;
}

#pragma mark Blue tooth methods

- (BOOL)supportLEHardware{
    _stateMesssage = @"";
    
    switch ([self.manager state])
    {
        case CBCentralManagerStateUnsupported:
            _stateMesssage = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            _stateMesssage = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            _stateMesssage = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
            return TRUE;
        case CBCentralManagerStateUnknown:
        default:
            return false;
    }
    
    NSLog(@"Central manager state: %@", _stateMesssage);
    
    return false;
}

- (void)startScan{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:FALSE], CBCentralManagerScanOptionAllowDuplicatesKey,
                             nil];
    
    [manager scanForPeripheralsWithServices:nil options:options];
}

- (void)stopScan{
    [manager stopScan];
}

-(void) connectPeripheral:(CBPeripheral *)peripheral {
    [manager connectPeripheral:peripheral
                       options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBConnectPeripheralOptionNotifyOnNotificationKey]];
}

-(BOOL) reconnectPeripheral: (NSUUID*) peripheralIdentifier {
    self.retrievedPeripherals = [self.manager retrievePeripheralsWithIdentifiers:@[peripheralIdentifier]];
    
    if(self.retrievedPeripherals.count > 0) {
        
        if(((CBPeripheral*)self.retrievedPeripherals[0]).state == CBPeripheralStateDisconnected) {
            [self connectPeripheral: self.retrievedPeripherals[0]];
        }
        return true;
    }
    else {
        self.retrievedPeripherals =[self.manager retrieveConnectedPeripheralsWithServices:@[peripheralIdentifier]];
        if(self.retrievedPeripherals.count > 0) {
            [self connectPeripheral: self.retrievedPeripherals[0]];
            return true;
        }
        else {
            return false;
        }
    }
}

-(void) reconnectPeripherals: (NSArray*) peripheralIdentifiers {
    for(NSUUID *peripheralUUID in peripheralIdentifiers) {
        [self reconnectPeripheral: peripheralUUID];
    }
}

//-(NSArray*) knownPeripheral: (NSArray*)peripheralIdentifiers{
//    return [manager retrievePeripheralsWithIdentifiers:peripheralIdentifiers];
//}
//
//-(NSArray*) connectedPeripheral: (NSArray*)peripheralIdentifiers{
//    return [manager retrieveConnectedPeripheralsWithServices:peripheralIdentifiers];
//}

-(void)changeSettings: (CBPeripheral *)  peripheral settingsType: (BLUE_TOOTH_SETTINGS_TYPE) settingsType settingsValue: (uint16_t) settingsValue{
    self.blueToothAction = [BlueToothAction new];
    self.blueToothAction.currentService = self.services[@"Settings"];
    self.blueToothAction.currentActionType = WRITE;
    self.blueToothAction.settingsType = settingsType;
    self.blueToothAction.writingValue = settingsValue;
    switch (settingsType) {
        case GYRO_STATUS:
            self.blueToothAction.currentCharacteristic =self.blueToothAction.currentService.characteristics[@"GyroStatus"];
            break;
        case MAG_STATUS:
            self.blueToothAction.currentCharacteristic =self.blueToothAction.currentService.characteristics[@"MagStatus"];
            break;
        default:
            self.blueToothAction.currentCharacteristic =self.blueToothAction.currentService.characteristics[@"AccelStatus"];
            break;
    }
    [peripheral discoverServices:@[self.blueToothAction.currentService.serviceUUID]];
//    [peripheral discoverServices:nil];
}

-(void) subscriptSensorData: (CBPeripheral *) peripheral {
    self.blueToothAction = [BlueToothAction new];
    self.blueToothAction.currentService = self.services[@"Sensor"];
    self.blueToothAction.currentActionType = NOTIFY;
    self.blueToothAction.currentCharacteristic =self.blueToothAction.currentService.characteristics[@"SensorData"];
    
    [peripheral discoverServices:@[self.blueToothAction.currentService.serviceUUID]];
}


-(void) getSettings: (CBPeripheral *)  peripheral settingsType: (BLUE_TOOTH_SETTINGS_TYPE) settingsType {
    self.blueToothAction = [BlueToothAction new];
    self.blueToothAction.currentService = self.services[@"Settings"];
    self.blueToothAction.currentActionType = READ;
    self.blueToothAction.settingsType = settingsType;
    
    switch (settingsType) {
        case GYRO_STATUS:
            self.blueToothAction.currentCharacteristic =self.blueToothAction.currentService.characteristics[@"GyroStatus"];
            break;
        case MAG_STATUS:
            self.blueToothAction.currentCharacteristic =self.blueToothAction.currentService.characteristics[@"MagStatus"];
            break;
        case ACCEL_STATUS:
            self.blueToothAction.currentCharacteristic =self.blueToothAction.currentService.characteristics[@"AccelStatus"];
            break;
        default:
            self.blueToothAction.currentCharacteristic = self.blueToothAction.currentService.characteristics[@"SleepMode"];
            break;
    }
    [peripheral discoverServices:@[self.blueToothAction.currentService.serviceUUID]];
}

-(void)  sendCommand: (CBPeripheral *)  peripheral command: (u_int16_t) command {
    self.blueToothAction = [BlueToothAction new];
    self.blueToothAction.currentService = self.services[@"Sensor"];
    self.blueToothAction.currentActionType = WRITE;
    self.blueToothAction.writingValue = command;
    self.blueToothAction.currentCharacteristic = self.blueToothAction.currentService.characteristics[@"Command"];
    
    [peripheral discoverServices:@[self.blueToothAction.currentService.serviceUUID]];
    
}

#pragma mark CBManagerDelegate methods
/*
 Invoked whenever the central manager's state is updated.
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (![self supportLEHardware])
    {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:_stateMesssage forKey:NSLocalizedDescriptionKey];
        
        if([self.delegate respondsToSelector:@selector(blueToothHelper:didNotSupported:)]){
            [self.delegate blueToothHelper:[self.manager state]
                           didNotSupported:[NSError errorWithDomain:BTErrorDomain code:self.manager.state userInfo:details]];
        }
    }
    
//    [self writeFile:@"centralManagerDidUpdateState"];
    
}

/*
 Invoked when the central discovers peripheral while scanning.
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"Did discover peripheral. peripheral: %@ rssi: %@, UUID: %@ advertisementData: %@ ", peripheral, RSSI, peripheral.identifier.UUIDString, advertisementData);
    
    //Add the discovered peripherals to array.
    if(![self.discoveredPeripherals containsObject:peripheral]){
        [self.discoveredPeripherals addObject:peripheral];
    }
    //Invoke the delegate "blueToothHelper: didDiscovered:" method if it has been implemented.
    if ([self.delegate respondsToSelector:@selector(blueToothHelper: didDiscovered:)])
        [delegate blueToothHelper:peripheral didDiscovered:nil];
//    [self.manager stopScan];
//    //    //[manager retrievePeripherals:[NSArray arrayWithObject:(id)peripheral.UUID]];
//    [manager connectPeripheral:peripheral
//                       options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:centralManagerIdentifier]];
//
}

/*
 Invoked whenever a connection is succesfully created with the peripheral.
 Discover available services on the peripheral
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"Did connect to peripheral: %@", peripheral);

    NSLog(@"Connected");
    [peripheral setDelegate:self];
//    [peripheral discoverServices:nil];
    if(![self.connectedPeripherals containsObject:peripheral]){
        [self.connectedPeripherals addObject:peripheral];
    }
    if(![self.connectedPeripheralIdentifiers containsObject:peripheral.identifier]){
        [self.connectedPeripheralIdentifiers addObject:peripheral.identifier];
    }
    
    //Invoke the delegate "blueToothHelper: didConnected:" method if it has been implemented.
    if ([self.delegate respondsToSelector:@selector(blueToothHelper: didConnected:)])
        [delegate blueToothHelper:peripheral didConnected:nil];
    
//    int times = [[self readFile] intValue]+1;
//    [self writeFile:[NSString stringWithFormat:@"%d", times]];
}

/*
 Invoked whenever an existing connection with the peripheral is torn down.
 Reset local variables
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"Did Disconnect to peripheral: %@ with error = %@", peripheral, [error localizedDescription]);
    
    if([self.connectedPeripherals containsObject:peripheral]){
        [self.connectedPeripherals removeObject:peripheral];
    }
    if([self.connectedPeripheralIdentifiers containsObject:peripheral.identifier]){
        [self.connectedPeripheralIdentifiers removeObject:peripheral.identifier];
    }
    [manager connectPeripheral:peripheral
                       options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:centralManagerIdentifier]];
}

/*
 Invoked whenever the central manager fails to create a connection with the peripheral.
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"Fail to connect to peripheral: %@ with error = %@", peripheral, [error localizedDescription]);
    
    //Invoke the delegate "blueToothHelper: didFailToConnected:" method if it has been implemented.
    if ([self.delegate respondsToSelector:@selector(blueToothHelper: didFailToConnected:)])
        [delegate blueToothHelper:peripheral didFailToConnected:nil];
    
    if (peripheral)
    {
        [peripheral setDelegate:nil];
        peripheral = nil;
    }
}

-(void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)state{
    
//    NSArray *peripherals = state[CBCentralManagerRestoredStatePeripheralsKey];
    NSLog(@"Reconnect to central: %@ with peripheral = %@", central, state[CBCentralManagerRestoredStatePeripheralsKey]);
    
    [self writeFile:@"willRestoreState"];
}

#pragma mark CBPeripheralDelegate methods
/*
 Invoked upon completion of a -[discoverServices:] request.
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (error)
    {
        NSLog(@"Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        return;
    }
    for (CBService *service in peripheral.services)
    {
        NSLog(@"Service found with UUID: %@", service.UUID);
        
        if ([service.UUID isEqual:self.blueToothAction.currentService.serviceUUID])
        {
            [peripheral discoverCharacteristics:@[self.blueToothAction.currentCharacteristic.characteristicUUID] forService:service];
            break;
        }
    }
}

/*
 Invoked upon completion of a -[discoverCharacteristics:forService:] request.
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error)
    {
        NSLog(@"Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    NSData * valData;
    uint16_t val;
    for (CBCharacteristic * characteristic in service.characteristics){
        if( [characteristic.UUID isEqual:self.blueToothAction.currentCharacteristic.characteristicUUID]){
            switch (self.blueToothAction.currentActionType) {
                case WRITE:
                    val =self.blueToothAction.writingValue;
                    valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
                    [peripheral writeValue:valData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                    break;
                case READ:
                    [peripheral readValueForCharacteristic:characteristic];
                    break;
                case NOTIFY:
                    if(!characteristic.isNotifying) {
                        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                    }
                    break;
                default:
                    break;
            }
        }
    }
}

/*
 Invoked upon completion of a -[readValueForCharacteristic:] request or on the reception of a notification/indication.
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error)
    {
        NSLog(@"Error updating value for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        return;
    }
    
    NSLog(@"Updated Characteristic Value: %@", characteristic.value);
    
    if ([self.delegate respondsToSelector:@selector(blueToothHelper:didReadValue: withError:)])
        [self.delegate blueToothHelper:peripheral didReadValue: characteristic.value withError: error];
}

/*
 Invoked upon completion of a -[writeValue:forCharacteristic:] request.
 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error)
    {
        NSLog(@"Error writing value for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(blueToothHelper: didWriteValue:)])
        [delegate blueToothHelper:peripheral didWriteValue:error];
}

/*
 Invoked upon completion of a -[setNotifyValue:forCharacteristic:] request.
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error)
    {
        NSLog(@"Error updating notification state for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        return;
    }
//    [self.manager cancelPeripheralConnection:peripheral];
    NSLog(@"Updated notification state for characteristic %@ (newState:%@)", characteristic.UUID, [characteristic isNotifying] ? @"Notifying" : @"Not Notifying");
    
//    if ([self.delegate respondsToSelector:@selector(hardwareDidNotifyBehaviourOnCharacteristic:withPeripheral:error:)])
//        [self.delegate hardwareDidNotifyBehaviourOnCharacteristic:characteristic withPeripheral:peripheral error:error];
}
@end
