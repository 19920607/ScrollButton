//
//  BaseScrollView.m
//  ProductModifier
//
//  Created by 叶文宇 on 2017/6/27.
//  Copyright © 2017年 优珥格. All rights reserved.
//

#import "BaseScrollView.h"
#import "UIImage+SubImage.h"


@implementation BaseScrollView{
    
    NSMutableArray *segmentBtnArray;
    
    id lastBtn;
    
    CGFloat segmentWidth;
    CGFloat segmentHeight;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame andnameArray:(NSArray*)nameArray andIdArray:(NSArray*)idArray{
    
    self = [self initWithFrame:frame];
    
    if(self){
        self.btnWidthFitMode = ViewFitMode;
        self.btnWidth = 0;
        self.btnFontSize = 16;
        [self createSelfWithandnameArray:nameArray andIdArray:idArray];
    }
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    segmentHeight = self.frame.size.height;
    
    segmentWidth = 0;
    
    CGPoint lastBtnPos = CGPointMake(0, 0);
    for (NSInteger index = 0; index < segmentBtnArray.count; index++){
        CGSize size = CGSizeZero;
        BaseButton *button = segmentBtnArray[index];
        
        /**根据适应模式调整按钮宽度以及位置**/
        if(self.btnWidth>0){
            size.width = self.btnWidth;
        }else if(self.btnWidthFitMode == ViewFitMode){
            size.width = self.frame.size.width/segmentBtnArray.count;
        }else if(self.btnWidthFitMode == FontFitMode){
            //获取文字自适应Size
            size = [button.titleLabel FitWithToFontWithFontSize:16];
            size = CGSizeMake(size.width+10, size.height);
        }
        segmentWidth +=size.width;
        [button setFrameWithOrigin:lastBtnPos andSize:CGSizeMake(size.width, segmentHeight)];
        lastBtnPos = CGPointMake(lastBtnPos.x+size.width, lastBtnPos.y);
        /**根据适应模式调整按钮宽度以及位置**/

    }
    CGSize contentSize = CGSizeMake(segmentWidth, segmentHeight);
    if(contentSize.width>self.frame.size.width){
        self.contentSize = contentSize;
    }else{
        self.contentSize = self.frame.size;
    }
}

/**根据提供的数组创建分段按钮**/
-(void)createSelfWithandnameArray:(NSArray*)nameArray andIdArray:(NSArray*)idArray{
    
    if(!nameArray){
        return;
    }
    //分段按钮数组初始化
    segmentBtnArray = [NSMutableArray array];
    
    /**截取按钮图片**/
    UIImage *btnImage = [UIImage imageNamed:@"按钮.png"];
    CGSize btnImageSize = CGSizeMake(btnImage.size.width, (btnImage.size.height-32)/2);
    UIImage *btnUpImage = [btnImage getSubImage:CGRectMake(0, 0, btnImageSize.width, btnImageSize.height)];
    UIImage *btnDownImage = [btnImage getSubImage:CGRectMake(0, btnImageSize.height+32, btnImageSize.width, btnImageSize.height)];
    /**截取按钮图片**/
    
    /**创建按钮**/
    for (NSInteger index = 0; index < nameArray.count; index++) {
        
        //这里是封装了按钮的创建代码，主要是嫌麻烦，想一步到位
        BaseButton *segmentBtn = [BaseButton createButton:CGRectZero name:nameArray[index] andAction:@selector(segmentBtnAction:) andTarget:self];
        //设置按钮的背景图片
        [segmentBtn setUpImage:btnUpImage andDownImage:btnDownImage];
        //设置字体大小
        segmentBtn.titleLabel.font = [UIFont systemFontOfSize:self.btnFontSize];
        segmentBtn.targetIndex = [idArray[index]integerValue];
        //设置字体颜色
        [segmentBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        
        //添加到按钮数组中
        [segmentBtnArray addObject:segmentBtn];
        [self addSubview:segmentBtn];
        if (index == 0) {
            lastBtn = segmentBtn;
            //改变isDown的值会自动变化背景图
            segmentBtn.isDown = YES;
            self.selectedIndex = segmentBtn.targetIndex;
        }
    }
    /**创建按钮**/
    
}

/**分段按钮事件**/
-(void)segmentBtnAction:(BaseButton*)button{
    
    //上个选中按钮取消选中
    [lastBtn setIsDown:NO];
    lastBtn = button;
     button.isDown = YES;
    self.selectedIndex = button.targetIndex;
   
    //执行代理事件
    if(self.baseScrollViewDelegate){
        
        if([self.baseScrollViewDelegate respondsToSelector:@selector(BaseScrollViewSegmentBtnSelectAction:andScrollView:)]){
            
            [self.baseScrollViewDelegate BaseScrollViewSegmentBtnSelectAction:button andScrollView:self];
        }
    }
}

@end
