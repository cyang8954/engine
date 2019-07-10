//
//  FlutterPlatformViewsTest.m
//  IosUnitTestsTests
//
//  Created by Chris Yang on 7/10/19.
//  Copyright © 2019 Aaron Clarke. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "flutter/shell/platform/darwin/ios/framework/Source/FlutterPlatformViews_Internal.h"
#import "flutter/shell/platform/darwin/ios/framework/Source/FlutterPlatformViews_Internal.h"

@interface FlutterPlatformViewsControllerTests : XCTestCase

@end

@implementation FlutterPlatformViewsControllerTests {
  std::unique_ptr<flutter::FlutterPlatformViewsController> _platformViewsController;
}

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  _platformViewsController.reset(new flutter::FlutterPlatformViewsController());
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  _platformViewsController.release();
}

- (void)testPrepareEmbeddedViewForCompositionWithParams{
  _pl
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
