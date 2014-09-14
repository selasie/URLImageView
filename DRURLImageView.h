//
//  DRURLImageView.h
//
//  Created by Volkov Dmitry on 7/31/14.
//  Copyright (c) 2014 Volkov Dmitry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRURLImageView : UIImageView

@property(nonatomic, copy) UIColor* activityIndicatorColor;

- (void) setImageFromURL:(NSURL*) url;
- (void) cancelImageLoading;
//if completion block is provided, it is caller's responsibility to set provided image as image of the current urlImageView (possibly, by applying some kind of animation), otherwise, image is set implicitly
- (void) setImageFromURL:(NSURL *)url completionBlock:(void(^)(DRURLImageView* imageView, UIImage* image, NSError* error)) completionBlock;

@end
