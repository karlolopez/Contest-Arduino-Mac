//
//  ViewController.m
//  sample2
//
//  Created by Karlo A. López on 4/14/16.
//  Copyright © 2016 karlol. All rights reserved.
//

#import "ViewController.h"
#import "ORSSerialPort.h"
#import <AVFoundation/AVFoundation.h>
#import "ORSSerialPortManager.h"
@implementation ViewController {

ORSSerialPort *serialPort;
AVAudioPlayer *cuartosPlayer;
AVAudioPlayer *quintosPlayer;
AVAudioPlayer *sextosPlayer;
ORSSerialPortManager *manager;
NSURL* cuatosFile;
NSURL* quintosFile;
NSURL* sextosFile;
NSString *selectedPort;
}
- (void)serialPortWasRemovedFromSystem:(ORSSerialPort *)serialPort{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Instrucciones."];
    [alert setInformativeText:@"HOLA! El cerebro debe de estar conectado antes de iniciar el programa. Eso es todo :)\n\n Not working? -> karlol.com  :D"];
    [alert addButtonWithTitle:@"Ok"];
    [alert runModal];
    self.backgroundPlayer.layer.zPosition = 0;
    self.imageView.layer.zPosition = 1;
    self.imageView.image  = nil;
    manager = [ORSSerialPortManager sharedSerialPortManager];
    NSArray *availablePorts = manager.availablePorts;
    NSLog(@"Ports: %@", availablePorts);
    if(availablePorts.count>1){
        selectedPort = availablePorts[0];
        [self updatePort];
    }
    NSString* cuartosPath = [[NSBundle mainBundle] pathForResource:@"jeopardy_sound" ofType:@"caf"];
    NSString* quintosPath = [[NSBundle mainBundle] pathForResource:@"jeopardy_sound" ofType:@"caf"];
    NSString* sextosPath = [[NSBundle mainBundle] pathForResource:@"jeopardy_sound" ofType:@"caf"];
    cuatosFile = [NSURL fileURLWithPath:cuartosPath];
    quintosFile = [NSURL fileURLWithPath:quintosPath];
    sextosFile = [NSURL fileURLWithPath:sextosPath];
    
    if(!cuartosPlayer){
    cuartosPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:cuatosFile error:nil];
    }
    if(!quintosPlayer){
    quintosPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:quintosFile error:nil];
    }
    if(!sextosPlayer){
    sextosPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:sextosFile error:nil];
    }
    
    
    [cuartosPlayer prepareToPlay];
    [quintosPlayer prepareToPlay];
    [sextosPlayer prepareToPlay];
    
    self.imageView.alphaValue = 1.0;
    
    //Play video in the background
    //NSURL* videoURL = [[NSBundle mainBundle] URLForResource:@"video" withExtension:@"mp4"];
    //self.backgroundPlayer.player = [AVPlayer playerWithURL:videoURL];
    //self.backgroundPlayer.controlsStyle = AVPlayerViewControlsStyleNone;
    //self.backgroundPlayer.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.backgroundPlayer.player currentItem]];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(serialPortsWereConnected:) name:ORSSerialPortsWereConnectedNotification object:nil];
    [nc addObserver:self selector:@selector(serialPortsWereDisconnected:) name:ORSSerialPortsWereDisconnectedNotification object:nil];
}
-(void)updatePort{
    serialPort = [ORSSerialPort serialPortWithPath:[NSString stringWithFormat:@"/dev/cu.%@",selectedPort]];
    NSLog(@"Connecting port: %@", [NSString stringWithFormat:@"/dev/cu.%@",selectedPort]);
    serialPort.delegate = self;
    serialPort.baudRate = [NSNumber numberWithInteger:9600];
    [serialPort open];
}
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}
- (void)serialPort:(ORSSerialPort *)serialPort didReceiveData:(NSData *)data
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Data :) %@", string);
    
    //Will display a custom image when port/button 0, 2 or 3 gets pressed.
    
    if([string isEqualToString:@"3"]){
        [self.imageView setImage:[NSImage imageNamed:@"sextos.png"]];
        [sextosPlayer play];
    }else if([string isEqualToString:@"2"]){
        [self.imageView setImage:[NSImage imageNamed:@"quintos.png"]];
        [quintosPlayer play];
    }else if([string isEqualToString:@"0"]){
        [self.imageView setImage:nil];
    }else{
        [self.imageView setImage:[NSImage imageNamed:@"cuartos.png"]];
        [cuartosPlayer play];
    }
    
}
- (void)serialPortsWereConnected:(NSNotification *)notification
{
    NSArray *connectedPorts = [notification userInfo][ORSConnectedSerialPortsKey];
    NSLog(@"Ports were connected: %@", connectedPorts);
    selectedPort = connectedPorts[0];
    [self updatePort];
    
}

- (void)serialPortsWereDisconnected:(NSNotification *)notification
{
    NSArray *disconnectedPorts = [notification userInfo][ORSDisconnectedSerialPortsKey];
    NSLog(@"Ports were disconnected: %@", disconnectedPorts);
    [serialPort close];
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}
- (void)serialPortWasOpened:(ORSSerialPort *)serialPort
{
    NSLog(@"Opened");
}

- (void)serialPortWasClosed:(ORSSerialPort *)serialPort
{
    NSLog(@"Closed");
}

- (IBAction)myAction:(id)sender {
    NSData *dataToSend = [@"prenderFoco" dataUsingEncoding:NSUTF8StringEncoding];
    [serialPort sendData:dataToSend];
}



@end
