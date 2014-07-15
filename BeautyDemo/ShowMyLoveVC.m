//
//  ShowMyLoveVC.m
//  GirlFriend
//
//  Created by Colin on 14-6-13.
//  Copyright (c) 2014年 icephone. All rights reserved.
//

#import "ShowMyLoveVC.h"

@interface ShowMyLoveVC ()

@end

@implementation ShowMyLoveVC
@synthesize slideShowView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Rotate _plusIV

- (void)rotatePlusIV
{
    // 旋转加号按钮
    float angle = (!isPlay) ? -M_PI_4 : 0.0f;
    [UIView animateWithDuration:0.2f animations:^{
        _plusIV.transform = CGAffineTransformMakeRotation(angle);
    }];
}

#pragma mark - 菜单
- (void)navPlusBtnPressed:(UIButton *)sender
{
    if ([_slideshowData count] == 0)
    {
        UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"您还未添加任何图片,暂不能播放" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        
        [NSTimer scheduledTimerWithTimeInterval:1.5f
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:promptAlert
                                        repeats:YES];
        [promptAlert show];
    }
    else
    {
        
        if ( !isPlay )
        {
            isPlay = true;
            [self.slideShowView myResumeLogic];
            [myView setHidden:true];
        }
        else
        {
            isPlay = false;
            [self.slideShowView myStopLogic];
            
            [myView setHidden:false];
            
        }
    }
    
    [self rotatePlusIV];
}
//停止播放
- (void)viewWillDisappear:(BOOL)animated
{
    [self.slideShowView stopSlideShow];
    isPlay = false;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    isPlay = true;
    // Do any additional setup after loading the view.
    
    _transitionOptions= @[[NSNumber numberWithInteger:UIViewAnimationOptionTransitionFlipFromLeft],
                          [NSNumber numberWithInteger:UIViewAnimationOptionTransitionFlipFromRight],
                          [NSNumber numberWithInteger:UIViewAnimationOptionTransitionCurlUp],
                          [NSNumber numberWithInteger:UIViewAnimationOptionTransitionCurlDown],
                          [NSNumber numberWithInteger:UIViewAnimationOptionTransitionCrossDissolve],
                          [NSNumber numberWithInteger:UIViewAnimationOptionTransitionFlipFromTop],
                          [NSNumber numberWithInteger:UIViewAnimationCurveEaseIn],
                          [NSNumber numberWithInteger:UIViewAnimationCurveEaseOut],
                          [NSNumber numberWithInteger:UIViewAnimationCurveLinear],
                          [NSNumber numberWithInteger:UIViewAnimationOptionAllowAnimatedContent],
                          [NSNumber numberWithInteger:UIViewAnimationOptionOverrideInheritedCurve],
                          [NSNumber numberWithInteger:UIViewAnimationOptionTransitionFlipFromTop],
                          [NSNumber numberWithInteger:UIViewAnimationOptionTransitionFlipFromBottom]];
    
    
    //打开沙盒
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * namePath = [documentsDirectory stringByAppendingPathComponent:@"myLove.plist"];
    NSMutableArray *picArray = [[NSMutableArray alloc] initWithContentsOfFile:namePath];
    
    if (picArray == NULL)
    {
        //文件不存在, 读取本地的
        NSString *path = [[NSBundle mainBundle]pathForResource:@"myLove" ofType:@"plist"];
        // Load the file content and read the data into arrays
        picArray= [[NSMutableArray alloc] initWithContentsOfFile:path];
    }
    _slideshowData =[NSArray arrayWithObjects:picArray,nil];
    
    
    [self.slideShowView beginSlideShow];
    
    
    //按钮菜单
    
    //删除按钮
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [deleteBtn setTitle:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FAIconRemove]] forState:UIControlStateNormal];
    [deleteBtn.titleLabel setFont:[UIFont fontWithName:@"FontAwesome" size:15]];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteBtn.layer.borderWidth = 1;
    deleteBtn.layer.cornerRadius = 4.0;
    deleteBtn.layer.masksToBounds = YES;
    [deleteBtn setAdjustsImageWhenHighlighted:NO];
    deleteBtn.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
    deleteBtn.layer.borderColor = [[UIColor colorWithRed:212/255.0 green:63/255.0 blue:58/255.0 alpha:1] CGColor];
    deleteBtn.frame =CGRectMake(54,2, 30, 30);
    [deleteBtn addTarget:self action:@selector(delectBtnClick:)forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:deleteBtn];
    
    UIButton *preBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [preBtn setTitle:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FAIconArrowLeft]] forState:UIControlStateNormal];
    [preBtn.titleLabel setFont:[UIFont fontWithName:@"FontAwesome" size:15]];
    [preBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    preBtn.layer.borderWidth = 1;
    preBtn.layer.cornerRadius = 4.0;
    preBtn.layer.masksToBounds = YES;
    [preBtn setAdjustsImageWhenHighlighted:NO];
    preBtn.backgroundColor = [UIColor colorWithRed:92/255.0 green:184/255.0 blue:92/255.0 alpha:1];
    preBtn.layer.borderColor = [[UIColor colorWithRed:76/255.0 green:174/255.0 blue:76/255.0 alpha:1] CGColor];
    preBtn.frame =CGRectMake(12,2, 30, 30);
    [preBtn addTarget:self action:@selector(preBtnClick:)forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:preBtn];
    
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextBtn setTitle:[NSString stringWithFormat:@" %@ ",[NSString fontAwesomeIconStringForEnum:FAIconArrowRight]] forState:UIControlStateNormal];
    [nextBtn.titleLabel setFont:[UIFont fontWithName:@"FontAwesome" size:15]];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.layer.borderWidth = 1;
    nextBtn.layer.cornerRadius = 4.0;
    nextBtn.layer.masksToBounds = YES;
    [nextBtn setAdjustsImageWhenHighlighted:NO];
    nextBtn.backgroundColor = [UIColor colorWithRed:92/255.0 green:184/255.0 blue:92/255.0 alpha:1];
    nextBtn.layer.borderColor = [[UIColor colorWithRed:76/255.0 green:174/255.0 blue:76/255.0 alpha:1] CGColor];
    nextBtn.frame =CGRectMake(96,2, 30, 30);
    [nextBtn addTarget:self action:@selector(nextBtnClick:)forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:nextBtn];
    
    [myView setHidden:true];
    

}


//按钮点击响应
- (void)delectBtnClick: (id)sender
{
    
    if ([self.slideShowView returnCount] <= 1)
    {
        UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"手下留情" message:@"您已经没有多少存活了, 请手下留情!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        
        [NSTimer scheduledTimerWithTimeInterval:1.5f
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:promptAlert
                                        repeats:YES];
        [promptAlert show];
        return;
    }
    
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"您是否确定要删除该图片" leftButtonTitle:@"是" rightButtonTitle:@"否"];
    [alert show];
    alert.leftBlock = ^()
    {
        //从当前视图中删除
        [self.slideShowView myDeleteLogic];
        
        //从沙盒中删除
        //打开沙盒
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString * namePath = [documentsDirectory stringByAppendingPathComponent:@"myLove.plist"];
        NSMutableArray *picArray = [[NSMutableArray alloc] initWithContentsOfFile:namePath];
        
        NSUInteger _counter = [self.slideShowView returnNowCount];
        if ((int)_counter == 1)
        {
            _counter = (NSUInteger)([self.slideShowView returnCount]+1);
        }
        [picArray removeObjectAtIndex:_counter-2];
        
        [picArray writeToFile:namePath atomically:YES];
        
    };
    alert.rightBlock = ^()
    {
    };
    alert.dismissBlock = ^()
    {
    };
}

- (void)preBtnClick: (id)sender
{
    [self.slideShowView previousImage];
}

- (void)nextBtnClick: (id)sender
{
    [self.slideShowView nextImage];
}

#pragma mark - Datasource
-(NSUInteger)numberOfSectionsInSlideshow:(SLGSlideshowView*)slideShowView
{
    return 1;
}
-(NSInteger)numberOfItems:(SLGSlideshowView*)slideShowView inSection:(NSUInteger)section
{
    
    return [[_slideshowData objectAtIndex:section]count];
}
-(UIView*)viewForSlideShow:(SLGSlideshowView*)slideShowView atIndexPath:(NSIndexPath*)indexPath{
    
    NSString* imageName = [[[_slideshowData objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"url"];
    
    NSURL *url = [NSURL URLWithString:imageName];
    
    UIImageView* imageView = [[UIImageView alloc]init];
    [imageView setImageWithURL:url placeholderImage:nil];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    return imageView;
}

-(NSTimeInterval)slideDurationForSlideShow:(SLGSlideshowView*)slideShowView atIndexPath:(NSIndexPath*)indexPath
{
    
    // random time
    return arc4random()%4;
    
}
-(NSTimeInterval)transitionDurationForSlideShow:(SLGSlideshowView*)slideShowView atIndexPath:(NSIndexPath*)indexPath
{
    // random time
    return (arc4random()%(4-1))+1;
    
}
-(NSUInteger)transitionStyleForSlideShow:(SLGSlideshowView*)slideShowView atIndexPath:(NSIndexPath*)indexPath
{
    
    
    //random style
    NSUInteger rIndex = arc4random()%[_transitionOptions count];
    return [[_transitionOptions objectAtIndex:rIndex]integerValue];
    
}

//弹出框自动消失
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
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
