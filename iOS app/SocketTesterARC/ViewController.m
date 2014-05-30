//
//  ViewController.m
//  SocketTesterARC
//
//  Created by Kyeck Philipp on 01.06.12.
//  Copyright (c) 2012 beta_interactive. All rights reserved.
//

#import "ViewController.h"
#import "SocketIOPacket.h"
#import <ScenteeSDK/ScenteeSDK.h>

@interface ViewController ()

@end

@implementation ViewController
@synthesize idlbl, sprayToggle;

bool sprayScent=false;

- (void) viewDidLoad
{
    [super viewDidLoad];
    [sprayToggle setOn:sprayScent animated:YES];
    // create socket.io client instance
    socketIO = [[SocketIO alloc] initWithDelegate:self];
    
    [socketIO connectToHost:@"cloudbasedscentdistributionsystem.com" onPort:80];
    
    
    UISwipeGestureRecognizer* swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(getNewID:)];
    swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeUpGestureRecognizer];
}

-(void)getNewID:(UIGestureRecognizer*)recognizer{
    NSLog(@"swiped");
    [socketIO sendEvent:@"newid" withData:[idlbl text]];
}

# pragma mark -
# pragma mark socket.IO-objc delegate methods

- (void) socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"socket.io connected.");
}

- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    
    
    NSDictionary* data = packet.dataAsJSON;
    if ([packet.name isEqual:@"spray"]){
        
        NSLog(@"spraying");
        bool worked = false;
        @try {
            if (sprayScent){
                [[ScenteeSDK scentee] puffAndFlashLedWithRed:(long)[data[@"args"][0][@"red"] integerValue ] Green:(long)[data[@"args"][0][@"green"] integerValue ] Blue:(long)[data[@"args"][0][@"blue"] integerValue ] Special:(long)[data[@"args"][0][@"special"] integerValue ] Time:(long)[data[@"args"][0][@"time"] integerValue ] Misc:data[@"args"][0][@"misc"]];
            } else {
                [[ScenteeSDK scentee] flashLedWithRed:(long)[data[@"args"][0][@"red"] integerValue ] Green:(long)[data[@"args"][0][@"green"] integerValue ] Blue:(long)[data[@"args"][0][@"blue"] integerValue ] Special:(long)[data[@"args"][0][@"special"] integerValue ] Time:(long)[data[@"args"][0][@"time"] integerValue ] ];
            }
            worked = true;
        }
        @catch (NSException *exception) {
            NSLog(@"Failure！");
        }
        
    }
    if ([packet.name isEqual:@"id"]){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [idlbl setText:[NSString stringWithFormat:@"%@",data[@"args"][0][@"id"]]];
        }];
    }
    if ([packet.name isEqual:@"togglespray"]){
        sprayScent = !sprayScent;
        [sprayToggle setOn:sprayScent animated:YES];
    }
    
}

- (void) socketIO:(SocketIO *)socket onError:(NSError *)error
{
    if ([error code] == SocketIOUnauthorized) {
        NSLog(@"not authorized");
    } else {
        NSLog(@"onError() %@", error);
    }
}


- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
{
    NSLog(@"socket.io disconnected. did error occur? %@", error);
}

- (IBAction)sprayToggled:(id)sender {
    sprayScent = !sprayScent;
    [socketIO sendEvent:@"toggledspray" withData:@""];
}

- (IBAction)manualSpray:(id)sender {
    if (sprayScent){
        [[ScenteeSDK scentee] puffAndFlashLedWithRed:127 Green:127 Blue:127 Special:0 Time:1000 Misc:@"manual"];
    } else {
        [[ScenteeSDK scentee] flashLedWithRed:127 Green:127 Blue:127 Special:0 Time:1000 ];
    }
}
@end
