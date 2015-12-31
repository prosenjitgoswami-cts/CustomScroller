//
//  CustomScrollViewProtocol.h
//  TestProject0001
//
//  Created by MacMini7 on 12/29/15.
//  Copyright (c) 2015 MacMini7. All rights reserved.
//

#define DEFAULT_VISIBLE_PADDING 16.0f
typedef NS_OPTIONS(NSUInteger, UIControlType) {
    UIControlTypeSwipeGesture = 0,
    UIControlTypeScroller,
};

typedef NS_OPTIONS(NSUInteger, SwipeDirection) {
    SwipeDirectionRight = 1 << 0,
    SwipeDirectionLeft  = 1 << 1,
};

#import <Foundation/Foundation.h>
@class CustomScrollerView;
@protocol CustomScrollViewDelegate <NSObject>
@optional
- (void)customScrollView:(CustomScrollerView *)customScrollView currentView:(UIView *)currentView index:(NSInteger)index;

- (void)customScrollView:(CustomScrollerView *)customScrollView nextView:(UIView *)nextView index:(NSInteger)index;

- (void)customScrollView:(CustomScrollerView *)customScrollView previousView:(UIView *)previousView index:(NSInteger)index;


@end

@protocol CustomScrollViewDataSource <NSObject>
- (CGFloat)otherItemVisiblePadding;
- (NSInteger)numberOfItemInScrollView;
- (CGSize)sizeOfItemAtItemAtIndex:(NSInteger)index;

- (UIView *)customScrollView:(CustomScrollerView *)customScrollView itemAtIndex:(NSInteger)index;

@end