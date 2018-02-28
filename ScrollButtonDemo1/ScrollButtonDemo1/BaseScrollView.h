//
//  BaseScrollView.h
//  ProductModifier
//
//  Created by 叶文宇 on 2017/6/27.
//  Copyright © 2017年 优珥格. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseButton.h"

@class BaseScrollView;
@protocol BaseScrollViewDelegate<NSObject>

@optional

/**分段按钮的代理事件**/
-(void)BaseScrollViewSegmentBtnSelectAction:(BaseButton*)button andScrollView:(BaseScrollView*)scrollView;

@end
@interface BaseScrollView : UIScrollView

/**按钮宽度适应模式**/
typedef NS_ENUM(NSUInteger, BtnWidthFitMode) {
    
    FontFitMode,//适应文字模式
    ViewFitMode,//适应视图模式
};
@property (weak)id<BaseScrollViewDelegate>baseScrollViewDelegate;

/**当前选中的按钮索引**/
@property NSInteger selectedIndex;
/**按钮宽度适应模式，默认ViewFitMode**/
@property BtnWidthFitMode btnWidthFitMode;
/**按钮文字大小，默认为16**/
@property CGFloat btnFontSize;
/**按钮宽度,如果大于0，按钮会强制使用这个宽度，就是适应模式会失效**/
@property CGFloat btnWidth;

/**创建**/
-(instancetype)initWithFrame:(CGRect)frame andnameArray:(NSArray*)nameArray andIdArray:(NSArray*)idArray;

@end
