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

#import <UIKit/UIKit.h>

struct GridPadding {
    CGFloat top;
    CGFloat right;
    CGFloat bottom;
    CGFloat left;
};
typedef struct GridPadding GridPadding;
typedef CGSize GridSpacing;

GridPadding GridPaddingMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right);
GridSpacing GridSpacingMake(CGFloat width, CGFloat height);

extern const GridPadding GridPaddingZero;
extern const GridSpacing GridSpacingZero;


typedef enum {
    GridIconAlignmentLeft,
    GridIconAlignmentCenter,
    GridIconAlignmentRight,
} GridIconAlignment;

@protocol IconGridDelegate;

@interface AutoIconGrid : UIView {
    
	id<IconGridDelegate> delegate;

    // these determine where the next icon should be placed
    CGFloat _currentX;
    CGFloat _currentY;
    CGPoint *points;
}

- (void)addIcons:(NSArray *)icons;

@property (nonatomic, assign) id<IconGridDelegate> delegate;

@property GridPadding padding;
@property GridSpacing spacing;
@property NSInteger maxColumns; // specify 0 to fit as many columns as possible
@property GridIconAlignment alignment;
@property (nonatomic, retain) NSArray *icons;

@property CGFloat topPadding;
@property CGFloat rightPadding;
@property CGFloat bottomPadding;
@property CGFloat leftPadding;
- (void)animationWithRect:(CGRect)originFrame;
- (NSInteger)indexForItemAtViewPoint:(CGPoint)point;
- (CGRect)iconFrameWithViewPoint:(CGPoint)point;
- (CGRect)iconFrameWithItemIndex:(NSInteger)index;
@end

@protocol IconGridDelegate <NSObject>

- (void)iconGridFrameDidChange:(AutoIconGrid *)iconGrid;

@end

