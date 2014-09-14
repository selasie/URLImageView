//
//
//  Created by Dmitry Volkov on 9/26/13.
//  Copyright (c) 2013 Sibers. All rights reserved.
//

#import "DRSimpleDataCache.h"

NSString* const kFilePrefix = @"dr_cache_";

@implementation DRSimpleDataCache

- (void) storeData:(NSData *)data forURL:(NSURL *)url
{
    NSAssert(url!=nil && data!=nil, @"Empty data or nil URL");
    NSString* filename = [self pathWithURL:url];
    [data writeToFile:filename atomically:YES];
}

- (void) removeDataForURL:(NSURL *)url
{
    NSString* filename = [self pathWithURL:url];
    [[NSFileManager defaultManager] removeItemAtPath:filename error:nil];
}

- (NSData*) dataForURL:(NSURL *)url
{
    NSString* filename = [self pathWithURL:url];
    NSData* data = [NSData dataWithContentsOfFile:filename];
    return data;
}

- (BOOL) dataExistsForURL:(NSURL*) url
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self pathWithURL:url] isDirectory:NULL];
}

+ (void) purgeData
{
    NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self temporaryDirectoryPath] error:nil];
    
    for(NSString* filename in files)
    {
        if([filename hasPrefix:kFilePrefix])
        {
            NSError* err = nil;
            NSString* fullPath = [[self temporaryDirectoryPath] stringByAppendingPathComponent:filename];
            [[NSFileManager defaultManager] removeItemAtPath:fullPath error:&err];
            if(err) NSLog(@"%@",err);
        }
    }
}

#pragma mark - helper methods

+ (NSString*) temporaryDirectoryPath
{
    static NSString* path = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    });
    
    return path;
}

- (NSString*) pathWithName:(NSString*) name
{
    NSString* prefixedName = [NSString stringWithFormat:@"%@%@",kFilePrefix, name];
    return [[[self class] temporaryDirectoryPath] stringByAppendingPathComponent:prefixedName];
}

- (NSString*) pathWithURL:(NSURL*) url
{
    return [self pathWithName:[NSString stringWithFormat:@"%lu_%@",(unsigned long)[url hash], [url lastPathComponent]]];
}




@end
