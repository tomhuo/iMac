//
//  ViewController.h
//  HearMeNow
//
//  Created by huojigang on 14-5-10.
//  Copyright (c) 2014年 msa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController<AVAudioPlayerDelegate,AVAudioRecorderDelegate>
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
- (IBAction)recordPressed:(id)sender;
- (IBAction)playPressed:(id)sender;


@end
