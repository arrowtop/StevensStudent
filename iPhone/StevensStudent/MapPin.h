//
//  MapPin.h
//  StevensStudent
//
//  Created by toby on 5/1/14.
//  Copyright (c) 2014 arrowtop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapPin : NSObject<MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *latitude;

@end
