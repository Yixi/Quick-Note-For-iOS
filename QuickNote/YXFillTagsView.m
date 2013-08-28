//
//  YXFillTagsView.m
//  QuickNote
//
//  Created by Yixi Liu on 13-8-27.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import "YXFillTagsView.h"
#import "YXTagsLabel.h"

@implementation YXFillTagsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)bindTags:(NSMutableArray *)tags isOverFlowHide:(BOOL)isHide {

    NSArray *views = [self subviews];
    for(UIView *view in views){
        [view removeFromSuperview];
    }

    CGFloat frameWidth = self.frame.size.width;

    CGFloat tagsTotalWidth = 0.0f;
    CGFloat tagsTotalHeight = 0.0f;

    CGFloat tagHeight = 0.0f;
    for (NSString *tag in tags){
        YXTagsLabel *tagsLabel = [[YXTagsLabel alloc] initWithFrame:CGRectMake(tagsTotalWidth, tagsTotalHeight, 0, 0)];
        tagsLabel.text = tag;
        tagsTotalWidth += tagsLabel.frame.size.width + 6;
        tagHeight = tagsLabel.frame.size.height;

        if(tagsTotalWidth >= frameWidth){
            if(isHide){
                break;
            }
            tagsTotalHeight += tagsLabel.frame.size.height + 2;
            tagsTotalWidth = 0.0f;
            tagsLabel.frame = CGRectMake(tagsTotalWidth, tagsTotalHeight, tagsLabel.frame.size.width, tagsLabel.frame.size.height);
            tagsTotalWidth += tagsLabel.frame.size.width + 6;
        }
        [self addSubview:tagsLabel];
    }
    tagsTotalHeight += tagHeight;

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, tagsTotalHeight);
}

@end
