//
//  UIImage+SubImage.h
//  ScrollButtonDemo1
//
//  Created by 叶文宇 on 2018/2/28.
//  Copyright © 2018年 叶文宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SubImage)

-(UIImage*)getSubImage:(CGRect)rect;
-(UIImage*)scaleToSize:(CGSize)size;
@end
