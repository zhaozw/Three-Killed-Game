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

#import "AutoIconGrid.h"

GridPadding GridPaddingMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
    GridPadding padding = {top, left, bottom, right};
    return padding;
}

GridSpacing GridSpacingMake(CGFloat width, CGFloat height) {
    return (GridSpacing)CGSizeMake(width, height);
}

const GridPadding GridPaddingZero = {0, 0, 0, 0};
const GridSpacing GridSpacingZero = {0, 0};

@interface AutoIconGrid (Private)

- (void)layoutRow:(NSArray *)rowIcons width:(CGFloat)rowWidth;

@end


@implementation AutoIconGrid

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
    if (points) {
        free(points);
        points = NULL;
    }
    points = malloc(icons.count * sizeof(CGPoint));
    if (icons.count == 5) {
        points[0] = CGPointMake(2, 0);
        points[1] = CGPointMake(4, 1);
        points[2] = CGPointMake(3, 3);
        points[3] = CGPointMake(1, 3);
        points[4] = CGPointMake(0, 1);
    } else if (icons.count == 6) {
        points[0] = CGPointMake(2, 0);
        points[1] = CGPointMake(4, 1);
        points[2] = CGPointMake(3, 3);
        points[3] = CGPointMake(2, 3);
        points[4] = CGPointMake(1, 3);
        points[5] = CGPointMake(0, 1);
    } else if (icons.count == 7) {
        points[0] = CGPointMake(2, 0);
        points[1] = CGPointMake(4, 1);
        points[2] = CGPointMake(4, 2);
        points[3] = CGPointMake(3, 3);
        points[4] = CGPointMake(1, 3);
        points[5] = CGPointMake(0, 2);
        points[6] = CGPointMake(0, 1);
    } else if (icons.count == 8) {
        points[0] = CGPointMake(1, 0);
        points[1] = CGPointMake(3, 0);
        points[2] = CGPointMake(4, 1);
        points[3] = CGPointMake(4, 2);
        points[4] = CGPointMake(3, 3);
        points[5] = CGPointMake(1, 3);
        points[6] = CGPointMake(0, 2);
        points[7] = CGPointMake(0, 1);
    } else if (icons.count == 9) {
        points[0] = CGPointMake(1, 0);
        points[1] = CGPointMake(3, 0);
        points[2] = CGPointMake(4, 1);
        points[3] = CGPointMake(4, 2);
        points[4] = CGPointMake(3, 3);
        points[5] = CGPointMake(2, 3);
        points[6] = CGPointMake(1, 3);
        points[7] = CGPointMake(0, 2);
        points[8] = CGPointMake(0, 1);
    } else if (icons.count == 10) {
        points[0] = CGPointMake(1, 0);
        points[1] = CGPointMake(2, 0);
        points[2] = CGPointMake(3, 0);
        points[3] = CGPointMake(4, 1);
        points[4] = CGPointMake(4, 2);
        points[5] = CGPointMake(3, 3);
        points[6] = CGPointMake(2, 3);
        points[7] = CGPointMake(1, 3);
        points[8] = CGPointMake(0, 2);
        points[9] = CGPointMake(0, 1);
    }
    
    for (int i = 0; i < icons.count; i++) {
        CGRect frame = [self iconFrameWithPoint:points[i]];
        UIView *view = [icons objectAtIndex:i];
        view.frame = frame;
        [self addSubview:view];
    }
    
}

- (void)layoutSubviews {
    for (UIView *aView in self.subviews) {
        [aView removeFromSuperview];
    }
    [super layoutSubviews];
    
    _currentX = self.leftPadding;
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
    if (points) {
        free(points);
        points = NULL;
    }
    [super dealloc];
}

- (CGRect)iconFrameWithPoint:(CGPoint)point {
    CGFloat availableWidth = CGRectGetWidth(self.bounds) - self.leftPadding - self.rightPadding;
    CGFloat availableHeight = CGRectGetHeight(self.bounds) - self.topPadding - self.bottomPadding;
    CGFloat widthUnit = floorf(availableWidth / 5);
    CGFloat heightUnit = floorf(availableHeight / 4);
    
    CGFloat x = point.x * widthUnit;
    CGFloat y = point.y * heightUnit;
    return CGRectMake(x, y, widthUnit, heightUnit);
}

- (CGPoint)pointForItemAtViewPoint:(CGPoint)point {
    CGFloat availableWidth = CGRectGetWidth(self.bounds) - self.leftPadding - self.rightPadding;
    CGFloat availableHeight = CGRectGetHeight(self.bounds) - self.topPadding - self.bottomPadding;
    CGFloat widthUnit = floorf(availableWidth / 5);
    CGFloat heightUnit = floorf(availableHeight / 4);
    
    int x = (int)point.x / (int)widthUnit;
    int y = (int)point.y / (int)heightUnit;
    return CGPointMake(x, y);
}

- (NSInteger)indexForItemAtIndexPoint:(CGPoint)point {
    if (points) {
        for (NSInteger index = 0; index < self.icons.count; index++) {
            if (points[index].x == point.x && points[index].y == point.y) {
                return index;
            }
        }
    }
    return NSNotFound;
}

- (NSInteger)indexForItemAtViewPoint:(CGPoint)point {
    return [self indexForItemAtIndexPoint:[self pointForItemAtViewPoint:point]];
}

- (CGRect)iconFrameWithViewPoint:(CGPoint)point {
    return [self iconFrameWithPoint:[self pointForItemAtViewPoint:point]];
}

- (CGPoint)IndexPointAtItemIndex:(NSInteger)index {
    if (points && index < self.icons.count) {
        return points[index];
    }
    return CGPointZero;
}

- (CGRect)iconFrameWithItemIndex:(NSInteger)index {
    return [self iconFrameWithPoint:[self IndexPointAtItemIndex:index]];
}


@end
