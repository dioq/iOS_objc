# 文件处理

## sandbox directory

// 获取沙盒根目录路径
homeDir = NSHomeDirectory();
NSLog(@"homeDir:\n%@",homeDir);

// 获取Documents目录路径
NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
NSLog(@"docDir:\n%@",docDir);

//获取Library的目录路径
NSString *libDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) firstObject];
NSLog(@"libDir:\n%@",libDir);

// 获取cache目录路径
NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) firstObject];
NSLog(@"cachesDir:\n%@",cachesDir);

// 获取tmp目录路径
NSString *tmpDir = NSTemporaryDirectory();
NSLog(@"tmpDir:\n%@",tmpDir);

## file manage

// 获取文件管理器
NSFileManager *fileManager = [NSFileManager defaultManager];

// 创建目录
[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];

// NSString *str 字符串写入文件
[str writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];

// NSData *data 写入文件
[fileManager createFileAtPath:path contents:data attributes:nil];

// 读取文件内容
NSData *data = [fileManager contentsAtPath:path];

// copy file
BOOL suc = [fileManager copyItemAtPath:sourcePath toPath:targetPath error:&error];

// move file
BOOL suc = [fileManager moveItemAtPath:sourcePath toPath:targetPath error:&error];

// delete file
BOOL suc = [fileManager removeItemAtPath:path error:&error];

// 获取目录下的所有内容(文件和目录)
NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:&error];
for (int i = 0; i < contents.count; i++) {
NSString *filename = [contents objectAtIndex:i];
}
