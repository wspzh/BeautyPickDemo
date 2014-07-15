// TGRImageZoomTransition.m
//
// Copyright (c) 2013 Guillermo Gonzalez
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "TGRImageViewController.h"

@interface TGRImageViewController ()
{
    BOOL isBaby;
}

@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *singleTapGestureRecognizer;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *doubleTapGestureRecognizer;

@end

@implementation TGRImageViewController

- (id)initWithImage:(UIImage *)image setImageInfo:(ImageInfo *)imgInfo
{
    if (self = [super init])
    {
        _image = image;
        _imageInfo = imgInfo;
    }
    
    return self;
}


- (id)initWithBabyImage:(UIImage *)image
{
    if (self = [super init])
    {
        _image = image;
        isBaby = true;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.singleTapGestureRecognizer requireGestureRecognizerToFail:self.doubleTapGestureRecognizer];
    self.imageView.image = self.image;
    
    //添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.imageView addGestureRecognizer:longPress];
    longPress.minimumPressDuration = 1.0;
    
    
    NSLog(@"%@", _imageInfo);
    //设置优先级
    [self.singleTapGestureRecognizer requireGestureRecognizerToFail:longPress];

}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}



#pragma mark - Private methods

- (void)longPress:(UITapGestureRecognizer *)tapGestureRecognizer
{
    
    if(tapGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        [self popupActionSheet];
    }
}

- (IBAction)handleSingleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)handleDoubleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        // Zoom in
        CGPoint center = [tapGestureRecognizer locationInView:self.scrollView];
        CGSize size = CGSizeMake(self.scrollView.bounds.size.width / self.scrollView.maximumZoomScale,
                                 self.scrollView.bounds.size.height / self.scrollView.maximumZoomScale);
        CGRect rect = CGRectMake(center.x - (size.width / 2.0), center.y - (size.height / 2.0), size.width, size.height);
        [self.scrollView zoomToRect:rect animated:YES];
    }
    else {
        // Zoom out
        [self.scrollView zoomToRect:self.scrollView.bounds animated:YES];
    }
}


//弹出选择界面。
-(void)popupActionSheet
{
	if (isBaby)
    {
        UIActionSheet *popupQuery = [[UIActionSheet alloc]
                                     initWithTitle:nil
                                     delegate:self
                                     cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil
                                     otherButtonTitles:@"保存到本地相册", nil];
        
        popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [popupQuery showInView:self.view];
    }
    else
    {
        UIActionSheet *popupQuery = [[UIActionSheet alloc]
                                     initWithTitle:nil
                                     delegate:self
                                     cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil
                                     otherButtonTitles:@"保存到本地相册",@"添加到幻灯片", nil];
        
        popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [popupQuery showInView:self.view];
    }
}


//弹出框自动消失
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}


//响应选择。 跳出相应界面。
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	if (buttonIndex == 0)     //保存到本地相册
    {
        UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"存储照片成功" message:@"您已将照片存储于图片库中，打开照片程序即可查看。" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        
        [NSTimer scheduledTimerWithTimeInterval:1.5f
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:promptAlert
                                        repeats:YES];
        [promptAlert show];
	}
    else if (buttonIndex == 1)    //保存到幻灯片
    {
        if (isBaby)
        {
            return;
        }
        NSLog(@"%@", NSHomeDirectory());
        //打开沙盒
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString * namePath = [documentsDirectory stringByAppendingPathComponent:@"myLove.plist"];
        NSMutableArray *picArray = [[NSMutableArray alloc] initWithContentsOfFile:namePath];
        
        if (picArray == NULL)
        {
            picArray = [[NSMutableArray alloc]init];
        }
        //写入新数据
        NSMutableDictionary *nowDic = [[NSMutableDictionary alloc]init];
        [nowDic setObject:self.imageInfo.thumbURL forKey:@"url"];
        [nowDic setObject:self.imageInfo.title forKey:@"title"];
        [nowDic setObject:[NSString stringWithFormat:@"%f",self.imageInfo.height] forKey:@"height"];
        [nowDic setObject:[NSString stringWithFormat:@"%f",self.imageInfo.width] forKey:@"width"];
        
        //如果不存在
        if (![picArray containsObject:nowDic])
        {
            [picArray addObject:nowDic];
            [picArray writeToFile:namePath atomically:YES];
            
            UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"添加照片成功" message:@"您已将照片添加到播放列表中，打开幻灯片即可自动播放。" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            
            [NSTimer scheduledTimerWithTimeInterval:1.5f
                                             target:self
                                           selector:@selector(timerFireMethod:)
                                           userInfo:promptAlert
                                            repeats:YES];
            [promptAlert show];
        }
        else    //存在
        {
            UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已添加过该照片, 无需重复添加。" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            
            [NSTimer scheduledTimerWithTimeInterval:1.5f
                                             target:self
                                           selector:@selector(timerFireMethod:)
                                           userInfo:promptAlert
                                            repeats:YES];
            [promptAlert show];
        }
        

    }
    
}
@end
