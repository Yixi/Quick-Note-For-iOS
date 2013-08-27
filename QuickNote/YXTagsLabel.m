//
//  YXTagsLabel.m
//  QuickNote
//
//  Created by Yixi Liu on 13-8-27.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import <PXEngine/PXEngine.h>
#import "YXTagsLabel.h"

@implementation YXTagsLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithHexString:@"#EAF1FF"];
        self.textColor = [UIColor colorWithHexString:@"2F5AD8"];
        self.font = [UIFont systemFontOfSize:13];
        self.textAlignment = NSTextAlignmentCenter;

        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10.0f;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setText:(NSString *)text {
    super.text = text;
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(320, 10000) lineBreakMode:NSLineBreakByWordWrapping];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width + 20, size.height+6);
}

@end
