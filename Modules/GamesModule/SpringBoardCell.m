//
//  SpringBoardCell.m
//  ThreeKilled
//
//  Created by Liu Mingxing on 8/21/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import "SpringBoardCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation SpringBoardCell
@synthesize iconView;
@synthesize nameLabel;

- (void)dealloc {
    self.iconView = nil;
    self.nameLabel = nil;


    [super dealloc];
}   

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconView = [[[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 76, 54)] autorelease];
        self.iconView.backgroundColor = [UIColor clearColor];
        self.iconView.layer.cornerRadius = 8;
        self.iconView.layer.masksToBounds = YES;
        self.iconView.alpha = 0.5;
        [self.contentView addSubview:self.iconView];
        
        self.nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(2, 56, 76, 12)] autorelease];
        self.nameLabel.layer.cornerRadius = 8;
        self.nameLabel.layer.masksToBounds = YES;
        self.nameLabel.textAlignment = UITextAlignmentCenter;
        self.iconView.alpha = 0.5;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = [UIColor yellowColor];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:self.nameLabel];
        
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.alpha = 0.5;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
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

@end
