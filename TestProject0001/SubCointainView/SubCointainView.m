//
//  SubCointainView.m
//  TestProject0001
//
//  Created by MacMini7 on 12/29/15.
//  Copyright (c) 2015 MacMini7. All rights reserved.
//
#define TAG_CONSTANT_LABEL 20000

#import "SubCointainView.h"
@interface SubCointainView ()
@end
@implementation SubCointainView


- (instancetype)init {
   
    if(self = [super init])
    {
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.textColor = [UIColor whiteColor];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_descriptionLabel];;
    }
  
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame])
    {
        _descriptionLabel = [[UILabel alloc] initWithFrame:frame];
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.textColor = [UIColor whiteColor];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_descriptionLabel];;
    }
    
    return self ;
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    _descriptionLabel.frame = self.bounds;
}

#pragma mark - Setter
- (void)setDescriptionTitle:(NSString *)descriptionTitle{
    
    _descriptionTitle = descriptionTitle;
   
    if(_descriptionLabel && _descriptionTitle.length) {
        _descriptionLabel.text = _descriptionTitle;
    }
    
}


#pragma mark -

- (void)dealloc{
    
    _descriptionLabel = nil;
}

@end
