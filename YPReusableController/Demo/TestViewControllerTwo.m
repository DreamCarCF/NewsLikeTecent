//
//  TestViewControllerTwo.m
//  YPReusableController
//
//  Created by MichaelPPP on 15/12/28.
//  Copyright (c) 2015年 tyiti. All rights reserved.
//

#import "TestViewControllerTwo.h"
#import "YPReusableControllerConst.h"
#import "newTabelViewController.h"
#import "CustomTableViewCell.h"
@interface TestViewControllerTwo ()

@end

@implementation TestViewControllerTwo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YPLog(@"第二个控制器加载完毕");
    
    self.view.backgroundColor = YPRandomColor_RGB;
    newTabelViewController *tabelView = [[newTabelViewController alloc]init];
    tabelView.view.frame = self.view.frame;
    tabelView.currentString = self.newsidStr;
    tabelView.theKeyWord = nil;
      [tabelView logThetid:tabelView.currentString];
    [self addChildViewController:tabelView];
    
    [self.view addSubview:tabelView.view];
}

@end
