//
//  ViewController.h
//  sample2
//
//  Created by Karlo A. López on 4/14/16.
//  Copyright © 2016 karlol. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ORSSerialPort.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@interface ViewController : NSViewController <ORSSerialPortDelegate>
@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet AVPlayerView *backgroundPlayer;


@end

