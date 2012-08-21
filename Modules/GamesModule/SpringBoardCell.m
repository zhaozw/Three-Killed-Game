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
        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 70, 60)];
        iconView.backgroundColor = [UIColor clearColor];
        iconView.opaque = NO;
        iconView.layer.shadowRadius = 20.0;
        iconView.layer.shadowOpacity = 0.4;
        iconView.layer.shadowOffset = CGSizeMake( 20.0, 20.0 );
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 60, 69, 18)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview: nameLabel];
        [self.contentView addSubview: iconView];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.contentView.opaque = NO;
        self.opaque = NO;
        
        self.selectionStyle = AQGridViewCellSelectionStyleNone;
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
