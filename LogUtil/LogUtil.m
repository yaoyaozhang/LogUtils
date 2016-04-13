//
//  LogUtil.m
//  XcodeUtils
//
//  Created by zhangxy on 16/3/9.
//  Copyright © 2016年 zhangxy. All rights reserved.
//

#import "LogUtil.h"

// 缓存路径
#define FILE_PATH      @"/Documents/Log/"

// 缓存时长
#define Log_Cache_Days 1

@implementation LogUtil


+(void)log:(NSString *) log cache:(BOOL) isCache{
    if(Log_WS_Flag){
        NSLog(@"%@",log);
    }
    if(isCache){
        [self cacheLog:log];
    }
}



+(void)logText:(NSString *)format, ...{
    if(!format){
        return;
    }
    va_list arglist;
    va_start(arglist, format);
    NSString *outStr = [[NSString alloc] initWithFormat:format arguments:arglist];
    va_end(arglist);
    
    [self log:outStr cache:NO];
}

+(void)logHeader:(NSString *)header info:(NSString *)format, ...{
    if(!format){
        return;
    }
    va_list arglist;
    va_start(arglist, format);
    NSString *outStr = [[NSString alloc] initWithFormat:format arguments:arglist];
    va_end(arglist);
    
    NSString *text = [NSString stringWithFormat:@"%@\nInfo:\n%@",header,outStr];
    [self log:text cache:(Log_Cache_Flag && Log_Cache_CustomFlag)];
}

+(void)logHeader:(NSString *)header error:(NSString *)format, ...{
    
    if(!format){
        return;
    }
    va_list arglist;
    va_start(arglist, format);
    NSString *outStr = [[NSString alloc] initWithFormat:format arguments:arglist];
    va_end(arglist);
    
    NSString *text = [NSString stringWithFormat:@"%@\nError:\n%@",header,outStr];
    [self log:text cache:(Log_Cache_Flag && Log_Cache_InfoFlag)];
}

+(void)logHeader:(NSString *)header warning:(NSString *)format, ...{
    if(!format){
        return;
    }
    va_list arglist;
    va_start(arglist, format);
    NSString *outStr = [[NSString alloc] initWithFormat:format arguments:arglist];
    va_end(arglist);
    
    
    NSString *text = [NSString stringWithFormat:@"%@\nWarning:\n%@",header,outStr];
    [self log:text cache:(Log_Cache_Flag && Log_Cache_ErrorFlag)];
}

////////////////////////////////////////////////////////////


+(void)cacheLog:(NSString *)message {
    [self checkPathAndCreate:[self getDocumentsFilePath:@""]];
    
    NSString *logPath = [self getLogFilePath];
    
    [self checkFileAndCreate:logPath];
    
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:logPath];
    [fileHandler seekToEndOfFile];
    [fileHandler writeData:[message dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandler closeFile];
}

+(NSString *) getDocumentsFilePath:(NSString*) fileName {
    
    NSString* documentRoot = [NSHomeDirectory() stringByAppendingPathComponent:FILE_PATH];
    
    return [documentRoot stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", fileName]];
}


+(BOOL) checkFileAndCreate:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath]){
        return YES;
    }else{
        // 清理缓存
        [self cleanCache];
        
        return [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
}



+(BOOL) checkPathAndCreate:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath]){
        return YES;
    }else{
        return [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}



////////////////////////////////////////////////////////////


+(NSString * )getLogFilePath{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    //    NSString * dateString = [[NSString alloc] init];
    NSString * dateString = [dateFormatter stringForObjectValue:[NSDate date]];
    return [self getLogFilePath:dateString];
}

+(NSString * )getLogFilePath:(NSString *) dateString{
    return [self getDocumentsFilePath:[NSString stringWithFormat:@"Log_%@.txt",dateString]];
}

+(NSString *) readFileContent:(NSString *) filePath{
   return [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}


////////////////////////////////////////////////////////////
+(void)cleanCache{
    NSString *logPath=[self getDocumentsFilePath:@""];
    dispatch_sync(dispatch_queue_create("com.log.cache", DISPATCH_QUEUE_SERIAL), ^{
        // 清理过期
        NSFileManager *_fileManager = [NSFileManager new];
        
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:logPath];
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [logPath stringByAppendingPathComponent:fileName];
            // 过期，直接删除
            if(![self logIsValid:filePath]){
                [_fileManager removeItemAtPath:filePath error:nil];
            }
        }
    });
}

+ (int)Interval:(NSString *) filePath
{
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    //NSLog(@"create date:%@",[attributes fileModificationDate]);
    NSString *dateString = [NSString stringWithFormat:@"%@",[attributes fileModificationDate]];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    
    NSDate *formatterDate = [inputFormatter dateFromString:dateString];
    
    unsigned int unitFlags = NSCalendarUnitDay;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *d = [cal components:unitFlags fromDate:formatterDate toDate:[NSDate date] options:0];
    
    //NSLog(@"%d,%d,%d,%d",[d year],[d day],[d hour],[d minute]);
    
    int result = (int)d.day;
    
    //	return 0;
    return result;
}


+(BOOL)logIsValid:(NSString *) filePath{
    if ([self Interval:filePath] < Log_Cache_Days) { //VALIDDAYS = 有效时间天数
        return YES;
    }
    return NO;
}
@end
