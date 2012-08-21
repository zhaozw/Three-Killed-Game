//
//  SpringBoardCell.h
//  ThreeKilled
//
//  Created by Liu Mingxing on 8/21/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import "AQGridViewCell.h"

@interface SpringBoardCell : AQGridViewCell {
    UIImageView *iconView;
    UILabel *nameLabel;
}
@property (nonatomic, retain)  UIImageView *iconView;
@property (nonatomic, retain)  UILabel *nameLabel;


@end
