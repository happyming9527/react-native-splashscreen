//
//  RCTSplashScreen.m
//  RCTSplashScreen
//
//  Created by fangyunjiang on 15/11/20.
//  Copyright (c) 2015年 remobile. All rights reserved.
//

#import "RCTSplashScreen.h"

static RCTRootView *rootView = nil;

@interface RCTSplashScreen()

@end

@implementation RCTSplashScreen

RCT_EXPORT_MODULE(SplashScreen)

+ (void)show:(RCTRootView *)v {
    rootView = v;
    rootView.loadingViewFadeDelay = 0.6;
    rootView.loadingViewFadeDuration = 0.1;
    UIImage *image =[self splashImageName];
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    rootView.loadingView = view;
    [[NSNotificationCenter defaultCenter] removeObserver:rootView  name:RCTContentDidAppearNotification object:rootView];
    [rootView setLoadingView:view];
}

+ (NSString *)splashImageName {
    CGSize viewSize = rootView.bounds.size;
    NSString* viewOrientation = @"Portrait";
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
            return dict[@"UILaunchImageName"];
    }
    return nil;
}

RCT_EXPORT_METHOD(hide:(NSString *)effect) {
    UIViewAnimationOptions *fadeType;
    if ( [effect isEqualToString:@"FlipFromRight"] )
    {
        fadeType = UIViewAnimationOptionTransitionFlipFromRight;
    } else if ( [effect isEqualToString:@"FlipFromLeft"] )
    {
        fadeType = UIViewAnimationOptionTransitionFlipFromLeft;
    } else if ( [effect isEqualToString:@"None"] )
    {
        fadeType = UIViewAnimationOptionTransitionNone;
    } else if ( [effect isEqualToString:@"CurlUp"] )
    {
        fadeType = UIViewAnimationOptionTransitionCurlUp;
    } else if ( [effect isEqualToString:@"CurlDown"] )
    {
        fadeType = UIViewAnimationOptionTransitionCurlDown;
    } else if ( [effect isEqualToString:@"CrossDissolve"] )
    {
        fadeType = UIViewAnimationOptionTransitionCrossDissolve;
    } else if ( [effect isEqualToString:@"FlipFromTop"] )
    {
        fadeType = UIViewAnimationOptionTransitionFlipFromTop;
    } else if ( [effect isEqualToString:@"FlipFromBottom"] )
    {
        fadeType = UIViewAnimationOptionTransitionFlipFromBottom;
    }
    
    
    
    if (!rootView) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(rootView.loadingViewFadeDuration * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   ^{
                       [UIView transitionWithView: rootView
                                         duration:rootView.loadingViewFadeDelay
                                          options:fadeType
                                       animations:^{
                                           rootView.loadingView.hidden = YES;
                                       } completion:^(__unused BOOL finished) {
                                           [rootView.loadingView removeFromSuperview];
                                       }];
                   });
}

@end
