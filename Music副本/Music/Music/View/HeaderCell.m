//
//  HeaderCell.m
//  Music
//
//  Created by zhupeng on 15/10/28.
//  Copyright (c) 2015年 朱鹏. All rights reserved.
//

#import "HeaderCell.h"

@implementation HeaderCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.titleLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:12];
}

@end
