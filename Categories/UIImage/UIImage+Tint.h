//
//  UIImage+Tint.h
//  DemoProj
//
//  Created by Richie Liu on 13-6-21.
//  Copyright (c) 2013年 Richie Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tint)

/**
 *	@brief	Blend image using tint color without gradient.
 *
 *	@param 	tintColor 	Input tint color
 *
 *	@return	Tinted image
 */
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;


/**
 *	@brief	Blend image using tint color with gradient
 *
 *	@param 	tintColor 	Input tint color
 *
 *	@return	Tinted image
 */
- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;


@end
