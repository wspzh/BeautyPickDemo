//
//  ShowMyLoveVC.h
//  GirlFriend
//
//  Created by Colin on 14-6-13.
//  Copyright (c) 2014年 icephone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLGSlideshowView.h"
#import "ImageWaterView.h"


//按钮样式
#import "NSString+FontAwesome.h"
#import "DXAlertView.h"

@class SLGSlideshowView;


@interface ShowMyLoveVC : UIViewController<SLGSlideshowViewDatasource,SLGSlideshowViewDelegate>
{
    IBOutlet UIBarButtonItem *myBarItem;
    NSArray *_slideshowData;
    NSArray *_transitionOptions;
    
    BOOL isPlay;
    
    /** 导航栏 按钮 加号 图片 */
    UIImageView *_plusIV;
    IBOutlet UIView *myView;
}


@property(nonatomic,readwrite)IBOutlet SLGSlideshowView *slideShowView;


@end
