//
//  EventTableViewCell.h
//  PullDownMenuProject
//
//  Created by wcx on 2018/4/3.
//  Copyright © 2018年 gupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *happenTime;
@property (weak, nonatomic) IBOutlet UILabel *eventType;
@property (weak, nonatomic) IBOutlet UILabel *year;
@property (weak, nonatomic) IBOutlet UILabel *month;

@end
