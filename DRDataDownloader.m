//
//  DRDataDownloader.m
//
//  Created by Volkov Dmitry on 6/27/14.
//  Copyright (c) 2014 Volkov Dmitry. All rights reserved.
//

#import "DRDataDownloader.h"

@interface DRDataDownloader ()
{
    NSMutableDictionary* _activeDownloads;
    NSURLSession* _urlSession;
}

@end

@implementation DRDataDownloader

- (instancetype) initWithDataCache:(id<DRDataCache>)dataCache
{
    self = [self init];
    _dataCache = dataCache;
    return self;
}

- (instancetype) init
{
    self = [super init];
    _urlSession =[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    _activeDownloads = [NSMutableDictionary new];
    return self;
}

- (void) loadDataFromURL:(NSURL*) url completionBlock:(void (^)(NSData* data, NSError* error)) completionBlock
{
    if([_dataCache dataExistsForURL:url])
    {
        NSData* data = [_dataCache dataForURL:url];
        if(completionBlock)
        {
            completionBlock(data, nil);
        }
        return;
    }
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask* newTask = [_urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       
        if(error==nil)
        {
            [_dataCache storeData:data forURL:url];
        }
        
        if(completionBlock)
        {
            completionBlock(data, error);
        }
        [_activeDownloads removeObjectForKey:url];
        
    }];
#warning If this might ever become a problem, add handling of multiple completion blocks for the url already being loaded
    if(_activeDownloads[url]!=nil)
    {
        NSLog(@"already loading data from url %@", url);
    }
    _activeDownloads[url] = newTask;
    [newTask resume];
}

- (void) cancelLoadingFromURL:(NSURL*) url
{
    NSURLSessionDataTask* task = _activeDownloads[url];
    [task cancel];
    [_activeDownloads removeObjectForKey:url];
}

- (void) cancelAllDownloads
{
    [_activeDownloads enumerateKeysAndObjectsUsingBlock:^(id key, NSURLSessionDataTask* obj, BOOL *stop) {
        
        [obj cancel];
    }];
    [_activeDownloads removeAllObjects];
}

- (BOOL) isLoadingDataFromURL:(NSURL*) url
{
    return _activeDownloads[url]!=nil;
}

@end
