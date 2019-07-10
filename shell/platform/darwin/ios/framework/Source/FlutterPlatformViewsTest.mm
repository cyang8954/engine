// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "flutter/flow/embedded_views.h"
#import "flutter/shell/platform/darwin/ios/framework/Source/FlutterPlatformViews_Internal.h"

@interface FlutterPlatformViewsControllerUtilsTests : XCTestCase

@end

@implementation FlutterPlatformViewsControllerUtilsTests {
}

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testPrepareEmbeddedViewForCompositionWithParams{

  flutter::EmbeddedViewParams params;
  params.sizePoints = SkSize::Make(100, 100);
  UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)] autorelease];
  view.layer.transform = CATransform3DMakeScale(2, 2, 2);
  view.alpha = 0.5;
  flutter::FlutterPlatformViewsControllerUtils::PrepareEmbeddedViewForCompositionWithParams(view, params);
  XCTAssert(view.alpha == 1);
  XCTAssert(CGRectEqualToRect(view.frame, CGRectMake(0, 0, 100, 100)));
  XCTAssert(CATransform3DEqualToTransform(view.layer.transform, CATransform3DIdentity));
}

@end
