//
//  ViewController.m
//  ScrollViewWithPageControl
//
//  Created by Wayne on 1/27/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    NSMutableArray *images;
    NSMutableArray *imageViews;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    images     = [[NSMutableArray alloc] init];
    imageViews = [[NSMutableArray alloc] init];
    int i;
    
    // 1.Initialize images and imageViews
    for(i=1;i<4;i++){
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]]];
        [imageViews addObject:[[UIImageView alloc]initWithImage:images[i-1]]];
    }
    
    // 2.Set frame of imageVies
    CGRect rect = _scrollView.bounds;
    for(i=1;i<=[imageViews count];i++){
        [imageViews[i-1] setContentMode:UIViewContentModeScaleAspectFit];
        
        if(i==1)
            [imageViews[i-1] setFrame:rect];
        else
            [imageViews[i-1] setFrame:CGRectOffset([imageViews[i-2] frame],[imageViews[i-2] frame].size.width,0)];
    }
    
    // 3.Set contentSize of scrollView
    CGFloat widthSize = 0.0;
    for(i=0;i<[imageViews count];i++){
        widthSize += [imageViews[i] frame].size.width;
    }
    _scrollView.contentSize = CGSizeMake(widthSize,rect.origin.y);
    
    // 4.Add imageViews to scrollView
    for(i=0;i<[imageViews count];i++){
        [_scrollView addSubview:imageViews[i]];
    }
    
    _scrollView.pagingEnabled = 1;
    _scrollView.showsHorizontalScrollIndicator = 0;
    _scrollView.showsVerticalScrollIndicator = 0;
    _pageControl.numberOfPages = [images count];
    _pageControl.currentPage = 0;
    _label.text = [NSString stringWithFormat:@"%d/%d",1,[imageViews count]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = _scrollView.frame.size.width;
    float fractionPage = _scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionPage);
    _pageControl.currentPage = page;
    _label.text = [NSString stringWithFormat:@"%d/%d",page+1,[imageViews count]];
}
@end
