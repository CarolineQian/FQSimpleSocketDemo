//
//  ViewController.m
//  SocketServer
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
@interface ViewController ()<GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UITextField *portF;
@property (weak, nonatomic) IBOutlet UITextField *messageTF;
@property (weak, nonatomic) IBOutlet UITextView *showContentMessageTV;

//服务器socket（开放端口，监听客户端socket的链接）
@property (nonatomic) GCDAsyncSocket *serverSocket;

//保护客户端socket
@property (nonatomic) GCDAsyncSocket *clientSocket;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)showMessageWithStr:(NSString *)str
{
    self.showContentMessageTV.text = [self.showContentMessageTV.text stringByAppendingFormat:@"%@\n",str];
}

#pragma mark - Actions
//开始监听
- (IBAction)startReceive:(id)sender
{
    //2、开放哪一个端口
    NSError *error = nil;
    BOOL result = [self.serverSocket acceptOnPort:self.portF.text.integerValue error:&error];
    if (result && error == nil)
    {
        //开放成功
        [self showMessageWithStr:@"开放成功"];
    }
}

//发送消息
- (IBAction)sendMessage:(id)sender
{
    NSData *data = [self.messageTF.text dataUsingEncoding:NSUTF8StringEncoding];
    [self.clientSocket writeData:data withTimeout:-1 tag:0];
}

#pragma mark - 服务器socket Delegate
//接收连接成功
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
   //保存客户端的socket
    self.clientSocket = newSocket;
    [self showMessageWithStr:@"链接成功"];
    [self showMessageWithStr:[NSString stringWithFormat:@"服务器地址：%@ -端口： %d", newSocket.connectedHost, newSocket.connectedPort]];
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}

//收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self showMessageWithStr:text];
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}







@end
