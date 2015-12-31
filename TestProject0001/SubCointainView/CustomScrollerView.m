//
//  CustomScrollView.m
//  TestProject0001
//
//  Created by MacMini7 on 12/29/15.
//  Copyright (c) 2015 MacMini7. All rights reserved.
//
#define TAG_CONSTANT_LABEL 10000

#import "CustomScrollerView.h"
@interface CustomScrollerView ()<UIScrollViewDelegate>
{
    UIView *previousView;
    UIView *currentView;
    UIView *nextView;
    
    NSInteger _tempCurrentIndex;
}
@property(nonatomic,assign) NSInteger currentIndex;
@property(nonatomic,assign) CGFloat otherItemVisiblePadding;
@property(nonatomic,assign) NSInteger numberOfItemInScrollView;

@end
@implementation CustomScrollerView

#pragma mark -

- (instancetype)init {
    
    if(self = [super init]) {
        
        [self configureUI];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        
        [self configureUI];
    }
    
    return self;
}

- (void)configureUI {
    _tempCurrentIndex =-1;
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = YES;
        [self addSubview:_scrollView];
    }
    
    _otherItemVisiblePadding = DEFAULT_VISIBLE_PADDING;
    [self reloadScrollView];
}
- (void)reloadScrollView {
   for (UIView *view in [[_scrollView subviews] mutableCopy]) {
       [view removeFromSuperview];
    }
    [self assignDataSource];
}


#pragma mark - Setter

- (void)setDataSource:(id<CustomScrollViewDataSource>)dataSource {
    
    _dataSource = dataSource;
    
    [self assignDataSource];
}

- (void)setUIControlType:(UIControlType)UIControlType {
    
    _UIControlType = UIControlType;
    
    switch (_UIControlType) {
        case UIControlTypeScroller:
        {
            _scrollView.delegate = self;
            
        }
            break;
            
        case UIControlTypeSwipeGesture:
        {
            self.userInteractionEnabled = YES;
            _scrollView.userInteractionEnabled = NO;

            [self addSwipeGestures];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)assignDataSource {
    
    
    if(_dataSource && [_dataSource respondsToSelector:@selector(otherItemVisiblePadding)]) {
        _otherItemVisiblePadding = [_dataSource otherItemVisiblePadding];
        
    }
    if(_dataSource  && [_dataSource respondsToSelector:@selector(numberOfItemInScrollView)]){
        
        _numberOfItemInScrollView = [_dataSource numberOfItemInScrollView];
        
        [self createSubView];
    }
}
- (void)createSubView   {
   
    CGRect rect = _scrollView.bounds;
    
    for (int i = 0 ; i <_numberOfItemInScrollView; i ++) {
        
        if(_dataSource && [_dataSource respondsToSelector:@selector(customScrollView:itemAtIndex:)])
        {
            
            UIView *subCointainView = [_dataSource customScrollView:self itemAtIndex:i];
           
            if(subCointainView) {
                
                CGSize dynamicSize = CGSizeZero;
                CGFloat width = 0.0f;
                if([_dataSource respondsToSelector:@selector(sizeOfItemAtItemAtIndex:)])    {
                    dynamicSize = [_dataSource sizeOfItemAtItemAtIndex:i];
                }
                width = dynamicSize.width ? dynamicSize.width : subCointainView.frame.size.width; //
                width =  MIN(width,250.0); // Max As Scroll Width
                
                CGFloat originOffSet = (_scrollView.frame.size.width - width)/2;
                rect.size.width = width;
                rect.origin.x += originOffSet;
                
                CGFloat height =  dynamicSize.width ?dynamicSize.height:subCointainView.frame.size.height;
                height = MAX(height, subCointainView.frame.size.width);
                
                height = MIN(height, _scrollView.frame.size.height);
                
                rect.origin.y = (_scrollView.frame.size.height - height)/2;
                rect.size.height = height;
                
                
                
                subCointainView.frame = rect;
                subCointainView.tag = TAG_CONSTANT_LABEL + i;
                [_scrollView addSubview:subCointainView];
                rect.origin.x = CGRectGetMaxX(rect) + originOffSet;
            }
        }
    }
    
    _scrollView.contentSize = CGSizeMake( rect.origin.x,0);
    
    [self reArrangeFrame:0 scrollView:_scrollView];
}

#pragma mark -

- (void)layoutSubviews {
    
    [super layoutSubviews];
    _scrollView.frame = self.bounds;
    
}

#pragma mark - release Memory

- (void)dealloc {
    _scrollView = nil;
    
}


#pragma mark -  Swipe Gestures


-(void)addSwipeGestures{
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self addGestureRecognizer:recognizer];
}
-(void)handleSwipeWithSwipDirection:(SwipeDirection)swipeDirection
{
    NSInteger maxNumberCount = _numberOfItemInScrollView;
    
    
    switch (swipeDirection) {
        case SwipeDirectionRight:
        {
            if(_currentIndex > 0 && _currentIndex< maxNumberCount)
            {
                _currentIndex -=1; ;
                [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    CGFloat originX = _currentIndex * _scrollView.frame.size.width;
                    
                    [self reArrangeFrame:_currentIndex scrollView:_scrollView];
                    _scrollView.contentOffset = CGPointMake(originX, _scrollView.contentOffset.y);
                } completion:^(BOOL finished) {
                    [self fetchDelegate];

                }];
            }
        }
            break;
            
        case SwipeDirectionLeft:
        {
            if(_currentIndex >= 0 &&  _currentIndex < maxNumberCount-1)
            {
                _currentIndex +=1; ;
                [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    [self reArrangeFrame:_currentIndex scrollView:_scrollView];
                    CGFloat originX = _currentIndex * _scrollView.frame.size.width;
                    
                    originX = MAX(originX+1, originX);
                    _scrollView.contentOffset = CGPointMake(originX, _scrollView.contentOffset.y);
                } completion:^(BOOL finished) {
                    
                    [self fetchDelegate];
                    
                }];
            }
        }
        break;
        default:
            break;
    }
    
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    
    if([recognizer direction] == UISwipeGestureRecognizerDirectionLeft)
    {
        [self handleSwipeWithSwipDirection:SwipeDirectionLeft];
    }
    else
    {
        [self handleSwipeWithSwipDirection:SwipeDirectionRight];
    }
}


#pragma mark -
- (void)fetchDelegate {
    
   
    if(previousView && _delegateSCV && [_delegateSCV respondsToSelector:@selector(customScrollView:previousView:index:)])
    {
        [_delegateSCV customScrollView:self previousView:previousView index:_currentIndex-1];
    }
    if(nextView && _delegateSCV && [_delegateSCV respondsToSelector:@selector(customScrollView:nextView:index:)])
    {
        [_delegateSCV customScrollView:self nextView:nextView index:_currentIndex+1];
    }
    if(currentView && _delegateSCV && [_delegateSCV respondsToSelector:@selector(customScrollView:currentView:index:)])
    {
        [_delegateSCV customScrollView:self currentView:currentView index:_currentIndex];
    }
   
}


#pragma mark -
- (UIView *)nextView:(NSInteger)currentIndexOfPage scrollView:(UIScrollView *)scrollView{
    
    UIView *__nextView = [scrollView viewWithTag:TAG_CONSTANT_LABEL + (currentIndexOfPage+1)];
    
    return __nextView;
}

- (UIView *)viewForIndexOfPage:(NSInteger)indexOfPage scrollView:(UIScrollView *)scrollView{
    
    UIView *view = [scrollView viewWithTag:TAG_CONSTANT_LABEL + indexOfPage];
    
    return view;
}



- (UIView *)previousView:(NSInteger)currentIndexOfPage scrollView:(UIScrollView *)scrollView {
    
    UIView *__previousView = [scrollView viewWithTag:TAG_CONSTANT_LABEL + (currentIndexOfPage-1)];
    
    return __previousView;
}

- (UIView *)currentView:(NSInteger)currentIndexOfPage scrollView:(UIScrollView *)scrollView{
    
    UIView *__currentView = [scrollView viewWithTag:TAG_CONSTANT_LABEL + currentIndexOfPage];
    
    return __currentView;
}

- (void)reArrangeFrame:(NSInteger)currentIndexOfPage scrollView:(UIScrollView *)scrollView{
    
    CGFloat originX = currentIndexOfPage * scrollView.frame.size.width;
    
    previousView = [self previousView:currentIndexOfPage scrollView:scrollView];
    
    if(previousView) {
        
        CGRect rectPreviousView = previousView.frame;
        rectPreviousView.origin.x = (originX - rectPreviousView.size.width);
        rectPreviousView.origin.x += _otherItemVisiblePadding;
        previousView.frame = rectPreviousView;
        
    }
    
    currentView = [self currentView:currentIndexOfPage scrollView:scrollView];
    if(currentView) {
        
        CGRect rectCurrentView = currentView.frame;
        CGFloat newOriginX = originX + (CGRectGetWidth(scrollView.frame) - CGRectGetWidth(rectCurrentView))/2;
        rectCurrentView.origin.x = newOriginX;
        currentView.frame = rectCurrentView;
        
    }
    
    nextView = [self nextView:currentIndexOfPage scrollView:scrollView];
    
    if(nextView) {
        
        CGRect rectNextView = nextView.frame;
        rectNextView.origin.x = (originX + scrollView.frame.size.width);
        rectNextView.origin.x -= _otherItemVisiblePadding;
        nextView.frame = rectNextView;
        
    }
    
    
}

#pragma mark - Scroller
-(void)scrollWithSwipDirection:(SwipeDirection)swipeDirection
{
    NSInteger maxNumberCount = _numberOfItemInScrollView;
    
    
    switch (swipeDirection) {
        case SwipeDirectionRight:
        {
            if(_currentIndex >= 0 && _currentIndex< maxNumberCount)
            {
                //_currentIndex -=1; ;
                // [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                //CGFloat originX = _currentIndex * _scrollView.frame.size.width;
                
                [self reArrangeFrame:_currentIndex scrollView:_scrollView];
                //  _scrollView.contentOffset = CGPointMake(originX, _scrollView.contentOffset.y);
                //} completion:^(BOOL finished) {
                [self fetchDelegate];
                
                // }];
            }
        }
            break;
            
        case SwipeDirectionLeft:
        {
            if(_currentIndex >= 0 &&  _currentIndex <= maxNumberCount-1)
            {
                //_currentIndex +=1; ;
                //  [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                [self reArrangeFrame:_currentIndex scrollView:_scrollView];
                CGFloat originX = _currentIndex * _scrollView.frame.size.width;
                
                originX = MAX(originX+1, originX);
                //  _scrollView.contentOffset = CGPointMake(originX, _scrollView.contentOffset.y);
                //  } completion:^(BOOL finished) {
                
                [self fetchDelegate];
                
                //  }];
            }
        }
            break;
        default:
            break;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
{
    CGFloat d = [scrollView.panGestureRecognizer translationInView:scrollView.superview].x;

    NSInteger index =[scrollView indexOfPage];

    if(_tempCurrentIndex != index )  {
        
        _currentIndex = index;
        
      

        //scrollView.contentOffset =CGPointMake(_currentIndex*scrollView.frame.size.width, 0);
        if ([scrollView.panGestureRecognizer translationInView:scrollView.superview].x > 0) {
            
            [self scrollWithSwipDirection:SwipeDirectionRight];
            _tempCurrentIndex = index;
            
            NSLog(@"%ld-- %ld",index,_tempCurrentIndex);
            
            
        } else if([scrollView.panGestureRecognizer translationInView:scrollView.superview].x <0){
            
            [self scrollWithSwipDirection:SwipeDirectionLeft];
            _tempCurrentIndex = index;
            
            NSLog(@"%ld-- %ld",index,_tempCurrentIndex);
            
        }
        
        
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index =[scrollView indexOfPage];
   
    if(_tempCurrentIndex != index || index ==0)  {
      
        _currentIndex = index;
        
        
        if ([scrollView.panGestureRecognizer translationInView:scrollView.superview].x > 0) {
            
            [self scrollWithSwipDirection:SwipeDirectionRight];
            _tempCurrentIndex = index;
            

            
        } else if([scrollView.panGestureRecognizer translationInView:scrollView.superview].x <0){
            
            [self scrollWithSwipDirection:SwipeDirectionLeft];
            _tempCurrentIndex = index;
            

        }
        
      
    }
    
}


@end
