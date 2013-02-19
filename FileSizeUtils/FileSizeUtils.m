//
//  FileSizeUtils.m
//  DemoProj
//
//  Created by Richie Liu on 13-2-19.
//  Copyright (c) 2013年 Richie Liu. All rights reserved.
//

#import "FileSizeUtils.h"
#include <sys/stat.h>
#include <dirent.h>

@interface FileSizeUtils (Private)

+ (long long)_folderSizeAtPath:(const char *)folderPath;

@end

@implementation FileSizeUtils

// 方法1：使用NSFileManager来实现获取文件大小
+ (long long)fileSizeAtPathWithCocoa:(NSString *)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];

    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }

    return 0;
}

// 方法1：使用unix c函数来实现获取文件大小
+ (long long)fileSizeAtPathWithUnixC:(NSString *)filePath
{
    struct stat st;

    if (lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0) {
        return st.st_size;
    }

    return 0;
}

#pragma mark 获取目录大小

// 方法1：循环调用fileSizeAtPath1
+ (long long)folderSizeAtPathWithCocoa:(NSString *)folderPath
{
    NSFileManager *manager = [NSFileManager defaultManager];

    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }

    NSEnumerator    *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString        *fileName;
    long long       folderSize = 0;

    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPathWithCocoa:fileAbsolutePath];
    }

    return folderSize;
}

// 方法3：完全使用unix c函数
+ (long long)folderSizeAtPathWithUnixC:(NSString *)folderPath
{
    return [self _folderSizeAtPath:[folderPath cStringUsingEncoding:NSUTF8StringEncoding]];
}

@end

@implementation FileSizeUtils (Private)
+ (long long)_folderSizeAtPath:(const char *)folderPath
{
    long long   folderSize = 0;
    DIR         *dir = opendir(folderPath);

    if (dir == NULL) {
        return 0;
    }

    struct dirent *child;

    while ((child = readdir(dir)) != NULL) {
        if ((child->d_type == DT_DIR) && (
                ((child->d_name[0] == '.') && (child->d_name[1] == 0)) ||                           // 忽略目录 .
                ((child->d_name[0] == '.') && (child->d_name[1] == '.') && (child->d_name[2] == 0)) // 忽略目录 ..
                )) {
            continue;
        }

        int     folderPathLength = strlen(folderPath);
        char    childPath[1024]; // 子文件的路径地址
        stpcpy(childPath, folderPath);

        if (folderPath[folderPathLength - 1] != '/') {
            childPath[folderPathLength] = '/';
            folderPathLength++;
        }

        stpcpy(childPath + folderPathLength, child->d_name);
        childPath[folderPathLength + child->d_namlen] = 0;

        if (child->d_type == DT_DIR) {                          // directory
            folderSize += [self _folderSizeAtPath:childPath];   // 递归调用子目录
            // 把目录本身所占的空间也加上
            struct stat st;

            if (lstat(childPath, &st) == 0) {
                folderSize += st.st_size;
            }
        } else if ((child->d_type == DT_REG) || (child->d_type == DT_LNK)) { // file or link
            struct stat st;

            if (lstat(childPath, &st) == 0) {
                folderSize += st.st_size;
            }
        }
    }

    return folderSize;
}

@end