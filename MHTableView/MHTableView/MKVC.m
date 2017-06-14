//
//  MKVC.m
//  MHTableView
//
//  Created by MH on 2017/5/15.
//  Copyright © 2017年 MH. All rights reserved.
//

#import "MKVC.h"
#import "SoundVC.h"
#import "XHSoundRecorder.h"
@interface MKVC ()
@property (nonatomic, strong) NSMutableArray *filePaths;

@property (nonatomic, copy) NSString *file;
@end

@implementation MKVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"录音";
    
    UIButton * bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(100, 200, 60, 20);
    bt.backgroundColor = [UIColor whiteColor];
    [bt setTitle:@"录音" forState:0];
    [bt setTitle:@"停止" forState:UIControlStateSelected];
    [bt setTitleColor:[UIColor blackColor] forState:0];
    bt.titleLabel.font = [UIFont systemFontOfSize:17];
    [bt addTarget:self action:@selector(gonext:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    UIButton * bt1 = [UIButton buttonWithType:UIButtonTypeCustom];
    bt1.frame = CGRectMake(200, 200, 60, 20);
    bt1.backgroundColor = [UIColor whiteColor];
    [bt1 setTitle:@"播放" forState:0];
    [bt1 setTitle:@"停止" forState:UIControlStateSelected];
    [bt1 setTitleColor:[UIColor blackColor] forState:0];
    bt1.titleLabel.font = [UIFont systemFontOfSize:17];
    [bt1 addTarget:self action:@selector(goplay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt1];
    
    
}

- (NSMutableArray *)filePaths {
    
    if (!_filePaths) {
        
        _filePaths = [NSMutableArray array];
    }
    
    return _filePaths;
}

- (void)gonext:(UIButton*)button{
    WS(weakSelf)
    if (!button.selected) {
        button.selected = YES;
        [[XHSoundRecorder sharedSoundRecorder] removeSoundRecorder];
        [[XHSoundRecorder sharedSoundRecorder] startRecorder:^(NSString *filePath) {
            
            NSLog(@"录音文件路径:%@",filePath);
            
            NSLog(@"录音结束");
//            //时长
//            AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
//            CMTime   time = [asset duration];
//            long long seconds = ceil(time.value/time.timescale);
            
           
            
            
            [weakSelf.filePaths addObject:filePath];
            
            weakSelf.file = filePath;
        }];
    }else{
        [[XHSoundRecorder sharedSoundRecorder] stopRecorder];
        button.selected = NO;
    }
}

- (void)goplay:(UIButton*)button{
    if (!button.selected) {
        button.selected = YES;
        [[XHSoundRecorder sharedSoundRecorder] playsound:self.file withFinishPlaying:^{
            NSLog(@"播放结束");
        }];
    }else{
        button.selected = NO;
        [[XHSoundRecorder sharedSoundRecorder] stopPlaysound];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toMp3{
    
    typeof(self) wSelf = self;
    
    [[XHSoundRecorder sharedSoundRecorder] recorderFileToMp3WithType:Simulator filePath:nil FilePath:^(NSString *newfilePath) {
        
        NSLog(@"转换之后的路径:%@",newfilePath);
        
        [wSelf.filePaths removeObject:self.file];
        
        [wSelf.filePaths addObject:newfilePath];
        
    }];
    
    
}


@end
