//
//  ViewController.m
//  Simple
//
//  Created by zhangxy on 16/3/11.
//  Copyright © 2016年 zxy. All rights reserved.
//

#import "ViewController.h"

#import "LogUtil.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [LogUtil log:@"----Tag-----" info:@"我是自定义日志" header:LogHeader];
    [LogUtil logError:@"错误" header:LogHeader];
    [LogUtil logInfo:@"普通日志" header:LogHeader];
    [LogUtil logWarning:@"发生警告" header:LogHeader];
    
    // 如果开启存储日志，返回当前日志
    [LogUtil getLogFilePath];
    
    // 如果过期时间比较长，可以查看指定天数的日志
    [LogUtil getLogFilePath:@"yyyyMMdd"];
    
    
    /**
     *  获取指定的日志内容
     *  可以通过getLogFilePath(:)方法获取完整的路径
     */
    [LogUtil readFileContent:@"filePath"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
