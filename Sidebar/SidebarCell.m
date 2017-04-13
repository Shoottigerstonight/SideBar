//
//  SidebarCell.m
//  Sidebar
//
//  Created by 侯云祥 on 2017/3/22.
//  Copyright © 2017年 今晚打老虎. All rights reserved.
//

#import "SidebarCell.h"

@interface SidebarCell ()
@end
@implementation SidebarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpSubviews];
    }
    return self;
}
- (void)setUpSubviews
{
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = self.title;
    CGFloat lableX = 10;
    CGFloat lableY = 10;
    CGFloat lableW = 120;
    CGFloat lableH = 30;
    self.titleLabel.frame = CGRectMake(lableX, lableY, lableW, lableH);
    self.titleLabel.textColor = [UIColor darkGrayColor];
    self.titleLabel.font = [UIFont systemFontOfSize:22];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLabel];
    
    
    
    UIImageView *lineImage = [[UIImageView alloc] initWithImage:[self createImageWithColor:[UIColor colorWithRed:239 /255.f green:239 /255.f blue:244 /255.f alpha:1.]]];
    lineImage.frame = CGRectMake(0, 49, CGRectGetWidth(self.frame), 1);
    [self addSubview:lineImage];
}
- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ref, color.CGColor);
    CGContextFillRect(ref, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}
@end
