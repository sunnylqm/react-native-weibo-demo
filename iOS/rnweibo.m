#include <sys/types.h>
#include <sys/sysctl.h>

#import "WeiboSDK.h"

#import "rnweibo.h"

#import "RCTEventDispatcher.h"

#define kAppKey @"342704785"
#define kRedirectURI @"https://api.weibo.com/oauth2/default.html"

@implementation rnweibo

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(login) {
  [self _login];
}

+ (id)allocWithZone:(NSZone *) zone
{
  static rnweibo *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [super allocWithZone:zone];
  });
  return sharedInstance;
}

- (void)_login {
  
  NSLog(@"weibo login");
  
  [WeiboSDK enableDebugMode:YES];
  [WeiboSDK registerApp:kAppKey];
  
  WBAuthorizeRequest *request = [WBAuthorizeRequest request];
  request.redirectURI = kRedirectURI;
  request.scope = @"all";
//  request.userInfo = @{@"SSO_From": @"CDVViewController",
//                       @"Other_Info_1": [NSNumber numberWithInt:123],
//                       @"Other_Info_2": @[@"obj1", @"obj2"],
//                       @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
  [WeiboSDK sendRequest:request];
}


- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
  
  NSLog(response.debugDescription);
  
  if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
  {
    //NSString *title = @"发送结果";
    //NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
    
    
  }
  else if ([response isKindOfClass:WBAuthorizeResponse.class])
  {
    
    
    //success
    if(response.statusCode == 0){
//      NSDictionary *info=[NSDictionary dictionaryWithObjectsAndKeys:[(WBAuthorizeResponse *)response userID],@"uid",[(WBAuthorizeResponse*)response accessToken],@"token" , nil];
      NSString *uid = [(WBAuthorizeResponse *)response userID];
      NSString *token = [(WBAuthorizeResponse *)response accessToken];
      NSLog([NSString stringWithFormat:@"响应状态：%d userId：%@  accessToken：%@",response.statusCode, uid, token]);
      
      [self.bridge.eventDispatcher sendDeviceEventWithName:@"weiboLoginCallback"
                          body:@{@"uid": uid, @"token": token}];
      
    }else{
      //error
      
    }
    
  }
}

@end