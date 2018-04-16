//
//  CameraDismissButton.m
//  CameraWithAVFoundation
//
//  Created by Gabriel Alvarado on 1/24/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import "AddGalleryButton.h"
#import "CameraStyleKitClass.h"

@implementation AddGalleryButton

- (void)drawRect:(CGRect)rect {
    [CameraStyleKitClass drawAddGalleryWithFrame:self.bounds];
}

@end
