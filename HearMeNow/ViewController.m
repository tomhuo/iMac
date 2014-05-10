//
//  ViewController.m
//  HearMeNow
//
//  Created by huojigang on 14-5-10.
//  Copyright (c) 2014年 msa. All rights reserved.
//  This is the view controller implementation file

#import "ViewController.h"

@interface ViewController () {
    BOOL hasRecording;
    AVAudioPlayer *soundPlayer;
    AVAudioRecorder *soundRecorder;
    AVAudioSession *session;
    NSString *soundPath;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    soundPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"hearmenow.wav"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:soundPath];
    session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                           error:&error];
    soundRecorder = [[AVAudioRecorder alloc] initWithURL:url
                                                settings:nil
                                                   error:&error];
    if (error)
    {
        NSLog(@"Error while initializing the recorder: %@", error);
    }
    soundRecorder.delegate = self;
    [soundRecorder prepareToRecord];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordPressed:(id)sender {
    if ([soundRecorder isRecording])
    {
        [soundRecorder stop];
        [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    } else
    {
        [session requestRecordPermission:^(BOOL granted) {
            if(granted)
            {
                [soundRecorder record];
                [self.recordButton setTitle:@"Stop"
                                   forState:UIControlStateNormal];
            } else
            {
                NSLog(@"Unable to record");
            }
        }];
    }
}

- (IBAction)playPressed:(id)sender {
    if (soundPlayer.playing)
    {
        [soundPlayer pause];
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    }
    else if (hasRecording) {
        NSURL *url = [[NSURL alloc] initFileURLWithPath:soundPath];
        NSError *error;
        soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (!error)
        {
            soundPlayer.delegate = self;
            
            soundPlayer.enableRate = YES;
            soundPlayer.rate = 0.5;
            
            [soundPlayer play];
        } else {
            NSLog(@"Error initializing player: %@", error);
        }
        [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
        hasRecording = NO;
    } else if (soundPlayer)
    {
        [soundPlayer play];
        [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    hasRecording = flag;
    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
}




@end
