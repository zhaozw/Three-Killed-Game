/*
 * Copyright © 2010 - 2012 Modo Labs Inc. All rights reserved.
 *
 * The license governing the contents of this file is located in the LICENSE
 * file located at the root directory of this distribution. If the LICENSE file
 * is missing, please contact sales@modolabs.com.
 *
 */

#import "UIKit+KGOAdditions.h"
#import "Foundation+KGOAdditions.h"
static inline double radians (double degrees) {return degrees * M_PI/180;}
@implementation UIImage (KGOAdditions)

// fetch first matching image by override priority:
// local ipad assets (ipad/%@), local assets (%@), kurogo assets (kurogo/%@)
+ (UIImage *)imageWithPathName:(NSString *)pathName {
    UIImage *image = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"ipad/%@", pathName]];
    }
    if (!image) {
        image = [UIImage imageNamed:pathName];
    }
    if (!image) {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"kurogo/%@", pathName]];
    }
    return image;
}

+ (UIImage *)blankImageOfSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0, 0, 0, 0);
    
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageAtRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *subImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return subImage;
}

+ (UIImage *)imageWithName:(NSString *)imageName tableName:(NSString *)tableName {
    UIImage *tableImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",tableName]];
    if (tableImage) {
        NSString *mainFile = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",tableName] ofType:@"plist"];
        NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:mainFile];
        if (dictionary) {
            NSString *rectString = [dictionary stringForKey:imageName];
            if (rectString.length >0) {
                NSArray *values = [rectString componentsSeparatedByString:@","];
                CGRect rect = CGRectMake([[values objectAtIndex:0] floatValue], [[values objectAtIndex:1] floatValue], [[values objectAtIndex:2] floatValue], [[values objectAtIndex:3] floatValue]);
                return [tableImage imageAtRect:rect];
            }
        }
    }
    return nil;
}

+ (UIImage *)rotateImage:(UIImage *)src orientation:(UIImageOrientation)orientation
{
    UIGraphicsBeginImageContext(src.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, radians(90));
    } else if (orientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, radians(-90));
    } else if (orientation == UIImageOrientationDown) {
        // NOTHING
    } else if (orientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, radians(90));
    }
    
    [src drawAtPoint:CGPointMake(0, 0)];
    
    return UIGraphicsGetImageFromCurrentImageContext();
}

@end

@implementation UIColor (KGOAdditions)

/* this function was borrowed for use at MIT from Ars Technica.
 * full source at https://github.com/ars/uicolor-utilities
 * modified in KGO to handle alpha channel using Android RRGGBBAA syntax
 *
 * acceptable formats are
 * @"0099FF" @"#0099FF" @"0x0099FF" @"AA0099FF" @"#AA0099FF" @"0xAA0099FF"
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString  
{
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 - 8 characters
    if ([cString length] < 6) return nil;
    
    // strip 0X and # if they appear
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    NSUInteger length = [cString length];
    if (length != 6 && length != 8) return nil;
    
    NSRange range = NSMakeRange(0, 2);
    
    // get alpha if exists
    CGFloat alpha = 1.0f;
    if (length == 8) {
        unsigned int a;
        [[NSScanner scannerWithString:[cString substringWithRange:range]] scanHexInt:&a];
        alpha = (float) a / 255.0f;
        range.location += 2;
    }
    
    // Separate into r, g, b substrings
    NSString *rString = [cString substringWithRange:range];
    
    range.location += 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location += 2;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

// based on https://github.com/ars/uicolor-utilities/blob/master/UIColor-Expanded.m
// note that iOS 5+ has the method [UIColor getRed:green:blue:alpha:]
- (NSString *)hexString
{
    NSString *result = nil;
    CGFloat red, blue, green, alpha;

    CGColorSpaceModel csm = CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
    if (csm == kCGColorSpaceModelRGB || csm == kCGColorSpaceModelMonochrome) {
        const CGFloat *c = CGColorGetComponents(self.CGColor);
        if (csm == kCGColorSpaceModelMonochrome) {
            red = green = blue = MIN(MAX(c[0], 0.0f), 1.0f);
            alpha = MIN(MAX(c[1], 0.0f), 1.0f);
        } else {
            red = MIN(MAX(c[0], 0.0f), 1.0f);
            green = MIN(MAX(c[1], 0.0f), 1.0f);
            blue = MIN(MAX(c[2], 0.0f), 1.0f);
            alpha = MIN(MAX(c[3], 0.0f), 1.0f);
        }

        if (alpha < 1) {
            result = [NSString stringWithFormat:@"#%02X%02X%02X%02X",
                      (int)roundf(red * 255), (int)roundf(green * 255), (int)roundf(blue * 255), (int)roundf(alpha * 255)];
        } else {
            result = [NSString stringWithFormat:@"#%02X%02X%02X",
                      (int)roundf(red * 255), (int)roundf(green * 255), (int)roundf(blue * 255)];
        }
    }

    return result;
}

@end

@implementation UIImageView (KGOAdditions)

- (void)showLoadingIndicator {
	self.animationImages = [NSArray arrayWithObjects:
							[UIImage imageWithPathName:@"common/loading-animation/iPhoneBusybox_01.png"],
							[UIImage imageWithPathName:@"common/loading-animation/iPhoneBusybox_02.png"],
							[UIImage imageWithPathName:@"common/loading-animation/iPhoneBusybox_03.png"],
							[UIImage imageWithPathName:@"common/loading-animation/iPhoneBusybox_04.png"],
							[UIImage imageWithPathName:@"common/loading-animation/iPhoneBusybox_05.png"],
							[UIImage imageWithPathName:@"common/loading-animation/iPhoneBusybox_06.png"],
							[UIImage imageWithPathName:@"common/loading-animation/iPhoneBusybox_07.png"],
							[UIImage imageWithPathName:@"common/loading-animation/iPhoneBusybox_08.png"],
							[UIImage imageWithPathName:@"common/loading-animation/iPhoneBusybox_09.png"],
							[UIImage imageWithPathName:@"common/loading-animation/iPhoneBusybox_10.png"],
							[UIImage imageWithPathName:@"common/loading-animation/iPhoneBusybox_11.png"],
							[UIImage imageWithPathName:@"common/loading-animation/iPhoneBusybox_12.png"],
							nil];
	
	[self startAnimating];
}

- (void)hideLoadingIndicator {
	[self stopAnimating];
	self.animationImages = nil;
}

@end



@implementation UIButton (KGOAdditions)

+ (UIButton *)genericButtonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    
    UIImage *background = [UIImage imageWithPathName:@"common/toolbar-button"];
    UIImage *pressedBackground = [UIImage imageWithPathName:@"common/toolbar-button"];
    
    [button setBackgroundImage:[background stretchableImageWithLeftCapWidth:8 topCapHeight:8]
                      forState:UIControlStateNormal];
    [button setBackgroundImage:[pressedBackground stretchableImageWithLeftCapWidth:8 topCapHeight:8]
                      forState:UIControlStateHighlighted];

    // TODO: use font config
    UIFont *font = [UIFont boldSystemFontOfSize:13];
    
    CGSize size = [title sizeWithFont:font];
    button.frame = CGRectMake(0, 0, size.width + 16, background.size.height);
    button.titleLabel.font = font;
    
    return button;
}

+ (UIButton *)genericButtonWithImage:(UIImage *)image
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateHighlighted];
    
    UIImage *background = [UIImage imageWithPathName:@"common/toolbar-button"];
    UIImage *pressedBackground = [UIImage imageWithPathName:@"common/toolbar-button"];
    
    [button setBackgroundImage:[background stretchableImageWithLeftCapWidth:8 topCapHeight:8]
                      forState:UIControlStateNormal];
    [button setBackgroundImage:[pressedBackground stretchableImageWithLeftCapWidth:8 topCapHeight:8]
                      forState:UIControlStateHighlighted];
    
    button.frame = CGRectMake(0, 0, image.size.width + 10, image.size.height + 10);
    
    return button;
}

@end

@implementation UITableView (KGOAdditions)

// based on matthew thomas' answer in
// http://stackoverflow.com/questions/4708085/how-to-determine-margin-of-a-grouped-uitableview-or-better-how-to-set-it
- (CGFloat)marginWidth
{
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat marginWidth;
    
    if (selfWidth > 750) {
        marginWidth = 45;
        
    } else if (selfWidth > 400) {
        marginWidth = floor(0.06 * selfWidth);
        
    } else if (selfWidth > 20) {
        marginWidth = 10;
        
    } else {
        marginWidth = selfWidth - 10;
    }
    
    return marginWidth;
}

@end

