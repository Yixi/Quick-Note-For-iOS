//
//  YXItemCell.m
//  QuickNote
//
//  Created by Yixi Liu on 13-7-18.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import "YXItemCell.h"


@implementation YXItemCell

- (void)setTitle:(NSString *)t{
    if(![t isEqualToString:_title]){
        _title = [t copy];
        _TitleLabel.text = _title;
    }
}

- (void)setTags:(NSString *)t {
    if(![t isEqualToString:_tags]){
        _tags = [t copy];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[_tags componentsSeparatedByString:@" "]];

        YXFillTagsView *fillTagsView = [[YXFillTagsView alloc] initWithFrame:CGRectMake(20, 40, 280, 22)];
        [fillTagsView bindTags:array isOverFlowHide:YES];
        [self.contentView addSubview:fillTagsView];
    }
}

- (void)setDatetime:(NSString *)t {
    if(![t isEqualToString:_datetime]){
        _datetime = [t copy];
        _date.text = _datetime;
    }
}


@end
