//
//  BuildingTableViewCell.h
//  StevensStudent
//
//  Created by toby on 5/14/14.
//  Copyright (c) 2014 arrowtop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuildingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *buildingCode;
@property (weak, nonatomic) IBOutlet UILabel *buildingName;

@end
