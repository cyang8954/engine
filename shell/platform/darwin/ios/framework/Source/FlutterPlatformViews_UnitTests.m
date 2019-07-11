// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


#include "gtest/gtest.h"
#include "flutter/shell/platform/darwin/ios/framework/Source/FlutterPlatformViews_Internal.h"

namespace flutter {

TEST(FlutterPlatformViewsControllerUtils, CountClips) {
    MutatorsStack stack;
    stack.PushOpacity(240);
    SkPath path;
    stack.PushClipPath(path);
    SkRect rect = SkRect::MakeEmpty();
    stack.PushClipRect(rect);
    SkRRect rrect = SkRRect::MakeEmpty();
    stack.PushClipRRect(rrect);
    SkMatrix matrix;
    matrix.setIdentity();
    stack.PushTransform(matrix);

    int count = flutter::FlutterPlatformViewsControllerUtils::CountClips(stack);
    ASSERT_TRUE(count, 2);

    flutter::MutatorsStack stack2;
    int count2 = flutter::FlutterPlatformViewsControllerUtils::CountClips(stack);
    ASSERT_TRUE(count2, 0);
}
}


//- (void)testPrepareEmbeddedViewForCompositionWithParams{
//
//  flutter::EmbeddedViewParams params;
//  params.sizePoints = SkSize::Make(100, 100);
//  UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)] autorelease];
//  view.layer.transform = CATransform3DMakeScale(2, 2, 2);
//  view.alpha = 0.5;
//  flutter::FlutterPlatformViewsControllerUtils::PrepareEmbeddedViewForCompositionWithParams(view, params);
//  XCTAssertEqual(view.alpha, 1);
//  XCTAssert(CGRectEqualToRect(view.frame, CGRectMake(0, 0, 100, 100)));
//  XCTAssert(CATransform3DEqualToTransform(view.layer.transform, CATransform3DIdentity));
//}
//
//- (void)testCountClip {
//  flutter::MutatorsStack stack;
//  stack.PushOpacity(240);
//  SkRect rect = SkRect::MakeEmpty();
//  stack.PushClipRect(rect);
//  SkRRect rrect = SkRRect::MakeEmpty();
//  stack.PushClipRRect(rrect);
//  SkMatrix matrix;
//  matrix.setIdentity();
//  stack.PushTransform(matrix);
//
//  int count = flutter::FlutterPlatformViewsControllerUtils::CountClips(stack);
//  XCTAssertEqual(count, 2);
//
//  flutter::MutatorsStack stack2;
//  int count2 = flutter::FlutterPlatformViewsControllerUtils::CountClips(stack);
//  XCTAssertEqual(count2, 0);
//}
