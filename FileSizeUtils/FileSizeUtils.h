//
//  FileSizeUtils.h
//  DemoProj
//
//  Created by Richie Liu on 13-2-19.
//  Copyright (c) 2013年 Richie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileSizeUtils : NSObject

// 方法1：使用NSFileManager来实现获取文件大小
+ (long long)fileSizeAtPathWithCocoa:(NSString *)filePath;
// 方法1：使用unix c函数来实现获取文件大小
+ (long long)fileSizeAtPathWithUnixC:(NSString *)filePath;

// 方法1：循环调用fileSizeAtPathWithCocoa
+ (long long)folderSizeAtPathWithCocoa:(NSString *)folderPath;
// 方法2：在fileSizeAtPathWithUnixC基础之上，去除文件路径相关的字符串拼接工作
+ (long long)folderSizeAtPathWithUnixC:(NSString *)folderPath;

@end
