/* 
 * Copyright (c) 2010 Massachusetts Institute of Technology
 * Copyright (c) 2011 - 2012 Modo Labs, Inc
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "IconGrid.h"

GridPadding GridPaddingMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
    GridPadding padding = {top, left, bottom, right};
    return padding;
}

GridSpacing GridSpacingMake(CGFloat width, CGFloat height) {
    return (GridSpacing)CGSizeMake(width, height);
}

const GridPadding GridPaddingZero = {0, 0, 0, 0};
const GridSpacing GridSpacingZero = {0, 0};

@interface IconGrid (Private)

- (void)layoutRow:(NSArray *)rowIcons width:(CGFloat)rowWidth;

@end


@implementation IconGrid

@synthesize delegate, padding = _padding, spacing = _spacing,
maxColumns = _maxColumns, alignment = _alignment, icons = _icons;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        _padding = GridPaddingZero;
        _spacing = GridSpacingZero;
        _maxColumns = 0;
        _alignment = GridIconAlignmentLeft;
        
        _currentX = _currentX = 0;
    }
    return self;
}

- (CGFloat)topPadding { return _padding.top; }
- (CGFloat)rightPadding { return _padding.right; }
- (CGFloat)bottomPadding { return _padding.bottom; }
- (CGFloat)leftPadding { return _padding.left; }

- (void)setTopPadding:(CGFloat)value { _padding.top = value; }
- (void)setRightPadding:(CGFloat)value { _padding.right = value; }
- (void)setBottomPadding:(CGFloat)value { _padding.bottom = value; }
- (void)setLeftPadding:(CGFloat)value { _padding.left = value; }

- (void)layoutMoreIcons:(NSArray *)icons
{
    CGFloat availableWidth = CGRectGetWidth(self.bounds) - self.leftPadding - self.rightPadding;
    if (availableWidth <= 0)
        return;
    
    NSMutableArray *iconsInCurrentRow = [NSMutableArray array];
    CGFloat currentRowWidth = _currentX;
    
    for (UIView *aView in icons) {
        
        CGFloat nextWidthNeeded = currentRowWidth + self.spacing.width + aView.frame.size.width;
        CGFloat iconCount = iconsInCurrentRow.count;
        // if we have a full row or are at the end, layout icons and flush the icons buffer
        if ((iconCount && nextWidthNeeded > availableWidth) || (self.maxColumns && iconCount >= self.maxColumns))
        {
            [self layoutRow:iconsInCurrentRow width:currentRowWidth];
            
            CGFloat maxHeightInRow = 0;
            for (UIView *rowView in iconsInCurrentRow) {
                if (rowView.frame.size.height > maxHeightInRow)
                    maxHeightInRow = rowView.frame.size.height;
            }
            _currentY += maxHeightInRow + _spacing.height;
            
            [iconsInCurrentRow removeAllObjects];
            currentRowWidth = 0;
        }
        
        // add our view to the queue, which may or may not be emtpy(ied)
        [iconsInCurrentRow addObject:aView];
        currentRowWidth += aView.frame.size.width;
        if ([iconsInCurrentRow count] > 1) {
            currentRowWidth += _spacing.width;        
        }
    }
    // finish the loop
    [self layoutRow:iconsInCurrentRow width:currentRowWidth];
    
    // resize our frame if it is taller/shorter than the requisite icon space.
    CGFloat maxHeight = 0;
    for (UIView *anIcon in iconsInCurrentRow) {
        if (maxHeight < anIcon.frame.size.height)
            maxHeight = anIcon.frame.size.height;
    }
    
    CGFloat bottomY = maxHeight + _currentY + self.bottomPadding;
    
    if (self.frame.size.height != bottomY) {
        CGRect frame = self.frame;
        frame.size.height = bottomY;
        self.frame = frame;
        
		if ([delegate respondsToSelector:@selector(iconGridFrameDidChange:)]) {
			[delegate iconGridFrameDidChange:self];
		}
    }
}

- (void)layoutSubviews {
    for (UIView *aView in self.subviews) {
        [aView removeFromSuperview];
    }
    [super layoutSubviews];
    
    _currentX = 0;
    _currentY = self.topPadding;
    
    [self layoutMoreIcons:self.icons];
}

- (void)layoutRow:(NSArray *)rowIcons width:(CGFloat)rowWidth
{
    if (![rowIcons count]) {
        return;
    }
    
    switch (_alignment) {
        case GridIconAlignmentRight:
            _currentX = self.frame.size.width - self.rightPadding - rowWidth;
            break;
        case GridIconAlignmentCenter:
            _currentX = floor((self.frame.size.width - rowWidth) / 2);
            break;
        case GridIconAlignmentLeft:
        default:
            _currentX = self.leftPadding;
            break;
    }
    
    CGRect currentFrame;
    for (UIView *rowView in rowIcons) {
        rowView.hidden = YES;
        currentFrame = rowView.frame;
        rowView.frame = CGRectMake(_currentX, _currentY, currentFrame.size.width, currentFrame.size.height);
        [self addSubview:rowView];
        
        _currentX += currentFrame.size.width + self.spacing.width;
    }
}

- (void)animationWithRect:(CGRect)originFrame {
    for (UIView *rowView in self.icons) {
        rowView.hidden = NO;
        CGRect oldFrame = rowView.frame;
        rowView.frame = originFrame;
        [UIView animateWithDuration:0.5 
                              delay:0 
                            options:UIViewAnimationOptionLayoutSubviews
                         animations:^{
                             rowView.frame = oldFrame;
                         } 
                         completion:nil];
    }
}

- (void)addIcons:(NSArray *)icons
{
    [self layoutMoreIcons:icons];
    if (!self.icons) {
        self.icons = icons;
    } else {
        self.icons = [self.icons arrayByAddingObjectsFromArray:icons];
    }
}

- (void)dealloc {
    [super dealloc];
}


@end
