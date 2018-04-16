//
//  MapAnnotation.m
//  LBSUserApp
//
//  Created by iMac on 11-7-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MapAnnotation.h"


@implementation MapAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (id) initWithVal: (CLLocationCoordinate2D) aCoordinate
{
	if ((self = [super init]) !=nil) 
    {
        coordinate = aCoordinate;
    }
	return self;
}

- (id) initWith: (CLLocationCoordinate2D) aCoordinate title: _strTitle
{
	if ((self = [super init]) !=nil)
    {
        coordinate = aCoordinate;
        title = _strTitle;
    }
	return self;
}

@end
