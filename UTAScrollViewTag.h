//
//  UTAScrollViewTag.h
//  MaMiBaby
//
//  Created by David on 15/7/4.
//  Copyright (c) 2015年 VeryApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UTAScrollViewTagDelegate;

@interface UTAScrollViewTag : UIScrollView

@property (nonatomic, weak) IBOutlet id<UTAScrollViewTagDelegate> delegateTag;

@property (nonatomic, strong) UIColor *underlineColor;
/*!
 *  下划线(指示器)
 */
@property (nonatomic, assign) CGFloat underLineWidth;
@property (nonatomic, assign) CGFloat itemLeftOffsetVisiable;

@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) UIEdgeInsets itemEdgeInsets;

@property (nonatomic, strong) NSArray *arrTitle;
@property (nonatomic, assign) NSInteger selectedIndex;

/**
 *  按钮字体样式
 */
@property (nonatomic, copy) NSDictionary *dictAttributedNormal;
@property (nonatomic, copy) NSDictionary *dictAttributedHighlighted;
@property (nonatomic, copy) NSDictionary *dictAttributedSelected;
@property (nonatomic, copy) NSDictionary *dictAttributedDisable;

- (void)removeAllItem;
- (void)focusToIndex:(NSInteger)index animated:(BOOL)animated;
- (void)setScrollOffsetRate:(CGFloat)offsetRate;
- (void)updateTitle:(NSString *)title atIndex:(NSInteger)index;

/**
 *  清空选中
 */
- (void)clearSelectIndex;

@end

@protocol UTAScrollViewTagDelegate <NSObject>

- (void)scrollViewTag:(UTAScrollViewTag *)scrollViewTag didSelectIndex:(NSInteger)index title:(NSString *)title;

@end
