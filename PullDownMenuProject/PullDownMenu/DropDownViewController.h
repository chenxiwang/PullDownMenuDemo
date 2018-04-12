//
//  DropDowmViewController.h
//  PullDownMenuProject
//
//  Created by wcx on 2018/4/3.
//  Copyright © 2018年 gupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy  ) void (^SelectItemBlock)(NSString *title,NSInteger index);
@end
