//
//  AppDelegate.h
//  BluetoothTool
//
//  Created by JamesMac on 2/10/15.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BlueToothHelper.h"
#import "BlueToothService.h"
#import "BlueToothCharacteristic.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

