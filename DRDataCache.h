//
//  WHDataCache.h
//
//  Created by Dmitry Volkov on 9/26/13.
//  Copyright (c) 2013 Sibers. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DRDataCache <NSObject>

@required

- (void) storeData:(NSData*) data forURL:(NSURL*) url;
- (void) removeDataForURL:(NSURL*) url;

- (BOOL) dataExistsForURL:(NSURL*) url;
- (NSData*) dataForURL:(NSURL*) url;

+ (void) purgeData;

@end

