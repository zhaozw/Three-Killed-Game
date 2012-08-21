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
        self.iconView = [[[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 70, 72)] autorelease];
        self.iconView.backgroundColor = [UIColor clearColor];
        self.iconView.layer.cornerRadius = 2;
        self.iconView.layer.masksToBounds = YES;
        self.iconView.alpha = 0.5;
        [self.contentView addSubview:self.iconView];
        
        self.nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(70, 2, 16, 70)] autorelease];
        self.nameLabel.layer.cornerRadius = 2;
        self.nameLabel.layer.masksToBounds = YES;
        self.iconView.alpha = 0.5;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.nameLabel];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.contentView.opaque = NO;
        self.opaque = NO;
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
