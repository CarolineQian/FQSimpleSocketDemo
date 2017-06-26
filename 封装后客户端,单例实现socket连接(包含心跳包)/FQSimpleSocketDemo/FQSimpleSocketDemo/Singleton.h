//
//  Singleton.h
//  socket_tutorial
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t onceToken = 0; \
__strong static id sharedInstance = nil; \
dispatch_once(&onceToken, ^{ \
sharedInstance = block(); \
}); \
return sharedInstance; \


enum
{
    SocketOfflineByServer,  // 服务器掉线，默认为0
    SocketOfflineByUser,    // 用户主动cut
};

@interface Singleton : NSObject<AsyncSocketDelegate>

@property (nonatomic, strong) AsyncSocket    *socket;       // socket
@property (nonatomic, copy  ) NSString       *socketHost;   // socket的Host
@property (nonatomic, assign) UInt16         socketPort;    // socket的prot
@property (nonatomic, retain) NSTimer        *connectTimer; // 计时器

+ (Singleton *)sharedInstance;
-(void)socketConnectHost;// socket连接
-(void)cutOffSocket;// 断开socket连接
@end
