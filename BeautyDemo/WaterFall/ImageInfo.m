//
//  ImageInfo.m
//  hlrenTest
//
//  Created by blue on 13-4-23.
//  Copyright (c) 2013年 blue. All rights reserved.
//

#import "ImageInfo.h"
@implementation ImageInfo
-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        self.thumbURL = [dictionary objectForKey:@"image_url"];
        self.width = [[dictionary objectForKey:@"image_width"]floatValue];
        self.height = [[dictionary objectForKey:@"image_height"]floatValue];
        self.title = [dictionary objectForKey:@"desc"];

    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"unescapedUrl:%@ width:%f height:%f",self.thumbURL,self.width,self.height];
}
@end
