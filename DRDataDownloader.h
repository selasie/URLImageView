//
//  DRDataDownloader.h
//
//  Created by Volkov Dmitry on 6/27/14.
//  Copyright (c) 2014 Volkov Dmitry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRDataCache.h"

@interface DRDataDownloader : NSObject

@property(nonatomic, readonly) id<DRDataCache> dataCache;

- (instancetype) initWithDataCache:(id<DRDataCache>) dataCache;

//block will be called on an arbitrary thread
- (void) loadDataFromURL:(NSURL*) url completionBlock:(void (^)(NSData* data, NSError* error)) completionBlock;
- (void) cancelLoadingFromURL:(NSURL*) url;
- (void) cancelAllDownloads;
- (BOOL) isLoadingDataFromURL:(NSURL*) url;

@end
