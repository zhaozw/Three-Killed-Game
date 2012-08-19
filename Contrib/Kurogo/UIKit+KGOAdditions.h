/*
 * Copyright © 2010 - 2012 Modo Labs Inc. All rights reserved.
 *
 * The license governing the contents of this file is located in the LICENSE
 * file located at the root directory of this distribution. If the LICENSE file
 * is missing, please contact sales@modolabs.com.
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define IS_IPAD_OR_PORTRAIT(orientation) (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || (orientation) == UIInterfaceOrientationPortrait)

@interface UIImage (KGOAdditions)

+ (UIImage *)imageWithPathName:(NSString *)pathName;
+ (UIImage *)blankImageOfSize:(CGSize)size;
- (UIImage *)imageAtRect:(CGRect)rect;
+ (UIImage *)imageWithName:(NSString *)imageName tableName:(NSString *)tableName;
@end

@interface UIColor (KGOAdditions)

+ (UIColor *)colorWithHexString:(NSString *)hexString;
- (NSString *)hexString;

@end

@interface UIImageView (KGOAdditions)

- (void)showLoadingIndicator;
- (void)hideLoadingIndicator;

@end

@interface UIButton (KGOAdditions)

+ (UIButton *)genericButtonWithTitle:(NSString *)title;
+ (UIButton *)genericButtonWithImage:(UIImage *)image;

@end

@interface UITableViewCell (KGOAdditions)

- (void)applyBackgroundThemeColorForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;

@end

@interface UITableView (KGOAdditions)

- (CGFloat)marginWidth;

@end


