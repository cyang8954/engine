// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "flutter/shell/platform/darwin/ios/ios_screenshot_provider.h"
#include "third_party/skia/include/core/SkImageInfo.h"
#include "third_party/skia/include/core/SkImage.h"
#include "third_party/skia/include/core/SkData.h"
#include "third_party/skia/include/core/SkColorSpace.h"
#include "third_party/skia/include/core/SkRefCnt.h"

#import <UIKit/UIKit.h>

namespace flutter {
  sk_sp<SkImage> TakeScreenShotForView(UIView *view) {
    CGRect rect = view.bounds;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    [[UIColor blackColor] set];
    CGContextFillRect(ctx, rect);

    [view.layer renderInContext:ctx];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    CGImageRef imageRef = CGImageRetain(screenshot.CGImage);
    CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));

    size_t rowBtyes = CGImageGetBytesPerRow(imageRef);

    sk_sp<SkData> rasterData = SkData::MakeWithCopy(CFDataGetBytePtr(data), CFDataGetLength(data));
    const auto image_info = SkImageInfo::Make(
                                              CGImageGetWidth(imageRef),
                                              CGImageGetHeight(imageRef),
                                              kBGRA_8888_SkColorType,
                                              kOpaque_SkAlphaType, SkColorSpace::MakeSRGB());

    sk_sp<SkImage> skImage = SkImage::MakeRasterData(
                                                     image_info,
                                                     rasterData,
                                                     rowBtyes);

    CGImageRelease(imageRef);
    CFRelease(data);

    return skImage;
  }
}
