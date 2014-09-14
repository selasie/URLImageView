//
//  DRURLImageView.m
//
//  Created by Volkov Dmitry on 7/31/14.
//  Copyright (c) 2014 Volkov Dmitry. All rights reserved.
//

#import "DRURLImageView.h"
#import "DRDataDownloader+DefaultDownloader.h"

@interface DRURLImageView ()
{
    UIActivityIndicatorView* _activityIndicator;
    NSURL* _imageURL;
}

@end

@implementation DRURLImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createActivityIndicatorIfNeeded];
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self createActivityIndicatorIfNeeded];
}

- (void) setActivityIndicatorColor:(UIColor *)activityIndicatorColor
{
    _activityIndicatorColor = activityIndicatorColor;
    _activityIndicator.color = activityIndicatorColor;
}

- (void) createActivityIndicatorIfNeeded
{
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.hidesWhenStopped = YES;
    if(self.activityIndicatorColor!=nil)
    {
        _activityIndicator.color = self.activityIndicatorColor;
    }
    [_activityIndicator stopAnimating];
    [self addSubview:_activityIndicator];
}

- (void) setImageFromURL:(NSURL *)url
{
    [self setImageFromURL:url completionBlock:nil];
}

- (void) cancelImageLoading
{
    [_activityIndicator stopAnimating];
    if(_imageURL!=nil)
    {
        [[DRDataDownloader defaultDownloader] cancelLoadingFromURL:_imageURL];
    }
}

- (void) setImageFromURL:(NSURL *)url completionBlock:(void (^)(DRURLImageView*,UIImage *, NSError *))completionBlock
{
    [self cancelImageLoading];
    [_activityIndicator startAnimating];
    _imageURL = url;
    [[DRDataDownloader defaultDownloader] loadDataFromURL:url completionBlock:^(NSData *data, NSError *error) {
      
        UIImage* image = error==nil ? [UIImage imageWithData:data] : nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            _imageURL = nil;
            [_activityIndicator stopAnimating];
            if(completionBlock)
            {
                completionBlock(self,image, error);
            }
            else
            {
                CATransition* transition = [CATransition animation];
                [self.layer addAnimation:transition forKey:nil];
                self.image = image;
            }
            
        });
        
    }];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    _activityIndicator.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
