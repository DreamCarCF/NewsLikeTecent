//
//  TestViewControllerSix.m
//  YPReusableController
//
//  Created by MichaelPPP on 15/12/28.
//  Copyright (c) 2015年 tyiti. All rights reserved.
//

#import "TestViewControllerSix.h"
#import "YPReusableControllerConst.h"
#import "newTabelViewController.h"
#import "CustomTableViewCell.h"
@interface TestViewControllerSix ()

@end

@implementation TestViewControllerSix

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YPLog(@"第六个控制器加载完毕");
    newTabelViewController *tabelView = [[newTabelViewController alloc]init];
    tabelView.view.frame = self.view.frame;
    tabelView.currentString = self.newsidStr;
    tabelView.theKeyWord = nil;
    [self addChildViewController:tabelView];
    [tabelView logThetid:tabelView.currentString];
    [self.view addSubview:tabelView.view];
    self.view.backgroundColor = YPRandomColor_RGB;
}

@end
