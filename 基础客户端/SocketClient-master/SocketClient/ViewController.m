//
//  ViewController.m
//  SocketClient
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
@interface ViewController ()<GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *portTF;
@property (weak, nonatomic) IBOutlet UITextField *messageTF;
@property (weak, nonatomic) IBOutlet UITextView *showMessageTF;
//客户端socket
@property (nonatomic) GCDAsyncSocket *socket;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //1、初始化
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)showMessageWithStr:(NSString *)str
{
    self.showMessageTF.text = [self.showMessageTF.text stringByAppendingFormat:@"%@\n", str];
}

#pragma mark - Actions

//开始连接
- (IBAction)connectAction:(id)sender
{
    //2、连接服务器
    [self.socket connectToHost:self.addressTF.text onPort:self.portTF.text.integerValue withTimeout:-1 error:nil];
}

//发送消息
- (IBAction)sendMessageAction:(id)sender
{
    NSData *data = [self.messageTF.text dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:data withTimeout:-1 tag:0];
}



#pragma mark - GCDAsynSocket Delegate
//连接成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    [self showMessageWithStr:@"连接成功"];
    [self showMessageWithStr:[NSString stringWithFormat:@"服务器IP ： %@", host]];
    [self.socket readDataWithTimeout:-1 tag:0];
}

//收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self showMessageWithStr:text];
    [self.socket readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err
{
    NSLog(@"断开 error : %@  sock : %@   _socket : %@ \n\n ", err, sock, sock);
}


#pragma mark - Other Functions

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}









@end
