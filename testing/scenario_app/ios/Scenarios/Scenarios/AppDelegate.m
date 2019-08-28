#include "AppDelegate.h"
#import "TextPlatformView.h"

@interface NoStatusBarFlutterViewController : FlutterViewController

@end

@implementation NoStatusBarFlutterViewController
- (BOOL)prefersStatusBarHidden {
  return YES;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application
    didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  // This argument is used by the XCUITest for Platform Views so that the app
  // under test will create platform views.
  if ([[[NSProcessInfo processInfo] arguments] containsObject:@"--platform-view"]) {
    [self readyContextForPlatformViewTests:@"text_platform_view"];
  } else if ([[[NSProcessInfo processInfo] arguments] containsObject:@"--platform-view-cliprect"]) {
    [self readyContextForPlatformViewTests:@"platform_view_cliprect"];
  } else if ([[[NSProcessInfo processInfo] arguments] containsObject:@"--platform-view-cliprrect"]) {
    [self readyContextForPlatformViewTests:@"platform_view_cliprrect"];
  } else if ([[[NSProcessInfo processInfo] arguments] containsObject:@"--platform-view-clippath"]) {
    [self readyContextForPlatformViewTests:@"platform_view_clippath"];
  } else if ([[[NSProcessInfo processInfo] arguments] containsObject:@"--platform-view-transform"]) {
    [self readyContextForPlatformViewTests:@"platform_view_transform"];
  } else if ([[[NSProcessInfo processInfo] arguments] containsObject:@"--platform-view-opacity"]) {
    [self readyContextForPlatformViewTests:@"platform_view_opacity"];
  } else {
    self.window.rootViewController = [[UIViewController alloc] init];
  }
  [self.window makeKeyAndVisible];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)readyContextForPlatformViewTests:(NSString *)scenarioMessage {
  FlutterEngine* engine = [[FlutterEngine alloc] initWithName:@"PlatformViewTest" project:nil];
  [engine runWithEntrypoint:nil];

  FlutterViewController* flutterViewController =
  [[NoStatusBarFlutterViewController alloc] initWithEngine:engine nibName:nil bundle:nil];
  [engine.binaryMessenger
   setMessageHandlerOnChannel:@"scenario_status"
   binaryMessageHandler:^(NSData* _Nullable message, FlutterBinaryReply _Nonnull reply) {
     [engine.binaryMessenger
      sendOnChannel:@"set_scenario"
      message:[scenarioMessage dataUsingEncoding:NSUTF8StringEncoding]];
   }];
  TextPlatformViewFactory* textPlatformViewFactory =
  [[TextPlatformViewFactory alloc] initWithMessenger:flutterViewController.binaryMessenger];
  NSObject<FlutterPluginRegistrar>* registrar =
  [flutterViewController.engine registrarForPlugin:@"scenarios/TextPlatformViewPlugin"];
  [registrar registerViewFactory:textPlatformViewFactory withId:@"scenarios/textPlatformView"];
  self.window.rootViewController = flutterViewController;
}

@end
