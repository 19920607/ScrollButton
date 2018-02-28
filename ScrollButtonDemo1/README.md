# ScrollButton
滑动按钮
============

  之前因为项目需要，做了一个滑动分段按钮，现在才有空分享出来，虽然很简单，但是还是要写出来作为自己已经学会了的小小证明，好了先上图

![img](https://github.com/Yewenyu/ScrollButton/blob/master/ScrollButtonDemo1/ScrollButtonGif.gif)

  如图，主要有三种适应模式对应的属性是btnWidthFitMode，第一种是视图适应模式（ViewFitMode），就是所有的按钮都会显示在视图中并填满ScrollView的width，第二种是文字适应模式(FontFitMode)，就是所有按钮会根据按钮名字自动调整width，第三种是自定义模式，只需要直接对btnWidth赋值就可以，要注意的是如果对这个属性赋值后，btnWidthFitMode这个属性会自动失效。
  要创建一个滑动按钮，需要一个名字数组和id数组，并实现按钮事件代理，代码如下：
  '''object-c
  BaseScrollView *scrollView = [[BaseScrollView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 50) andnameArray:@[@"1",@"2",@"3",@"4"] andIdArray:@[@1,@2,@3,@4]];
  scrollView.tag = 0;
  scrollView.baseScrollViewDelegate = self;
  [self.view addSubview:scrollView];
  '''
具体可以下载demo查看，谢谢
