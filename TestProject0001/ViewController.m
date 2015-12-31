//
//  ViewController.m
//  TestProject0001
//
//  Created by MacMini7 on 12/29/15.
//  Copyright (c) 2015 MacMini7. All rights reserved.
//

#import "ViewController.h"
#import "SubCointainView.h"
#define VISIBLE_WIDTH 50.0f
#import "CustomScrollerView.h"


@interface ViewController ()<UIScrollViewDelegate,CustomScrollViewDelegate,CustomScrollViewDataSource>
{
    NSInteger counterForSwipe;
    UIScrollView * myScrollView;
    NSArray *items;
    UIFont *font;

}
@end


#define TAG_CONSTANT_LABEL 10000

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    {
        font = [UIFont systemFontOfSize:16.0f];

        items = @[@"This is a scroller testing",@"Prosenjit",@"Ios",@"iPhone",@"This is a ViewController",@"This is a scroller testing",@"Spotrs",@"News",@"Latest News",@"Enterment",@"Hello World",@"This is a scroller testing"];
        CustomScrollerView * __scrollView = [[CustomScrollerView alloc] initWithFrame:CGRectMake(0, 100.f, self.view.bounds.size.width, 100.0f)];
        __scrollView.backgroundColor = [UIColor grayColor];
        __scrollView.delegateSCV  =self;
        __scrollView.dataSource = self;
        __scrollView.UIControlType = UIControlTypeSwipeGesture;
              [self.view addSubview:__scrollView];
        [__scrollView reloadScrollView];

    }
    
    
}
#pragma mark -

- (CGFloat)otherItemVisiblePadding{
    
    return 16.0f;
}
- (NSInteger)numberOfItemInScrollView{
    
    return  items.count;
}
- (UIView *)customScrollView:(CustomScrollerView *)customScrollView itemAtIndex:(NSInteger)index{
    
    
    UILabel * subCointainView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 40.0f)];
    [subCointainView setTextColor:[UIColor whiteColor]];
    subCointainView.backgroundColor = [UIColor clearColor];
    subCointainView.tag = TAG_CONSTANT_LABEL + index;
    subCointainView.font = font;
    subCointainView.text = [items objectAtIndex:index];
    subCointainView.numberOfLines = 1;
    return subCointainView;
    
}

- (CGSize)sizeOfItemAtItemAtIndex:(NSInteger)index {
    
    NSString *text = [items objectAtIndex:index];
    CGSize size =  [text sizeOfText:font boundingSize:CGSizeMake(300.0f, 9999.0f)];
    return  size;
    
    
}

- (void)customScrollView:(CustomScrollerView *)customScrollView currentView:(UIView *)currentView index:(NSInteger)index{
  //  UILabel *l = (UILabel*)currentView;
  //  l.textAlignment = NSTextAlignmentCenter;
}

- (void)customScrollView:(CustomScrollerView *)customScrollView nextView:(UIView *)nextView index:(NSInteger)index{
   // UILabel *l = (UILabel*)nextView;
    //l.textAlignment = NSTextAlignmentLeft;
}

- (void)customScrollView:(CustomScrollerView *)customScrollView previousView:(UIView *)previousView index:(NSInteger)index{
    
   // UILabel *l = (UILabel*)previousView;
   // l.textAlignment = NSTextAlignmentRight;
    
    
}
#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
