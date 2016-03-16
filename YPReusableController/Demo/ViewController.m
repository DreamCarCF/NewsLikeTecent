//
//  ViewController.m
//  YPReusableController
//
//  Created by MichaelPPP on 15/12/28.
//  Copyright (c) 2015年 tyiti. All rights reserved.
//

#import "ViewController.h"
#import "YPReusableController.h"
#import "TestViewControllerOne.h"
#import "TestViewControllerTwo.h"
#import "TestViewControllerThree.h"
#import "TestViewControllerFour.h"
#import "TestViewControllerFive.h"
#import "TestViewControllerSix.h"
#import "TestViewControllerSeven.h"
#import "TestViewController_10.h"
#import "TestViewController_11.h"
#import "TestViewControllerEight.h"
#import "TestViewControllerNine.h"
#import "TestViewControllerNine_12.h"
#import "TestViewControllerNine_13.h"
#import "YPSideController.h"
#import "ConnectServer.h"
#import "YPChannelCustomController.h"
#import "YPBaseNavigationController.h"
#import "TopModel.h"
#import "SearchViewController.h"
#import "YPCacheTool.h"
#import "PaiXuViewController.h"
#import "TouchViewModel.h"
@interface ViewController ()<UIScrollViewDelegate>
{
    NSString *QRUrl;
    NSMutableArray *titleArray;
    int countnum;
    NSMutableArray *subViewController;
    YPReusableController *resusableVc;
    NSArray * _modelArr1;
}
@end

@implementation ViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        titleArray = [NSMutableArray new];
        countnum = 0;
        subViewController = [NSMutableArray new];
        resusableVc = [[YPReusableController alloc] initWithParentViewController:self];
        _modelArr1 = [NSArray new];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.hidden = YES;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"person0"]) {
        [self gosetAgianVC];
    }else{
        [self setDataWithNet];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}



- (void)setDataWithNet
{
    countnum = 0 ;
    QRUrl = knewApi;
    ConnectServer * cs = [ConnectServer shareInstance];
    cs.user_info = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"get_info",@"requestType", nil];
    [cs sendJsonData:nil baseURLWithString:QRUrl FromViewController:self];
    [SVProgressHUD show];
}

#pragma make - ASIhttp delegate
-(void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"连接服务器失败"];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    [titleArray removeAllObjects];
    NSArray *channelTitleArray = [YPCacheTool channelTitleArray];
    
    if (!channelTitleArray) {
        [YPCacheTool removeChannelTitleArray];
    }
    
    
    NSString * requestType = [request.userInfo objectForKey:@"requestType"];
    NSString *response = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error;
    NSDictionary * resultDict = [parser objectWithString:response error:&error];
    if([requestType isEqualToString:@"get_info"]){
        if([[resultDict objectForKey:@"status"] isEqualToString:@"success"]){
            
            [SVProgressHUD dismiss];
            NSMutableArray *dataArry = resultDict[@"data"];
            for (NSDictionary *newdic in dataArry) {
                TopModel * model = [TopModel new];
                model.toptitleString = newdic[@"typename"];
                model.toptitleid = newdic[@"id"];
                NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
             
                [userd setObject:data forKey:[NSString stringWithFormat:@"person%d",countnum++]];
                [userd synchronize];
                [titleArray addObject:data];
                
            }
            [self gosetUserDeualt];
          
        }else{
            NSLog(@"未知错误");
        }
    }else
    {
        NSLog(@"网络错误");
    }
    
    
}

- (void)gosetUserDeualt
{
    NSArray *channelTitleArray = [YPCacheTool channelTitleArray];
    
    if (!channelTitleArray) {
        [YPCacheTool saveChannelTitleArray:titleArray];
    }
    [self gosetVC];
}



- (void)readinfor
{
    QRUrl = knewApi;
    ConnectServer * cs = [ConnectServer shareInstance];
    cs.user_info = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"get_info",@"requestType", nil];
    [cs sendJsonData:nil baseURLWithString:QRUrl FromViewController:self];
    [SVProgressHUD show];

    
}


- (void)gosetAgianVC
{
    
    if (!titleArray) return;
    NSString * string = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filePath = [string stringByAppendingString:@"/modelArray0.swh"];
  
    _modelArr1 = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
  
  
    [subViewController removeAllObjects];
    for (int i = 0; i<_modelArr1.count; i++) {
        
        
        TestViewControllerEight * testVC = [[TestViewControllerEight alloc]init];
        TouchViewModel *model = _modelArr1[i];
        testVC.newsidStr = model.urlString;
        
        [subViewController addObject:testVC];
        
    }
    
    
    for (NSUInteger i = 0; i < subViewController.count; i++) {
        UIViewController *vc = subViewController[i];
        TouchViewModel *model = _modelArr1[i];
        vc.yp_Title = model.title;
    }
    
    
    resusableVc.subViewControllers = nil;
    
    resusableVc.subViewControllers = [subViewController copy];
    resusableVc.currentIndex = 0;
    
    resusableVc.leftImage_normal = [UIImage imageNamed:@"profile_btn_sns_focus.png"];
    
    resusableVc.rightImage_normal = [UIImage imageNamed:@"settings"];
    
    [resusableVc setRightBtnTouchBlock:^{
        
        PaiXuViewController *pvc = [PaiXuViewController new];
        [self.navigationController pushViewController:pvc animated:YES];
    }];
  
    
    [resusableVc setLeftBtnTouchBlock:^{
       
        resusableVc.currentIndex=0;
    }];
}





- (void)gosetVC
{

    if (!titleArray) return;
    
    NSArray *newarray = [YPCacheTool channelTitleArray];
    NSMutableArray * newDataArr = [NSMutableArray new];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    for (int i = 0; i<newarray.count; i++) {
        TopModel *ccc = (TopModel *)[NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:[NSString stringWithFormat:@"person%d",i]]];
        
        TopModel *newMoedel = [TopModel new];
        newMoedel.toptitleString = ccc.toptitleString;
        newMoedel.toptitleid = ccc.toptitleid;
        [newDataArr addObject:newMoedel];
    }
    
    
    [subViewController removeAllObjects];
    for (int i = 0; i<8; i++) {
        
        
    TestViewControllerEight * testVC = [[TestViewControllerEight alloc]init];
        TopModel *model = newDataArr[i];
        testVC.newsidStr = model.toptitleid;
        
    [subViewController addObject:testVC];
    
            }
    
    
    for (NSUInteger i = 0; i < subViewController.count; i++) {
        UIViewController *vc = subViewController[i];
        TopModel *model = newDataArr[i];
        vc.yp_Title = model.toptitleString;
        NSLog(@"%@",vc.yp_Title);
    }
    
    
    resusableVc.subViewControllers = nil;
    
    resusableVc.subViewControllers = [subViewController copy];
    resusableVc.currentIndex = 0;
   
    resusableVc.leftImage_normal = [UIImage imageNamed:@"profile_btn_sns_focus.png"];

    resusableVc.rightImage_normal = [UIImage imageNamed:@"settings"];
   
    [resusableVc setRightBtnTouchBlock:^{

        //测试
        
        PaiXuViewController *pvc = [PaiXuViewController new];
        [self.navigationController pushViewController:pvc animated:YES];
        }];

    
    [resusableVc setLeftBtnTouchBlock:^{
        // 开启侧滑功能
        resusableVc.currentIndex=0;
    }];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSLog(@"11111");
}


@end








































