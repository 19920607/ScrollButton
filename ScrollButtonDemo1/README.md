# ScrollButton
滑动按钮
============

  &emsp;&emsp;之前因为项目需要，做了一个滑动分段按钮，现在才有空分享出来，虽然很简单，但是还是要写出来作为自己已经学会了的小小证明，好了先上图

![ScrollButtonGif.gif](http://upload-images.jianshu.io/upload_images/4092192-992cae4feab85962.gif?imageMogr2/auto-orient/strip)


&emsp;&emsp;如图，主要有三种适应模式对应的属性是btnWidthFitMode，第一种是视图适应模式（ViewFitMode），就是所有的按钮都会显示在视图中并填满ScrollView的width，第二种是文字适应模式(FontFitMode)，就是所有按钮会根据按钮名字自动调整width，第三种是自定义模式，只需要直接对btnWidth赋值就可以，要注意的是如果对这个属性赋值后，btnWidthFitMode这个属性会自动失效。
&emsp;&emsp;要创建一个滑动按钮，需要一个名字数组和id数组，并实现按钮事件代理，代码如下：
  
  创建
```
  BaseScrollView *scrollView = [[BaseScrollView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 50) andnameArray:@[@"1",@"2",@"3",@"4"] andIdArray:@[@1,@2,@3,@4]];
  scrollView.tag = 0;
  scrollView.baseScrollViewDelegate = self;
  [self.view addSubview:scrollView];
```
  代理事件
```
-(void)BaseScrollViewSegmentBtnSelectAction:(BaseButton *)button andScrollView:(BaseScrollView *)scrollView{
    
    //do something
}
```
&emsp;&emsp;其中代理事件中的button属性为当前选中的button，scrollView为当前触摸的BaseScrollView。

&emsp;&emsp;下面介绍一下BaseScrollView的结构，上代码
```
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
```

&emsp;&emsp;然后是关键代码

创建多个按钮的代码
```
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
```
布局代码
```
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
```
&emsp;&emsp;难点还是按钮布局的逻辑，不过也不是太难，只要累加按钮的width就能计算出按钮的正确位置。
&emsp;&emsp;介绍到这里吧，具体可以下载demo查看，如有错漏请指正，谢谢

&emsp;&emsp;简书地址:[小点草](https://www.jianshu.com/u/c6ae89bfef25) 


*邮箱：289193866@qq.com
