//
//  ImageLoader.h
//  FileManager
//
//  Created by Zhi-Qiang Zhou on 8/16/16.
//  Copyright © 2016 Zhi-Qiang Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageLoader : NSObject

@property (nonatomic, strong) NSCache *cache;

+ (ImageLoader *)sharedLoader;

+ (ImageLoader *)sharedLoaderWithCache;

- (void)imageForURL:(NSURL *)url
         completion:(void (^)(UIImage * _Nullable image))completion;

- (void)imageForURL:(NSURL *)url
            process:(void (^ _Nullable)(UIImage * _Nonnull * _Nonnull image))process
         completion:(void (^)(UIImage * _Nullable image))completion;
@end

NS_ASSUME_NONNULL_END