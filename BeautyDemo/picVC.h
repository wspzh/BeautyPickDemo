//
//  picVC.h
//  GirlFriend
//
//  Created by Colin on 14-5-12.
//  Copyright (c) 2014年 icephone. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ImageWaterView.h"
#import "JSONKit.h"
#import "SVPullToRefresh.h"

#import "ASIHTTPRequest.h"

#import "MJRefresh.h"     //刷新

#import "TGRImageViewController.h"      //图片浏览
#import "TGRImageZoomAnimationController.h"

#import "DXAlertView.h"   //AlertView


#import "ACNavBarDrawer.h" //菜单


@interface picVC : ACBaseViewController<MJRefreshBaseViewDelegate, UIViewControllerTransitioningDelegate, ImageDelegate, ACNavBarDrawerDelegate>
{
    int nowPage;    //记录当前Api start标志
    int nowCount;   //记录当前已经显示的图片数目
    MJRefreshFooterView *footer;    //加载
    MJRefreshHeaderView *header;    //刷新
    
    UIImageView *clickImage;
    
    
    /** 导航栏 按钮 加号 图片 */
    UIImageView *_plusIV;
    
    /** 是否已打开抽屉 */
    BOOL _isOpen;
    
    /** 抽屉视图 */
    ACNavBarDrawer *_drawerView;
    
    //设置用户选择。(图片列表)
    int nowChoose;
    //选择类型数组
    NSArray *chooseArr;
    
    //判断是否是刷新
    BOOL isRefresh_;
    
}


@property (nonatomic,strong)ImageWaterView *waterView;
@property (nonatomic,strong) ASIHTTPRequest *testRequest;


@end
