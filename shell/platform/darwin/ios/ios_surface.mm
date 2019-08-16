// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "flutter/shell/platform/darwin/ios/ios_surface.h"

#include <memory>

#include "flutter/shell/platform/darwin/ios/ios_surface_gl.h"
#include "flutter/shell/platform/darwin/ios/ios_surface_software.h"
#include "third_party/skia/include/core/SkImageInfo.h"

namespace flutter {

// The name of the Info.plist flag to enable the embedded iOS views preview.
const char* const kEmbeddedViewsPreview = "io.flutter.embedded_views_preview";

bool IsIosEmbeddedViewsPreviewEnabled() {
  return [[[NSBundle mainBundle] objectForInfoDictionaryKey:@(kEmbeddedViewsPreview)] boolValue];
}

IOSSurface::IOSSurface(FlutterPlatformViewsController* platform_views_controller)
    : platform_views_controller_(platform_views_controller) {}

IOSSurface::~IOSSurface() = default;

FlutterPlatformViewsController* IOSSurface::GetPlatformViewsController() {
  return platform_views_controller_;
}

sk_sp<SkImage> IOSSurface::ScreenShot() {
  FML_CHECK(platform_views_controller_ != nullptr);
  UIView* view = platform_views_controller_->GetFlutterView();
  CGRect rect = view.bounds;
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef ctx = UIGraphicsGetCurrentContext();

  [[UIColor blackColor] set];
  CGContextFillRect(ctx, rect);

  [view.layer renderInContext:ctx];
  UIImage* screenshot = UIGraphicsGetImageFromCurrentImageContext();

  UIGraphicsEndImageContext();
  CGImageRef imageRef = CGImageRetain(screenshot.CGImage);
  CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));

  size_t rowBtyes = CGImageGetBytesPerRow(imageRef);

  sk_sp<SkData> rasterData = SkData::MakeWithCopy(CFDataGetBytePtr(data), CFDataGetLength(data));
  const auto image_info =
      SkImageInfo::Make(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef),
                        kBGRA_8888_SkColorType, kOpaque_SkAlphaType, SkColorSpace::MakeSRGB());

  sk_sp<SkImage> skImage = SkImage::MakeRasterData(image_info, rasterData, rowBtyes);

  CGImageRelease(imageRef);
  CFRelease(data);

  return skImage;
}
}  // namespace flutter
