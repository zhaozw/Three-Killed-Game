/*
 * Copyright © 2010 - 2012 Modo Labs Inc. All rights reserved.
 *
 * The license governing the contents of this file is located in the LICENSE
 * file located at the root directory of this distribution. If the LICENSE file
 * is missing, please contact sales@modolabs.com.
 *
 */

#import <UIKit/UIKit.h>
#import "IconGrid.h"

@protocol IconGridScrollViewDataSource;

@interface IconGridScrollView : UIScrollView
{
    UIView *_headerView;
    UIView *_footerView;
    
    NSInteger _iconsPerRow;
    NSRange _visibleIcons;
}

@property (nonatomic, assign) id<IconGridScrollViewDataSource> dataSource;

@property (nonatomic) GridPadding padding;
@property (nonatomic) GridSpacing spacing;
@property (nonatomic) CGSize iconSize;
@property (nonatomic) NSInteger maxColumns; // specify 0 to fit as many columns as possible
@property (nonatomic) GridIconAlignment alignment;

@property (nonatomic, retain) UIView *footerView;
@property (nonatomic, retain) UIView *headerView;

- (void)reloadData;

@end

@protocol IconGridScrollViewDataSource <NSObject>

- (NSUInteger)numberOfIconsInGrid:(IconGridScrollView *)gridView;
- (UIView *)gridView:(IconGridScrollView *)gridView viewForIconAtIndex:(NSUInteger)index;

@optional

- (void)gridView:(IconGridScrollView *)gridView didTapOnIconAtIndex:(NSUInteger)index;

@end


