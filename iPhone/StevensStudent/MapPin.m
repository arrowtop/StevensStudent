//
//  MapPin.m
//  StevensStudent
//
//  Created by toby on 5/1/14.
//  Copyright (c) 2014 arrowtop. All rights reserved.
//

#import "MapPin.h"

@implementation MapPin

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    
    return coordinate;
}

@end
