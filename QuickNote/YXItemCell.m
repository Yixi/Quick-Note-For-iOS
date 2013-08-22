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
        _TagLabel.text = _tags;
    }
}


@end
