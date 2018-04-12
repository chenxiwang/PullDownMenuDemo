//
//  PullDowmButtonMenuView.m
//  PullDownMenuProject
//
//  Created by wcx on 2018/4/3.
//  Copyright © 2018年 gupeng. All rights reserved.
//

#import "PullDownButtonMenuView.h"
#import "MenuButton.h"
#import "Masonry.h"
#import "DropDownViewController.h"
//设置颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define RGB(r,g,b) RGBA(r,g,b,1.0)
//默认高度 44
#define KMenuHeight 44
//线条高度
#define KLineHeight 1/[UIScreen mainScreen].scale


@interface PullDownButtonMenuView(){
    BOOL _isAnimating;
}
@property (nonatomic, strong) MenuButton *theMenuButton;
/** topView */
@property (nonatomic, strong) UIView *topView;
/** 蒙层背景按钮 */
@property (nonatomic, strong) UIButton *bgView;

@property (nonatomic, strong) DropDownViewController *dropViewController;

@property (nonatomic, strong) NSArray *itemArray;
@end
@implementation PullDownButtonMenuView

- (instancetype)initWithItemsArray:(NSArray *)itemArray{
    self.itemArray = itemArray;
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self startUIConfig];
    }
    return self;
}

- (void)startUIConfig{
    self.backgroundColor = [UIColor yellowColor];
    NSString *title = self.itemArray[0];
    self.theMenuButton = [self setMenuButtonWith:title];
    [self addSubview:self.theMenuButton];
    [self.theMenuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(KMenuHeight);
    }];
    
   
}



- (void)selectItem:(NSString *)title index:(NSInteger)index{
    if (title.length>0) {
        [self.theMenuButton setTitle:title forState:UIControlStateNormal];
        [self.theMenuButton setSelected:NO];
        [self dismiss];
    }
    if (self.SelectCurrentItemBlock) {
        self.SelectCurrentItemBlock(index);
    }
}

- (void)backViewClick:(UIButton *)button{
    
    [self dismiss];
}

- (void)btnClick:(UIButton *)button{
    if (_isAnimating) {
        return;
    }
    button.selected = !button.selected;
     UIView *superView = self.superview;
    if (button.selected) {
        
        if (!self.bgView.superview) {
            self.bgView.alpha = 1.0;
            [superView addSubview:self.bgView];
          //  [superView insertSubview:self.bgView belowSubview:self];
            [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.bottom);
//                make.left.right.bottom.equalTo(superView);
                make.edges.equalTo(superView);
            }];
        }
        
        // 添加对应子控制器的view
        UIViewController *vc = self.dropViewController;
        UIView *theView = vc.view;
        // 设置内容的高度
        CGFloat height = 200;
        [self.bgView addSubview:theView];
        [theView mas_remakeConstraints:^(MASConstraintMaker *make) {
           // make.left.right.top.equalTo(self.bgView);
            make.top.equalTo(self.mas_bottom).offset(10);
            make.left.right.equalTo(self);
            make.height.equalTo(height);
        }];
        
    }else{
        _isAnimating = YES;
        [UIView animateWithDuration:0.3
            animations:^{
                self.bgView.alpha = 0.0;
            }
            completion:^(BOOL finished) {
                [self.bgView removeFromSuperview];
                _isAnimating = NO;
            }];
    }
    
    
}

#pragma mark - outer method

- (void)setButtonTitle:(NSString *)title{
    
    if (self.theMenuButton && title.length>0 && ![self.theMenuButton.titleLabel.text isEqualToString:title]) {
        [self.theMenuButton setTitle:title forState:UIControlStateNormal];
    }
}
/** 隐藏下拉菜单 */
- (void)dismiss {
    [self.theMenuButton setSelected:NO];
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
    }];
}

- (void)reloadData{
      NSString *title = self.itemArray[0];
      [self.theMenuButton setTitle:title forState:UIControlStateNormal];
}

- (MenuButton *)setMenuButtonWith:(NSString *)title {
    // 获取按钮
    MenuButton *menuButton = [MenuButton buttonWithType:UIButtonTypeCustom];
    [menuButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [menuButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    UIImage *normalImage = [[UIImage imageNamed:@"arrow_down"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [menuButton setImage:normalImage forState:UIControlStateNormal];
    [menuButton setTitle:title forState:UIControlStateNormal];
    menuButton.titleLabel.font = [UIFont systemFontOfSize:15];
    menuButton.selected = NO;
    menuButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    menuButton.layer.borderWidth = 0.5;
    menuButton.layer.cornerRadius = 10;
    [menuButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return menuButton;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}
- (UIButton *)bgView {
    if (!_bgView) {
        _bgView = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgView.backgroundColor = RGBA(0, 0, 0, 0.2);
        [_bgView addTarget:self action:@selector(backViewClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgView;
}

- (DropDownViewController *)dropViewController{
    if (!_dropViewController) {
        _dropViewController = [[DropDownViewController alloc] init];
        _dropViewController.dataArray = [self.itemArray mutableCopy];
        __weak typeof(self) weakSelf = self;
        _dropViewController.SelectItemBlock = ^(NSString *title, NSInteger index) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf selectItem:title index:index];
        };
    }
    return _dropViewController;
}
@end
