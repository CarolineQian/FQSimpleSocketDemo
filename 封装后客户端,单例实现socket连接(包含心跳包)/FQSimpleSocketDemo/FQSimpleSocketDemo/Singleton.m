//
//  Singleton.m
//  socket_tutorial
//   111111

#import "Singleton.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>

@implementation Singleton


#pragma mark - 外部方法
+(Singleton *) sharedInstance
{
    
    static Singleton *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      sharedInstace = [[self alloc] init];
                  });
    
    return sharedInstace;
}

// socket连接
-(void)socketConnectHost
{
    self.socket  = [[AsyncSocket alloc] initWithDelegate:self];
    NSError *error = nil;
    [self.socket connectToHost:self.socketHost onPort:self.socketPort withTimeout:3 error:&error];
}

// 切断socket
-(void)cutOffSocket
{
    self.socket.userData = SocketOfflineByUser;
    [self.connectTimer invalidate];
    [self.socket disconnect];
}



#pragma mark  - AsyncSocketDelegate
//连接成功
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"socket连接成功");
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
    [self.connectTimer fire];
    [self.socket readDataWithTimeout:-1 tag:0];
}

//重新连接
-(void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"连接失败,重连 %ld",sock.userData);
    if (sock.userData == SocketOfflineByServer)
    {
        // 服务器掉线，重连
        [self socketConnectHost];
    }
    else if (sock.userData == SocketOfflineByUser)
    {
        // 如果由用户断开，不进行重连
        return;
    }
}

//接收消息
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
     NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"接收到服务器端传来的消息%@",text);
    [self.socket readDataWithTimeout:30 tag:0];
}


#pragma mark - Other Functions

// 心跳连接
-(void)longConnectToSocket
{
    NSString *longConnect = @"心跳连接";
    NSData   *dataStream  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:dataStream withTimeout:1 tag:1];
}





@end
