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
    
    float segmentWidth;
    float segmentHeight;
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
        //button.backgroundColor = [UIColor redColor];
        if(self.btnWidth>0){
            size.width = self.btnWidth;
        }else if(self.btnWidthFitMode == ViewFitMode){
            size.width = self.frame.size.width/segmentBtnArray.count;
        }else if(self.btnWidthFitMode == FontFitMode){
            size = [button.titleLabel FitWithToFontWithFontSize:16];
            size = CGSizeMake(size.width+10, size.height);
        }
        segmentWidth +=size.width;
        [button setFrameWithOrigin:lastBtnPos andSize:CGSizeMake(size.width, segmentHeight)];
        lastBtnPos = CGPointMake(lastBtnPos.x+size.width, lastBtnPos.y);

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
    
    UIImage *btnImage = [UIImage imageNamed:@"按钮.png"];
    CGSize btnImageSize = CGSizeMake(btnImage.size.width, (btnImage.size.height-32)/2);
    UIImage *btnUpImage = [btnImage getSubImage:CGRectMake(0, 0, btnImageSize.width, btnImageSize.height)];
    UIImage *btnDownImage = [btnImage getSubImage:CGRectMake(0, btnImageSize.height+32, btnImageSize.width, btnImageSize.height)];
    for (NSInteger index = 0; index < nameArray.count; index++) {
        BaseButton *segmentBtn = [BaseButton createButton:CGRectZero name:nameArray[index] andAction:@selector(segmentBtnAction:) andTarget:self];
        //设置按钮的背景图片
        [segmentBtn setUpImage:btnUpImage andDownImage:btnDownImage];
         
    
        
        //设置字体大小
        segmentBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        segmentBtn.targetIndex = [idArray[index]integerValue];
        //设置字体颜色
        [segmentBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        
        [segmentBtnArray addObject:segmentBtn];
        [self addSubview:segmentBtn];
        if (index == 0) {
            lastBtn = segmentBtn;
            segmentBtn.isDown = YES;
            self.selectedIndex = segmentBtn.targetIndex;
        }
    }
    
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
        
        if([self.baseScrollViewDelegate respondsToSelector:@selector(BaseScrollViewSegmentBtnSelectAction:andView:)]){
            
            [self.baseScrollViewDelegate BaseScrollViewSegmentBtnSelectAction:button andView:self];
        }
    }
}

@end
