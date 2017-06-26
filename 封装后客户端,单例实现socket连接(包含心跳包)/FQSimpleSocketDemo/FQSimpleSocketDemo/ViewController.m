//
//  ViewController.m
//  socket_tutorial
//

#import "ViewController.h"

#import "Singleton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [Singleton sharedInstance].socketHost = @"127.0.0.1";
    [Singleton sharedInstance].socketPort = 8080;
    
    //在连接前先进行手动断开
    [Singleton sharedInstance].socket.userData = SocketOfflineByUser;
    [[Singleton sharedInstance] cutOffSocket];
    
    //确保断开后再连，如果对一个正处于连接状态的socket进行连接，会出现崩溃
    [Singleton sharedInstance].socket.userData = SocketOfflineByServer;
    [[Singleton sharedInstance] socketConnectHost];
    
    
    
}



@end
