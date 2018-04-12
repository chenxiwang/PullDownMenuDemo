//
//  EventModel.h
//  PullDownMenuProject
//
//  Created by wcx on 2018/4/3.
//  Copyright © 2018年 gupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventModel : NSObject
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, copy  ) NSString *eventType;
@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSDateComponents *calendarData;
@property (nonatomic, copy  ) NSString *timeString;

- (void)converFromTime:(NSTimeInterval )time;
@end
