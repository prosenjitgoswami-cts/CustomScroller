//
//  Categoties.h
//  TestProject0001
//
//  Created by MacMini7 on 12/30/15.
//  Copyright (c) 2015 MacMini7. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UILabel (DynamicText)
- (void)sizeToAsText;

@end

@implementation UILabel (DynamicText)
- (void)sizeToAsText {
    
    CGRect rect = self.frame;
    rect.size = [self.text sizeWithAttributes:@{NSFontAttributeName : [UIFont fontWithName:self.font.fontName size:self.font.pointSize]}];
    self.frame = rect;
}
@end

@interface NSString (DynamicText)
-(CGSize)sizeOfText:(UIFont *)font ;
- (CGSize)sizeOfText:(UIFont *)font boundingSize:(CGSize)boundingSize;

@end
@implementation NSString (DynamicText)
- (CGSize)sizeOfText:(UIFont *)font {
    
    CGSize size = [self sizeWithAttributes:@{NSFontAttributeName : font}];
    return size ;
}

- (CGSize)sizeOfText:(UIFont *)font boundingSize:(CGSize)boundingSize{
    
    CGRect boundingRect = [self boundingRectWithSize:boundingSize
                                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                   attributes:@{NSFontAttributeName:font}
                                                      context:nil];
    
    return boundingRect.size;
}

@end


@interface UIScrollView (CurrentPage)
-(NSInteger) indexOfPage;
@end
@implementation UIScrollView (CurrentPage)
-(NSInteger) indexOfPage{
    
    CGFloat pageWidth = self.frame.size.width;
    NSInteger page = floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    return page;
}
@end