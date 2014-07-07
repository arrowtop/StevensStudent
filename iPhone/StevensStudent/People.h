//
//  People.h
//  StevensStudent
//
//  Created by toby on 4/30/14.
//  Copyright (c) 2014 arrowtop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface People : NSManagedObject

@property (nonatomic, retain) NSString * building;
@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * fax;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * room;
@property (nonatomic, retain) NSString * school;
@property (nonatomic, retain) NSString * title;

@end
