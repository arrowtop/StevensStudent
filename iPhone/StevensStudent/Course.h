//
//  Course.h
//  StevensStudent
//
//  Created by toby on 4/30/14.
//  Copyright (c) 2014 arrowtop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Course : NSManagedObject

@property (nonatomic, retain) NSString * courseId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * professor;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * buildingCode;
@property (nonatomic, retain) NSString * room;

@end
