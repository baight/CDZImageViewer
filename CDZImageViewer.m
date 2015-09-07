//
//  CDZImageViewer.m
//  
//
//  Created by baight on 15/9/7.
//  Copyright (c) 2013 baight. All rights reserved.
//
// 代码参考 MWPhotoBrower

#import "CDZImageViewer.h"

@interface CDZImageViewer () <UIScrollViewDelegate>
@end

@implementation CDZImageViewer{
    UIImageView* _imageView;
}
- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self myInit];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self myInit];
    }
    return self;
}
- (void)myInit{
    self.delegate = self;
    
    _imageView = [[UIImageView alloc]init];
    [self addSubview:_imageView];
}

- (void)setImage:(UIImage *)image{
    _image = image;
    _imageView.image = image;
    CGFloat width = image.size.width*image.scale;
    CGFloat height = image.size.height*image.scale;
    if(width < self.bounds.size.width || height < self.bounds.size.height){
        width = self.bounds.size.width;
        height = width * image.size.height/image.size.width;
        if(height > self.bounds.size.height){
            height = self.bounds.size.height;
            width = self.bounds.size.height * image.size.width/image.size.height;
        }
    }
    CGRect imageFrame = _imageView.frame;
    imageFrame.size = CGSizeMake(width, height);
    _imageView.frame = imageFrame;
    
    // Sizes
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = _imageView.image.size;
    
    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // Image is smaller than screen so no zooming!
    if (xScale >= 1 && yScale >= 1) {
        minScale = 1.0;
    }
    
    // Calculate Max
    CGFloat maxScale = 3;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Let them go a bit bigger on a bigger screen!
        maxScale = 4;
    }
    
    // Set min/max zoom
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    
    // Initial zoom
    self.zoomScale = minScale;
    
    // Layout
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    // Super
    [super layoutSubviews];
    
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _imageView.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    // Center
    if (!CGRectEqualToRect(_imageView.frame, frameToCenter)){
        _imageView.frame = frameToCenter;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (UIImageView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

@end


// 303730915@qq.com
