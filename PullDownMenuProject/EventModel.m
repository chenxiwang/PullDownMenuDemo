//
//  EventModel.m
//  PullDownMenuProject
//
//  Created by wcx on 2018/4/3.
//  Copyright © 2018年 gupeng. All rights reserved.
//

#import "EventModel.h"
#import "NSDate+CalendarExtension.h"
@implementation EventModel

- (NSInteger)month{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.time];
    NSDateComponents *component = [NSDate intervalToDate:date];
    return component.month;
}

- (NSDateComponents *)calendarData{
     NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.time];
    return [NSDate intervalToDate:date];
}

- (NSString *)timeString{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.time];
    NSString *string = [fmt stringFromDate:date];
    return string;
}

//- (void)setTime:(NSTimeInterval)time{
//    _time = time;
//    
//  
//}
//
//- (void)converFromTime:(NSTimeInterval )time{
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.time];
//    NSDateComponents *component = [NSDate intervalToDate:date];
//    
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    fmt.dateFormat = @"yyyy-MM-dd";
//    
//    self.calendarData = component;
//    self.month = component.month;
//    self.timeString = [fmt stringFromDate:date];
//}
@end
