// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


#include "gtest/gtest.h"
#include "flutter/shell/platform/darwin/ios/framework/Source/FlutterPlatformViews_Internal.h"

void checkEncodeDecode(id value, NSData* expectedEncoding) {
  FlutterStandardMessageCodec* codec = [FlutterStandardMessageCodec sharedInstance];
  NSData* encoded = [codec encode:value];
  if (expectedEncoding == nil)
    ASSERT_TRUE(encoded == nil);
  else
    ASSERT_TRUE([encoded isEqual:expectedEncoding]);
  id decoded = [codec decode:encoded];
  if (value == nil || value == [NSNull null])
    ASSERT_TRUE(decoded == nil);
  else
    ASSERT_TRUE([value isEqual:decoded]);
}

void checkEncodeDecode(id value) {
  FlutterStandardMessageCodec* codec = [FlutterStandardMessageCodec sharedInstance];
  NSData* encoded = [codec encode:value];
  id decoded = [codec decode:encoded];
  if (value == nil || value == [NSNull null])
    ASSERT_TRUE(decoded == nil);
  else
    ASSERT_TRUE([value isEqual:decoded]);
}

TEST(FlutterPlatformViewsControllerUtils, CountClips) {
  
}


