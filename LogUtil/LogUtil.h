//
//  LogUtil.h
//  XcodeUtils
//
//  Created by zhangxy on 16/3/9.
//  Copyright © 2016年 zhangxy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Log_WS_Flag           1     // 输出日志开关
#define Log_Cache_Flag        1     // 保存日志总开关
#define Log_Cache_ErrorFlag   1     // 总开关下 错误日志保存
#define Log_Cache_InfoFlag    1     // 总开关下 消息日志保存
#define Log_Cache_WarningFlag 1     // 总开关下 警告日志保存
#define Log_Cache_CustomFlag  1     // 总开关下 自定义日志保存

// 日志输出头，再方法内部不能获取方法和行号，需要调用时传递
#define LogHeader [NSString stringWithFormat:@"\n=======================\n%@ %@\n%s[%d]",[[NSBundle mainBundle] bundleIdentifier],[NSDate date],__FUNCTION__,__LINE__]


@interface LogUtil : NSObject

/**
 *  输出日志
 *
 *  @param tag    日志自定义标签
 *  @param log    日志内容
 *  @param header 日志行号、方法名称,直接传递LogHeader宏定义即可
 */
+(void)log:(NSString *) tag info:(NSString *) log header:(NSString *) header;


/**
 *  输出指定标签日志
 *
 *  @param log    日志内容
 *  @param header 日志行号、方法名称,直接传递LogHeader宏定义即可
 */
+(void)logText:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
+(void)logHeader:(NSString *) header info:(NSString *)format, ... NS_FORMAT_FUNCTION(2,3);
+(void)logHeader:(NSString *) header error:(NSString *)format, ... NS_FORMAT_FUNCTION(2,3);
+(void)logHeader:(NSString *) header warning:(NSString *)format, ... NS_FORMAT_FUNCTION(2,3);;


/**
 *  根据设定的过期时长，清理日志，默认是1天
 */
+(void)cleanCache;


/**
 *  获取缓存日志
 *
 *  @return 缓存日志路径
 */
+(NSString * )getLogFilePath;

/**
 *  获取缓存日志
 *
 *  @param dateString 具体哪一天的日志，格式yyyyMMdd
 *
 *  @return 缓存日志路径
 */
+(NSString * )getLogFilePath:(NSString *) dateString;



/**
 *  读取文件内容
 *
 *  @param filePath 文件完整路径，可通过getLogFilePath(:)获取
 *
 *  @return 文件内容
 */
+(NSString *) readFileContent:(NSString *) filePath;

@end
