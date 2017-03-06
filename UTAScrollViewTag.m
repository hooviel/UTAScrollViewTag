//
//  UTAScrollViewTag.m
//  MaMiBaby
//
//  Created by David on 15/7/4.
//  Copyright (c) 2015年 VeryApps. All rights reserved.
//

#import "UTAScrollViewTag.h"

#define UnderlineWidthIncrease (0)

@interface UTAScrollViewTag () <UIScrollViewDelegate>
{
    NSArray *_arrBtnItem;
    UIImageView *_imageViewUnderline;
    UIView *_lineSep;
}

@end

@implementation UTAScrollViewTag

#pragma mark - super
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init
{
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = YES;
    self.scrollsToTop = NO;
    
    
    _selectedIndex = 0;
    _itemEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    _spacing = 10;
    _itemLeftOffsetVisiable = 50;
    _underLineWidth = 2;
    _underlineColor = [UIColor orangeColor];
    
    CGRect rc = CGRectMake(0, 0, 0, _underLineWidth);
    rc.origin.y = self.height-rc.size.height;
    _imageViewUnderline = [[UIImageView alloc] initWithFrame:rc];
    _imageViewUnderline.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _imageViewUnderline.backgroundColor = _underlineColor;
    [self addSubview:_imageViewUnderline];
    
//    _lineSep = [UIView new];
    _lineSep.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    _lineSep.frame = CGRectMake(self.contentOffset.x, self.height-0.5, self.width, 0.5);
    [self addSubview:_lineSep];
    
    [self clearSelectIndex];
}

- (void)setBounds:(CGRect)bounds
{
    CGSize sizeOld = self.bounds.size;
    [super setBounds:bounds];
    _lineSep.frame = CGRectMake(self.contentOffset.x, self.height-0.5, self.width, 0.5);
    
    if (!CGSizeEqualToSize(sizeOld, bounds.size)) {
        [self updateItemLayout];
    }
}

- (void)setArrTitle:(NSArray *)arrTitle
{
    if (arrTitle.count<=0) return;
    _arrTitle = arrTitle;
    if (_arrBtnItem.count>0) {
        [_arrBtnItem makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    NSMutableArray *arrBtnItem = [NSMutableArray arrayWithCapacity:arrTitle.count];
    UIButton *btnItem;
   
    for (NSInteger i=0; i<arrTitle.count; i++) {
        btnItem = [UIButton buttonWithType:UIButtonTypeCustom];
        btnItem.tag = i;
        NSString *title = [arrTitle[i] uppercaseString];
        [btnItem addTarget:self action:@selector(onTouchItem:) forControlEvents:UIControlEventTouchUpInside];
        [btnItem setTitle:title forState:UIControlStateNormal];
        btnItem.titleLabel.font = [UIFont systemFontOfSize:14];
        btnItem.contentEdgeInsets = _itemEdgeInsets;
        
        NSRange range = NSMakeRange(0, title.length);
        NSMutableAttributedString *mas;
        if (_dictAttributedNormal) {
            mas = [[NSMutableAttributedString alloc] initWithString:title];
            [mas setAttributes:_dictAttributedNormal range:range];
            [btnItem setAttributedTitle:mas forState:UIControlStateNormal];
        }
        else {
            [btnItem setTitleColor:[UIColor colorWithWhite:0.1 alpha:1]
                          forState:UIControlStateNormal];
        }
        
        if (_dictAttributedHighlighted) {
            mas = [[NSMutableAttributedString alloc] initWithString:title];
            [mas setAttributes:_dictAttributedHighlighted range:range];
            [btnItem setAttributedTitle:mas forState:UIControlStateHighlighted];
        }
        else {
            [btnItem setTitleColor:[UIColor colorWithWhite:0.4 alpha:1]
                          forState:UIControlStateHighlighted];
        }
        
        if (_dictAttributedSelected) {
            mas = [[NSMutableAttributedString alloc] initWithString:title];
            [mas setAttributes:_dictAttributedSelected range:range];
            [btnItem setAttributedTitle:mas forState:UIControlStateSelected];
        }
        else {
            [btnItem setTitleColor:_underlineColor
                          forState:UIControlStateSelected];
        }
        
        if (_dictAttributedDisable) {
            mas = [[NSMutableAttributedString alloc] initWithString:title];
            [mas setAttributes:_dictAttributedDisable range:range];
            [btnItem setAttributedTitle:mas forState:UIControlStateDisabled];
            [btnItem setAttributedTitle:mas forState:UIControlStateDisabled];
        }
        else {
            [btnItem setTitleColor:_underlineColor
                          forState:UIControlStateDisabled];
        }
        
        [arrBtnItem addObject:btnItem];
        [self addSubview:btnItem];
    }
    
    _arrBtnItem = arrBtnItem;
    [self bringSubviewToFront:_imageViewUnderline];
    
    [self updateItemLayout];
    
    self.selectedIndex = 0;
}

- (void)setUnderlineColor:(UIColor *)underlineColor
{
    _underlineColor = underlineColor;
    _imageViewUnderline.backgroundColor = underlineColor;
}

- (void)setUnderLineWidth:(CGFloat)underLineWidth
{
    _underLineWidth = underLineWidth;
    CGRect rc = _imageViewUnderline.frame;
    rc.size.height = _underLineWidth;
    rc.origin.y = self.height-rc.size.height;
    _imageViewUnderline.frame = rc;
}

- (void)setItemLeftOffsetVisiable:(CGFloat)itemLeftOffsetVisiable
{
    _itemLeftOffsetVisiable = itemLeftOffsetVisiable;
    if (_arrBtnItem.count==0) return;
    
    [self focusToIndex:_selectedIndex animated:NO];
}

- (void)setSpacing:(CGFloat)spacing
{
    _spacing = spacing;
    if (_arrBtnItem.count==0) return;
    
    [self updateItemLayout];
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets
{
    _edgeInsets = edgeInsets;
    if (_arrBtnItem.count==0) return;
    
    [self updateItemLayout];
}

- (void)setItemEdgeInsets:(UIEdgeInsets)itemEdgeInsets
{
    _itemEdgeInsets = itemEdgeInsets;
    if (_arrBtnItem.count==0) return;
    
    [self updateItemLayout];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self focusToIndex:selectedIndex animated:NO];
}

#pragma mark - private
- (void)updateItemLayout {
    UIButton *btnItem, *btnItemPrev;
    CGRect rcCurr;
    rcCurr.origin.x = _edgeInsets.left;
    rcCurr.origin.y = _edgeInsets.top;
    rcCurr.size.height = MAX(10, self.height-_edgeInsets.top-_edgeInsets.bottom);
    for (NSInteger i=0; i<_arrBtnItem.count; i++) {
        btnItem = _arrBtnItem[i];
        btnItem.contentEdgeInsets = _itemEdgeInsets;
        [btnItem sizeToFit];
        
        rcCurr.size.width = btnItem.width;
        if (0==i) {
            rcCurr.origin.x = _edgeInsets.left;
        }
        else {
            rcCurr.origin.x = btnItemPrev.right+_spacing;
        }
        btnItem.frame = rcCurr;
        btnItemPrev = btnItem;
    }
    
    self.contentSize = CGSizeMake(btnItemPrev.right+_edgeInsets.right, 0);
    
    if (_selectedIndex!=NSNotFound && NSLocationInRange(_selectedIndex, NSMakeRange(0, _arrBtnItem.count))) {
        btnItem = _arrBtnItem[_selectedIndex];
        CGPoint offset = CGPointMake(btnItem.left, 0);
        offset.x -= _itemLeftOffsetVisiable+UnderlineWidthIncrease*0.5;
        offset.x = MAX(0, MIN((CGFloat)(self.contentSize.width-self.width), MAX(0, offset.x)));
        [self setContentOffset:offset];
        _imageViewUnderline.alpha = 1;
        
        CGRect rc = _imageViewUnderline.frame;
        rc.size.width = btnItem.width+UnderlineWidthIncrease;
        rc.origin.x = btnItem.left-(rc.size.width-btnItem.width)*0.5;
        _imageViewUnderline.frame = rc;
        _imageViewUnderline.alpha = 1;
    } else {
        [self setContentOffset:CGPointZero];
        _imageViewUnderline.alpha = 0;
    }
    
}

- (void)onTouchItem:(UIButton *)btnItem
{
    [self focusToIndex:btnItem.tag animated:YES];
    
    if ([_delegateTag respondsToSelector:@selector(scrollViewTag:didSelectIndex:title:)]) {
        [_delegateTag scrollViewTag:self didSelectIndex:_selectedIndex title:_arrTitle[btnItem.tag]];
    }
}

#pragma mark - public
- (void)removeAllItem
{
    [_arrBtnItem makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    _arrBtnItem = nil;
    
    self.contentOffset = CGPointZero;
    self.contentSize = self.bounds.size;
}

- (void)focusToIndex:(NSInteger)index animated:(BOOL)animated
{
    BOOL isClear = NO;
    if (!NSLocationInRange(index, NSMakeRange(0, _arrBtnItem.count))) {
        _selectedIndex = NSNotFound;
        isClear = YES;
    } else {
        _selectedIndex = index;
    }
    
    for (NSInteger i=0; i<_arrBtnItem.count; i++) {
        UIButton *btnItem = _arrBtnItem[i];
        btnItem.enabled = i!=_selectedIndex;
    }

    __weak typeof(self) wself = self;
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [wself updateItemLayout];
        } completion:nil];
    } else {
        [self updateItemLayout];
    }
    
}

- (void)updateTitle:(NSString *)title atIndex:(NSInteger)index {
    if (NSLocationInRange(index, NSMakeRange(0, _arrBtnItem.count))) {
        UIButton *btnItem = _arrBtnItem[index];
    
        NSRange range = NSMakeRange(0, title.length);
        NSMutableAttributedString *mas;
        if (_dictAttributedNormal) {
            mas = [[NSMutableAttributedString alloc] initWithString:title];
            [mas setAttributes:_dictAttributedNormal range:range];
            [btnItem setAttributedTitle:mas forState:UIControlStateNormal];
        }
        else {
            [btnItem setTitleColor:[UIColor colorWithWhite:0.1 alpha:1]
                          forState:UIControlStateNormal];
        }
        
        if (_dictAttributedHighlighted) {
            mas = [[NSMutableAttributedString alloc] initWithString:title];
            [mas setAttributes:_dictAttributedHighlighted range:range];
            [btnItem setAttributedTitle:mas forState:UIControlStateHighlighted];
        }
        else {
            [btnItem setTitleColor:[UIColor colorWithWhite:0.4 alpha:1]
                          forState:UIControlStateHighlighted];
        }
        
        if (_dictAttributedSelected) {
            mas = [[NSMutableAttributedString alloc] initWithString:title];
            [mas setAttributes:_dictAttributedSelected range:range];
            [btnItem setAttributedTitle:mas forState:UIControlStateSelected];
        }
        else {
            [btnItem setTitleColor:_underlineColor
                          forState:UIControlStateSelected];
        }
        
        if (_dictAttributedDisable) {
            mas = [[NSMutableAttributedString alloc] initWithString:title];
            [mas setAttributes:_dictAttributedDisable range:range];
            [btnItem setAttributedTitle:mas forState:UIControlStateDisabled];
            [btnItem setAttributedTitle:mas forState:UIControlStateDisabled];
        }
        else {
            [btnItem setTitleColor:_underlineColor
                          forState:UIControlStateDisabled];
        }
        
        [self updateItemLayout];
    }
}

- (void)setScrollOffsetRate:(CGFloat)offsetRate
{
    if (0==offsetRate) {
        return;
    }
    
    NSInteger currIndex = _selectedIndex;
    NSInteger otherIndex = offsetRate>=0?_selectedIndex+1:_selectedIndex-1;
    
    CGFloat offsetOfCurr;
    CGRect rcCurr;
    {
        UIButton *btnItem = _arrBtnItem[currIndex];
        CGRect rc = _imageViewUnderline.frame;
        rc.size.width = btnItem.width+UnderlineWidthIncrease;
        rc.origin.x = btnItem.left-(rc.size.width-btnItem.width)*0.5;
        offsetOfCurr = MIN(MAX(rc.origin.x-_edgeInsets.left, 0), self.contentSize.width-self.width);
        rcCurr = CGRectMake(rc.origin.x, _imageViewUnderline.top, rc.size.width, _imageViewUnderline.height);
    }
    CGFloat offsetOfOther;
    CGRect rcOther;
    {
        UIButton *btnItem = _arrBtnItem[otherIndex];
        CGRect rc = _imageViewUnderline.frame;
        rc.size.width = btnItem.width+UnderlineWidthIncrease;
        rc.origin.x = btnItem.left-(rc.size.width-btnItem.width)*0.5;
        offsetOfOther = MIN(MAX(rc.origin.x-_edgeInsets.left, 0), self.contentSize.width-self.width);
        rcOther = CGRectMake(rc.origin.x, _imageViewUnderline.top, rc.size.width, _imageViewUnderline.height);
    }
    NSInteger len = fabs(offsetOfOther-offsetOfCurr);
    
    CGFloat offset = MIN(MAX(offsetOfCurr+len*offsetRate, 0), self.contentSize.width-self.width);
    self.contentOffset = CGPointMake(offset, 0);
    _imageViewUnderline.frame = CGRectMake(rcCurr.origin.x+(rcOther.origin.x-rcCurr.origin.x)*fabs(offsetRate),
                                           _imageViewUnderline.top,
                                           rcCurr.size.width+(rcOther.size.width-rcCurr.size.width)*fabs(offsetRate),
                                           _imageViewUnderline.height);
}

/**
 *  清空选中
 */
- (void)clearSelectIndex
{
    [self focusToIndex:NSNotFound animated:NO];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _lineSep.frame = CGRectMake(self.contentOffset.x, self.height-0.5, self.width, 0.5);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

@end
