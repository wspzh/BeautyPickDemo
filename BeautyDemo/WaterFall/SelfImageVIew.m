//
//  SelfImageVIew.m
//  hlrenTest
//
//  Created by blue on 13-4-23.
//  Copyright (c) 2013年 blue. All rights reserved.
//

#import "SelfImageVIew.h"
#import "Colours.h"

@implementation SelfImageVIew

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithImageInfo:(ImageInfo*)imageInfo y:(float)y  withA:(int)a
{
    
    if (imageInfo.thumbURL.length < 8)
    {
        return nil;
    }
    
    float imageW = imageInfo.width;
    float imageH = imageInfo.height;
    //缩略图宽度和宽度
    float width = WIDTH - SPACE;
    float height = width * imageH / imageW;

    self = [super initWithFrame:CGRectMake(0, y, WIDTH, height + SPACE)];
    if (self)
    {
        self.data = imageInfo;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SPACE / 2 , SPACE / 2 , width, height)];
        NSURL *url = [NSURL URLWithString:imageInfo.thumbURL];
        [imageView setImageWithURL:url placeholderImage:nil];
        imageView.backgroundColor = [UIColor palePurpleColor];
        [self addSubview:imageView];
        //如果想加别的信息在此可加
        UILabel *labe = [[UILabel alloc]initWithFrame:CGRectMake(SPACE / 2, height - 20 + SPACE, width, 20)];
        labe.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        labe.text = imageInfo.title;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:labe];
        
        // 单击
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
        singleRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleRecognizer];
        
        //长按
        UILongPressGestureRecognizer *longRecognizer;
        longRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleLongFrom:)];
        [self addGestureRecognizer:longRecognizer];
        
        //长按失败了才响应单击
        [singleRecognizer requireGestureRecognizerToFail:longRecognizer];
        
    }
    
    return self;
}

//单击事件
- (void)handleSingleTapFrom:(UISwipeGestureRecognizer*)recognizer
{
    [self.delegate clickImage:self.data];

}

//长按事件
- (void)handleSingleLongFrom:(UISwipeGestureRecognizer*)recognizer
{
    //取消响应两次
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        return;
    }
    else if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        //长按弹出删除选项
        [self.delegate removeImg:self.data];
    }
}

@end
