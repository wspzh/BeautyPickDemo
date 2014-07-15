//
//  picVC.m
//  GirlFriend
//
//  Created by Colin on 14-5-12.
//  Copyright (c) 2014年 icephone. All rights reserved.
//

#import "picVC.h"

@interface picVC ()

@property (nonatomic,strong) NSMutableDictionary *testDic;
@property (nonatomic,strong) NSMutableArray *testArr;

@end

@implementation picVC
@synthesize testRequest;
@synthesize testArr;
@synthesize testDic;



#pragma mark - 菜单
- (void)navPlusBtnPressed:(UIButton *)sender
{
    // 如果是关，则开，反之亦然
    if (_drawerView.isOpen == NO)
    {
        [_drawerView openNavBarDrawer];
    }
    else
    {
        [_drawerView closeNavBarDrawer];
    }
    
    [self rotatePlusIV];
}

#pragma mark - Rotate _plusIV

- (void)rotatePlusIV
{
    // 旋转加号按钮
    float angle = _drawerView.isOpen ? -M_PI_4 : 0.0f;
    [UIView animateWithDuration:0.2f animations:^{
        _plusIV.transform = CGAffineTransformMakeRotation(angle);
    }];
}

#pragma mark - ACNavBarDrawerDelegate

-(void)theBtnPressed:(UIButton *)theBtn
{
    NSInteger btnTag = theBtn.tag;
    
    NSInteger btnNumber = btnTag;
    
    //如果选择了收藏, 单独处理
    if (btnNumber == 5)
    {
        [self performSegueWithIdentifier:@"showMyLove" sender:self];
        return;
    }

    nowChoose = (int)btnNumber;
    
    
    
    
    //修改标题
    self.navigationItem.title = [chooseArr objectAtIndex:nowChoose];
    
    //切换视图
    [self initWallView];
    [self initWallView];
    
    
    // 点完按钮，旋回加号图片
    [self rotatePlusIV];
}

-(void)theBGMaskTapped
{
    // 触摸背景遮罩时，需要通过回调，旋回加号图片
    [self rotatePlusIV];
}

- (void)initWallView
{
    [self.waterView removeFromSuperview];
    //初始化当前图片数组
    self.testArr = [[NSMutableArray alloc]init];
    clickImage = [[UIImageView alloc]init];
    clickImage.contentMode = UIViewContentModeScaleAspectFill;
    
    //读取沙盒数据
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * namePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"savedPicInfo_%d.plist",nowChoose]];
    NSMutableArray *picArr = [[NSMutableArray alloc] initWithContentsOfFile:namePath];
    
    nowCount = 0;
    nowPage = 1;
    //打开沙盒, 查找文件.
    if (picArr)
    {
        //文件存在, 直接读取
        for (int i=0; i<8; i++)
        {
            NSDictionary *dataD = [picArr objectAtIndex:i];
            if (dataD)
            {
                nowCount++;
                ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:dataD];
                [testArr addObject:imageInfo];
            }
        }
        nowPage = [picArr count];
    }
    else
    {
        //文件不存在, 新建并且写入数据。
        //利用用户信息, 查询结果
        NSString* urlString = [NSString stringWithFormat:@"http://image.baidu.com/channel/listjson?pn=%d&rn=10&tag1=美女&tag2=%@", nowPage, [chooseArr objectAtIndex:nowChoose]];
        
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlString];
        testRequest = [ASIHTTPRequest requestWithURL:url];
        [testRequest setDelegate:self];
        [testRequest startAsynchronous];
    }
    
    self.waterView = [[ImageWaterView alloc]initWithDataArray:testArr withFrame:CGRectMake(0, 44, 320, Screen_height-44)];
    
    self.waterView.delegate = self;
    [self.view addSubview:self.waterView];
    
    //上提加载更多
    footer = [MJRefreshFooterView footer];
    footer.scrollView = self.waterView;
    footer.delegate = self;
    
    //下拉刷新
    header = [MJRefreshHeaderView header];
    header.scrollView = self.waterView;
    header.delegate = self;
    
    [self.waterView refreshView:testArr];

    [self.view sendSubviewToBack:self.waterView];
}

- (void)initWallView_Two
{
    
}


-(void)myRefreshLogic
{
    [self.waterView removeFromSuperview];
    //初始化当前图片数组
    self.testArr = [[NSMutableArray alloc]init];
    clickImage = [[UIImageView alloc]init];
    clickImage.contentMode = UIViewContentModeScaleAspectFill;
    
    nowCount = 0;
    nowPage = 1;
    
    nowPage = arc4random() % 20;
    //利用用户信息, 查询结果
    NSString* urlString = [NSString stringWithFormat:@"http://image.baidu.com/channel/listjson?pn=%d&rn=10&tag1=美女&tag2=%@", nowPage, [chooseArr objectAtIndex:nowChoose]];
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    testRequest = [ASIHTTPRequest requestWithURL:url];
    [testRequest setDelegate:self];
    [testRequest startAsynchronous];
    self.waterView = [[ImageWaterView alloc]initWithDataArray:testArr withFrame:CGRectMake(0, 44, 320, Screen_height-44)];
    
    self.waterView.delegate = self;
    [self.view addSubview:self.waterView];
    
    //上提加载更多
    footer = [MJRefreshFooterView footer];
    footer.scrollView = self.waterView;
    footer.delegate = self;
    
    //下拉刷新
    header = [MJRefreshHeaderView header];
    header.scrollView = self.waterView;
    header.delegate = self;
    
    [self.waterView refreshView:testArr];
    
    [self.view sendSubviewToBack:self.waterView];
    
    isRefresh_ = true;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isRefresh_ = false;
    
    //用户选择
    nowChoose = 0;
    chooseArr = [NSArray arrayWithObjects:@"校花", @"车模", @"制服", @"御姐", @"萝莉", nil];
    
    //修改标题
    self.navigationItem.title = [chooseArr objectAtIndex:nowChoose];
    
    //初始化当前图片数组
    self.testArr = [[NSMutableArray alloc]init];
    clickImage = [[UIImageView alloc]init];
    clickImage.contentMode = UIViewContentModeScaleAspectFill;
    
    //读取沙盒数据
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * namePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"savedPicInfo_%d.plist",nowChoose]];
    NSMutableArray *picArr = [[NSMutableArray alloc] initWithContentsOfFile:namePath];
    
    nowCount = 0;
    nowPage = 1;
    //打开沙盒, 查找文件.
    if ( !picArr )
    {
        //文件不存在, 读取本地的
        NSString *path = [[NSBundle mainBundle]pathForResource:@"initArr" ofType:@"plist"];
        // Load the file content and read the data into arrays
        picArr= [[NSMutableArray alloc] initWithContentsOfFile:path];
    }

    //文件存在, 直接读取
    for (int i=0; i<8; i++)
    {
        NSDictionary *dataD = [picArr objectAtIndex:i];
        if (dataD)
        {
            nowCount++;
            ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:dataD];
            [testArr addObject:imageInfo];
        }
    }
    nowPage = [picArr count];
    
    self.waterView = [[ImageWaterView alloc]initWithDataArray:testArr withFrame:CGRectMake(0, 44, 320, Screen_height-44)];
    
    self.waterView.delegate = self;
    [self.view addSubview:self.waterView];
    
    //上提加载更多
    footer = [MJRefreshFooterView footer];
    footer.scrollView = self.waterView;
    footer.delegate = self;
    
    //下拉刷新
    header = [MJRefreshHeaderView header];
    header.scrollView = self.waterView;
    header.delegate = self;

    
    //** barButton *********************************************************************************
    CGFloat navRightBtn_w = 40.f;
    CGFloat navRightBtn_h = 30.f;
    CGFloat navRightBtn_x = App_Frame_Width - 10.f;
    CGFloat navRightBtn_y = (kTopBarHeight - navRightBtn_h) / 2.f;
    
    UIButton *navRightBtn = [[UIButton alloc] init];
    [navRightBtn setFrame:CGRectMake(navRightBtn_x,
                                     navRightBtn_y,
                                     navRightBtn_w,
                                     navRightBtn_h)];
    
    // 按钮背景图片
    //UIImage *navRightBtnBGImg = PNGIMAGE(@"nav_btn");
    //[navRightBtn setBackgroundImage:navRightBtnBGImg forState:UIControlStateNormal];
    
    
    //-- 按钮上的图片 --------------------------------------------------------------------------------
    CGFloat plusIV_w = 20.f;
    CGFloat plusIV_h = 20.f;
    CGFloat plusIV_x = (navRightBtn.bounds.size.width - plusIV_w) / 2.f;
    CGFloat plusIV_y = (navRightBtn.bounds.size.height - plusIV_h) / 2.f;
    
    _plusIV = [[UIImageView alloc] initWithImage:PNGIMAGE(@"c_nav-60-60")];
    [_plusIV setFrame:CGRectMake(plusIV_x,
                                 plusIV_y,
                                 plusIV_w,
                                 plusIV_h)];
    
    [navRightBtn addSubview:_plusIV];
    //---------------------------------------------------------------------------------------------;
    
    
    // 设置按钮点击时调用的方法
    [navRightBtn addTarget:self action:@selector(navPlusBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:navRightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    //*********************************************************************************************;
    
    
    //** 抽屉 *******************************************************************************
    
    //-- 按钮信息 -------------------------------------------------------------------------------
    // 就不建数据对象了，第一个为图片名、第二个为按钮名
    NSArray *item_01 = [NSArray arrayWithObjects:@"item_1", @"校花", nil];
    NSArray *item_02 = [NSArray arrayWithObjects:@"item_2", @"车模", nil];
    NSArray *item_03 = [NSArray arrayWithObjects:@"item_3", @"制服", nil];
    NSArray *item_04 = [NSArray arrayWithObjects:@"item_4", @"御姐", nil];
    NSArray *item_05 = [NSArray arrayWithObjects:@"item_5", @"萝莉", nil];
    NSArray *item_06 = [NSArray arrayWithObjects:@"item_6", @"收藏", nil];
    
    // 最好是 2-5 个按钮，1个很2，5个以上很丑
    NSArray *allItems = [NSArray arrayWithObjects:item_01,item_02,item_03, item_04, item_05, item_06, nil];
    
    _drawerView = [[ACNavBarDrawer alloc] initWithView:self.view andItemInfoArray:allItems];
    _drawerView.delegate = self;
    
    
    
}

#pragma mark - 刷新控件的代理方法
#pragma mark 开始进入刷新状态
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{

    //如果是刷新
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]])
    {
        [self myRefreshLogic];
    }
    else
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString * namePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"savedPicInfo_%d.plist",nowChoose]];
        NSMutableArray *picArr = [[NSMutableArray alloc] initWithContentsOfFile:namePath];
        
        //去除重复
        for (int i =(int)([picArr count]-1); i>=0; i--)
        {
            for (int j=0; j<i; j++)
            {
                if ([[[picArr objectAtIndex:i]objectForKey:@"image_url"]isEqualToString:[[picArr objectAtIndex:j]objectForKey:@"image_url"]])
                {
                    [picArr removeObjectAtIndex:i];
                    break;
                }
            }
        }

        //还没读取完本地的
        if (nowCount + 8 < [picArr count])
        {
            NSMutableArray *nowArr = [[NSMutableArray alloc]init];
            //写入新数据
            for (int i=nowCount; i<nowCount+8; i++)
            {
                //写入当前显示数组
                NSDictionary *dataD = [picArr objectAtIndex:i];
                if (dataD)
                {
                    ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:dataD];
                    [testArr addObject:imageInfo];
                    [nowArr addObject:imageInfo];
                }
            }
            nowCount+=8;
            //添加上拉加载更多
            __weak picVC *blockSelf = self;
            [blockSelf.waterView loadNextPage:nowArr];
            [blockSelf.waterView.infiniteScrollingView stopAnimating];
        }
        else    //读取完本地的
        {
            nowPage+=30;
            //利用用户信息, 查询结果
            NSString* urlString = [NSString stringWithFormat:@"http://image.baidu.com/channel/listjson?pn=%d&rn=10&tag1=美女&tag2=%@", nowPage, [chooseArr objectAtIndex:nowChoose]];
            urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:urlString];
            testRequest = [ASIHTTPRequest requestWithURL:url];
            [testRequest setDelegate:self];
            [testRequest startAsynchronous];
        }
    }
    

    // 2.2秒后刷新表格UI
    [self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
}



#pragma mark - UIViewControllerTransitioningDelegate methods
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    if ([presented isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:clickImage];
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if ([dismissed isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:clickImage];
    }
    return nil;
}
#pragma mark - Private methods
//单击, 显示大图
-(void)showImage:(ImageInfo*)data
{
    NSURL *url = [NSURL URLWithString:data.thumbURL];
    [clickImage setImageWithURL:url placeholderImage:nil];
    TGRImageViewController *viewController = [[TGRImageViewController alloc] initWithImage:clickImage.image setImageInfo:data];
    viewController.transitioningDelegate = self;
    [self presentViewController:viewController animated:YES completion:nil];
}


//长按, 删除图片
-(void)removeImage:(ImageInfo*)data
{
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"您是否确定要删除该图片" leftButtonTitle:@"是" rightButtonTitle:@"否"];
    [alert show];
    alert.leftBlock = ^()
    {
        //从当前视图中删除
        [testArr removeObject:data];
        //刷新数据
        __weak picVC *blockSelf = self;
        [blockSelf.waterView refreshView:testArr];
        [blockSelf.waterView.infiniteScrollingView stopAnimating];
        
        //从沙盒中删除
        //打开沙盒
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString * namePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"savedPicInfo_%d.plist",nowChoose]];
        NSMutableArray *picArray = [[NSMutableArray alloc] initWithContentsOfFile:namePath];
        
        for (int i=0; i<[picArray count]; i++)
        {
            if ([[[picArray objectAtIndex:i]objectForKey:@"image_url"] isEqualToString:data.thumbURL])
            {
                [picArray removeObjectAtIndex:i];
                break;
            }
        }
        [picArray writeToFile:namePath atomically:YES];
        
    };
    alert.rightBlock = ^()
    {
    };
    alert.dismissBlock = ^()
    {
    };
}

#pragma mark 刷新完毕
- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView
{
}
#pragma mark 监听刷新状态的改变
- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state
{
}
#pragma mark 刷新表格并且结束正在刷新状态
- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

#pragma mark - 加载数据完毕
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSMutableArray *nowArr = [[NSMutableArray alloc]init];
    
    //当以二进制读取返回内容时用这个方法
    NSData *responseData = [request responseData];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    self.testDic = [responseString objectFromJSONString];
    
    NSArray *array = [testDic objectForKey:@"data"];

    //打开沙盒
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * namePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"savedPicInfo_%d.plist",nowChoose]];
    NSMutableArray *picArray = [[NSMutableArray alloc] initWithContentsOfFile:namePath];
    
    if (picArray == NULL)
    {
        picArray = [[NSMutableArray alloc]initWithArray:array];
    }
    //写入新数据
    for (int i=0; i<[array count]; i++)
    {
        //旧数组中不存在,存入沙盒
        if ( ![picArray containsObject:[array objectAtIndex:i]])
        {
            NSMutableDictionary *nowDic = [[NSMutableDictionary alloc]init];
            [nowDic setObject:[[array objectAtIndex:i]objectForKey:@"image_url"] forKey:@"image_url"];
            [nowDic setObject:[[array objectAtIndex:i]objectForKey:@"image_width"] forKey:@"image_width"];
            [nowDic setObject:[[array objectAtIndex:i]objectForKey:@"image_height"] forKey:@"image_height"];
            [nowDic setObject:[[array objectAtIndex:i]objectForKey:@"desc"] forKey:@"desc"];

            [picArray addObject:nowDic];
            //写入当前显示数组
            NSDictionary *dataD = nowDic;
            if (dataD)
            {
                ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:dataD];
                
                if (imageInfo.thumbURL.length > 8)
                {
                    [testArr addObject:imageInfo];
                    [nowArr addObject:imageInfo];
                    nowCount++;
                }
            }
        }
    }
    [picArray writeToFile:namePath atomically:YES];
    
    //添加数据
    __weak picVC *blockSelf = self;
    [blockSelf.waterView loadNextPage:nowArr];
    [blockSelf.waterView.infiniteScrollingView stopAnimating];
}


//弹出框自动消失
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"系统繁忙, 请稍后重试"  delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
    
    if (isRefresh_)
    {
        //切换视图
        [self initWallView];
        [self initWallView];

        
        isRefresh_ = false;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 消失时 关闭抽屉
    _isOpen = NO;
    [_drawerView closeNavBarDrawer];
    
    // 旋回加号图片
    [self rotatePlusIV];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
