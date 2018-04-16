//
//  MapAnnotation.h
//  LBSUserApp
//
//  Created by iMac on 11-7-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <CoreLocation/CoreLocation.h>
//#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>



@interface MapAnnotation : NSObject <MKAnnotation>
{
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
}
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, retain) NSDictionary *user;

- (id) initWithVal: (CLLocationCoordinate2D) aCoordinate;
- (id) initWith: (CLLocationCoordinate2D) aCoordinate title: _strTitle;

@end