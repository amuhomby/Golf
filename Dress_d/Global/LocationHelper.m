//
//  LocationHelper.m
//  Tinder
//
//  Created by Elluminati - macbook on 11/04/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import "LocationHelper.h"
#import "UtilComm.h"

@implementation LocationHelper

#pragma mark -
#pragma mark - Init

-(id)init
{
    if((self = [super init]))
    {
        //get current location
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return self;
}

+(LocationHelper *)sharedObject
{
    static LocationHelper *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[LocationHelper alloc] init];
    });
    return obj;
}

-(void)locationPermissionAlert
{
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    if (locationAllowed==NO)
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled"
//                                                        message:@"To re-enable, please go to Settings and turn on Location Service for this app."
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
        [APPDELEGATE showToastMessage:@"To re-enable, please go to Settings and turn on Location Service for this app."];
    
    }
}

-(void)startLocationUpdating
{
    if (![CLLocationManager locationServicesEnabled])
    {
//        [[UserDefaultHelper sharedObject]setLocationDisable:@"1"];
//        [Helper showAlertWithTitle:@"Location Services disabled" Message:@"App requires location services to find your current city weather.Please enable location services in Settings."];
    }
    else
    {
        [self stopLocationUpdating];
        if (locationManager==nil)
        {
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            
            if(IS_OS_8_OR_LATER)
            {
                if([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
                    //NSUInteger code = [CLLocationManager authorizationStatus];
                    if (/*code == kCLAuthorizationStatusNotDetermined &&*/ ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
                        // choose one request according to your business.
                        if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                            [locationManager requestAlwaysAuthorization];
                        } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                            [locationManager  requestWhenInUseAuthorization];
                        } else {
                            NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
                        }
                    }
                }
            }
        }
        [locationManager startUpdatingLocation];
    }
}

-(void)stopLocationUpdating
{
    [locationManager stopUpdatingLocation];
    locationManager.delegate=nil;
    if (locationManager)
    {
        locationManager=nil;
    }
}

-(void)startLocationUpdatingWithBlock:(DidUpdateLocation)block
{
    blockDidUpdate=[block copy];
    [self startLocationUpdating];
}

#pragma mark -
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    switch([error code])
    {
        case kCLErrorLocationUnknown: // location is currently unknown, but CL will keep trying
            break;
            
        case kCLErrorDenied: // CL access has been denied (eg, user declined location use)
            //message = @"Sorry, flook has to know your location in order to work. You'll be able to see some cards but not find them nearby";
            break;
            
        case kCLErrorNetwork: // general, network-related error
            //message = @"Flook can't find you - please check your network connection or that you are not in airplane mode";
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
//    DLog(@"didUpdateToLocation: %@", currentLocation);
    if (currentLocation != nil) {
        NSString  *strForCurrentLongitude= [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        NSString  *strForCurrentLatitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
        [Global sharedGlobal].lon = strForCurrentLongitude;
        [Global sharedGlobal].lat = strForCurrentLatitude;
        [[Global sharedGlobal] SaveParam];
        CLGeocoder * geocoder = [[CLGeocoder alloc] init];
//        NSString * address = nil;
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray * placemarks, NSError *error){
            if(error == nil && [placemarks count] > 0){
                CLPlacemark * placemark = [placemarks lastObject];
                NSString * strAdd = nil;
                if([placemark.subThoroughfare length] != 0)
                    strAdd  = placemark.subThoroughfare;
                if([placemark.thoroughfare length] != 0){
                    if([strAdd length] != 0)
                        strAdd = [NSString stringWithFormat:@"%@, %@", strAdd, [placemark thoroughfare]];
                    else{
                        strAdd = placemark.thoroughfare;
                    }
                }
                
                if([placemark.postalCode length]!= 0){
                    if([strAdd length]!= 0 )
                        strAdd = [NSString stringWithFormat:@"%@,%@", strAdd, [placemark postalCode]];
                    else
                        strAdd = placemark.postalCode;
                }
                
                if([placemark.locality length]!= 0){
                    if([strAdd length]!= 0 )
                        strAdd = [NSString stringWithFormat:@"%@,%@", strAdd, [placemark locality]];
                    else
                        strAdd = placemark.locality;
                    [[Global sharedGlobal]setCity:placemark.locality];
                }
                
                
                if([placemark.administrativeArea length]!= 0){
                    if([strAdd length]!= 0 )
                        strAdd = [NSString stringWithFormat:@"%@,%@", strAdd, [placemark administrativeArea]];
                    else
                        strAdd = placemark.administrativeArea;
                    [[Global sharedGlobal]setState:placemark.administrativeArea];
                }
                
                if([placemark.country length]!= 0){
                    if([strAdd length]!= 0 )
                        strAdd = [NSString stringWithFormat:@"%@,%@", strAdd, [placemark country]];
                    else
                        strAdd = placemark.country;
                    [[Global sharedGlobal]setCountry:placemark.country];
                }
                
            }
        }];
        
//        NSDictionary * result =  [UtilComm updateLocationStrangrs:dic];
//        CommResult retcode =[UtilComm analizeResultCode:result];
//        if(result)
//        {
//            DLog(@"Lat: %@ Lon %@", lat, lon);
//        }
        
        if (blockDidUpdate) {
            blockDidUpdate(currentLocation,oldLocation,nil);
        }
    }else{
        if (blockDidUpdate) {
            blockDidUpdate(currentLocation,oldLocation,[NSError errorWithDomain:@"Reveal" code:90000 userInfo:[NSDictionary dictionary]]);
        }
    }
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
//    DLog(@"Paused Updatting");
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
//    DLog(@"Resumed Updatting");
}

@end
