//
//  CustomScrollView.h
//  TestProject0001
//
//  Created by MacMini7 on 12/29/15.
//  Copyright (c) 2015 MacMini7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomScrollViewProtocol.h"
#import "Categoties.h"
@interface CustomScrollerView : UIView
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,weak) id <CustomScrollViewDelegate> delegateSCV;// Ingore To conflict Scroll View delegate
@property(nonatomic,weak) id <CustomScrollViewDataSource> dataSource;
@property(nonatomic,assign) UIControlType UIControlType;

- (void)reloadScrollView;
@end
