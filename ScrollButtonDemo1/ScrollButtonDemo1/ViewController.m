//
//  ViewController.m
//  ScrollButtonDemo1
//
//  Created by 叶文宇 on 2018/2/27.
//  Copyright © 2018年 叶文宇. All rights reserved.
//

#import "ViewController.h"
#import "BaseScrollView.h"

@interface ViewController ()<BaseScrollViewDelegate>

@property (strong,nonatomic) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    BaseScrollView *scrollView = [[BaseScrollView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 50) andnameArray:@[@"1",@"2",@"3",@"4"] andIdArray:@[@1,@2,@3,@4]];
    scrollView.tag = 0;
    scrollView.baseScrollViewDelegate = self;
    [self.view addSubview:scrollView];
    
    BaseScrollView *scrollView1 = [[BaseScrollView alloc]initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 50) andnameArray:@[@"1",@"2",@"3",@"4"] andIdArray:@[@1,@2,@3,@4]];
    scrollView1.tag = 1;
    scrollView1.btnWidthFitMode = FontFitMode;
    scrollView1.baseScrollViewDelegate = self;
    [self.view addSubview:scrollView1];
    
    BaseScrollView *scrollView2 = [[BaseScrollView alloc]initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 50) andnameArray:@[@"1",@"2",@"3",@"4"] andIdArray:@[@1,@2,@3,@4]];
    scrollView2.tag = 2;
    scrollView2.btnWidth = 150;
    scrollView2.baseScrollViewDelegate = self;
    [self.view addSubview:scrollView2];
    
    UILabel *label = [BaseButton createLableWithFrame:CGRectMake(0, 350, self.view.frame.size.width, 50) andName:@""];
    label.textAlignment = NSTextAlignmentCenter;
    self.label = label;
    [self.view addSubview:label];
}

-(void)BaseScrollViewSegmentBtnSelectAction:(BaseButton *)button andScrollView:(BaseScrollView *)scrollView{
    
    NSInteger tag = scrollView.tag;
    NSString *currentText = nil;
    
    if(tag == 0){
        currentText = [NSString stringWithFormat:@"视图适应模式按钮%ld",button.targetIndex];
    }else if(tag == 1){
        currentText = [NSString stringWithFormat:@"文字适应模式按钮%ld",button.targetIndex];
    }else if(tag == 2){
        currentText = [NSString stringWithFormat:@"自定义适应模式按钮%ld",button.targetIndex];
    }
    self.label.text = currentText;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
