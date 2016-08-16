//
//  ImageLoader.m
//  FileManager
//
//  Created by Zhi-Qiang Zhou on 8/16/16.
//  Copyright © 2016 Zhi-Qiang Zhou. All rights reserved.
//

#import "ImageLoader.h"

@implementation ImageLoader

#pragma mark singleton

+ (ImageLoader *)sharedLoader
{
    static ImageLoader *sharedMyLoader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyLoader = [[self alloc] init];
    });
    return sharedMyLoader;
}

+ (ImageLoader *)sharedLoaderWithCache
{
    static ImageLoader *sharedMyLoader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyLoader = [[self alloc] init];
        sharedMyLoader.cache = [[NSCache alloc] init];
    });
    return sharedMyLoader;
}

#pragma mark load image

- (void)imageForURL:(NSURL *)url
         completion:(void (^)(UIImage * _Nullable image))completion
{
    [self imageForURL:url process:nil completion:completion];
}

- (void)imageForURL:(NSURL *)url
            process:(void (^ _Nullable)(UIImage * _Nonnull * _Nonnull image))process
         completion:(void (^)(UIImage * _Nullable image))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSData *data = [self.cache objectForKey:url.absoluteString];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(image);
            });
            return;
        }
        
        NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                NSLog(@"%@, %@", error, error.userInfo);
                if (completion) completion(nil);
                return;
            }
            
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                if (process) process(&image);
                [self.cache setObject:image forKey:url.absoluteString];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) completion(image);
                });
                return;
            }
        }];
        [downloadTask resume];
    });
}

@end
