//
//  AppDelegate.h
//  Vala
//
//  Created by MacAdmin on 5/30/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(AppDelegate *)sharedAppDelegate;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)showToastMessage:(NSString *)message;

@end

