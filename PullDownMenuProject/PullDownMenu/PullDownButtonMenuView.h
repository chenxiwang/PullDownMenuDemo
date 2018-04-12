//
//  PullDowmButtonMenuView.h
//  PullDownMenuProject
//
//  Created by wcx on 2018/4/3.
//  Copyright © 2018年 gupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullDownButtonMenuView : UIView
@property (nonatomic, copy  ) void (^SelectCurrentItemBlock)(NSInteger index);
- (instancetype)initWithItemsArray:(NSArray *)itemArray;
- (void)setButtonTitle:(NSString *)title;
- (void)dismiss;
- (void)reloadData;
@end
