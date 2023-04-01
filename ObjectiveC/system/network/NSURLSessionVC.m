//
//  NetworkViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/5/15.
//  Copyright © 2019 William. All rights reserved.
//

#import "NSURLSessionVC.h"

@interface NSURLSessionVC ()<NSURLSessionDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *show;

@end

@implementation NSURLSessionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"原生网络请求";
    self.show.delegate = self;
}

- (IBAction)getAction:(UIButton *)sender {
    [self.show setText:@""];
    //1.确定请求路径
    NSString *urlStr = @"http://jobs8.cn:8090/get?name=dio&age=100";
    NSURL *url = [NSURL URLWithString:urlStr];
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    //4.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",[error localizedDescription]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.show setText:[error localizedDescription]];
            });
        }else {
            //6.解析服务器返回的数据
            //NSData转成NSString
            NSString *resultString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", resultString);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.show setText:resultString];
            });
        }
    }];
    //5.执行任务
    [dataTask resume];
}

- (IBAction)get2:(UIButton *)sender {
    [self.show setText:@""];
    //1.确定请求路径
    NSString *urlStr = @"http://jobs8.cn:8090/get";
    NSURL *url = [NSURL URLWithString:urlStr];
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3. 指定网络请求所走的代理(指定网络代理后,代理抓包获取不到网络数据)
    NSString *host = @"jobs8.cn";
    NSNumber *proxyPort = [NSNumber numberWithInt:8090];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.connectionProxyDictionary = @{
        @"HTTPEnable":@YES,
        @"HTTPProxy" : host,
        @"HTTPPort" : proxyPort,
        @"HTTPSEnable":@YES,
        @"HTTPSProxy": host,
        @"HTTPSPort": proxyPort
    };
    //4.获得会话对象
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",[error localizedDescription]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.show setText:[error localizedDescription]];
            });
        }else {
            //6.解析服务器返回的数据
            //NSData转成NSString
            NSString *resultString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", resultString);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.show setText:resultString];
            });
        }
    }];
    //5.执行任务
    [dataTask resume];
}

- (IBAction)postAction:(UIButton *)sender {
    [self.show setText:@""];
    NSString *urlStr = @"http://jobs8.cn:8090/post";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置超时时间
    request.timeoutInterval = 30;
    //设置请求头
    [request setValue:@"gzip, deflate, br" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];//设置请求的Content-Type
    //3.修改请求方法为POST
    request.HTTPMethod = @"POST";
    //4.设置请求体(如图body)
    /*
     {"username":"Dio","password":"13131313","argot":"You are geat!","num":11111}
     最终需传到后台的json 字符串。 为了拼接方便就先把所有参数放在 NSMutableDictionary 里，然后再转换成 json字符串的二进制形式
     **/
    NSMutableDictionary<NSString *,NSObject *> *params = [NSMutableDictionary dictionary];
    [params setValue:@"Dio" forKey:@"name"];
    [params setValue:@18 forKey:@"age"];
    //NSMutableDictionary 转成 json字符串的二进制形式
    NSData *data= [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = data;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        if (error) {
            NSLog(@"%@",[error localizedDescription]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.show setText:[error localizedDescription]];
            });
        }else {
            //6.解析服务器返回的数据
            //NSData转成NSString
            NSString *resultString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", resultString);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.show setText:resultString];
            });
        }
    }];
    //7.执行任务
    [dataTask resume];
}

- (IBAction)uploadAction:(UIButton *)sender {
    [self.show setText:@""];
    NSString *urlStr = @"http://jobs8.cn:8090/upload";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 30;
    request.HTTPMethod = @"POST";
    
    NSString *boundary = [[NSUUID UUID] UUIDString];
    boundary = [boundary stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *head = [NSString stringWithFormat:@"multipart/form-data;boundary=%@", boundary];
    [request setValue:head forHTTPHeaderField:@"Content-Type"];
    
    NSString *newLine = @"\r\n";
    NSMutableData *param_data = [[NSMutableData alloc] init];
    
    NSString *body1 = [NSString stringWithFormat:@"--%@%@",boundary,newLine];
    [param_data appendData:[body1 dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *name = @"file";
    NSString *filename = @"paihangbang_anniu.png";
    NSString *content = [NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=%@;",name, filename];
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    [param_data appendData:contentData];
    [param_data appendData:[newLine dataUsingEncoding:NSUTF8StringEncoding]];
    [param_data appendData:[newLine dataUsingEncoding:NSUTF8StringEncoding]];
    
    UIImage *img = [UIImage imageNamed:filename];
    NSData *imgData = UIImageJPEGRepresentation(img, 1.0);
    //    UIImagePNGRepresentation(img)
    [param_data appendData:imgData];
    
    NSString *body2 = [NSString stringWithFormat:@"%@--%@--%@",newLine,boundary,newLine];
    [param_data appendData:[body2 dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionUploadTask *dataTask = [session uploadTaskWithRequest:request fromData:param_data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",[error localizedDescription]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.show setText:[error localizedDescription]];
            });
        }else {
            //6.解析服务器返回的数据
            //NSData转成NSString
            NSString *resultString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", resultString);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.show setText:resultString];
            });
        }
    }];
    [dataTask resume];
}

- (IBAction)download:(UIButton *)sender {
    [self.show setText:@""];
    NSString *fileName = @"test.png";
    NSString *urlStr = [NSString stringWithFormat:@"http://jobs8.cn:8090/%@",fileName];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",[error localizedDescription]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.show setText:[error localizedDescription]];
            });
        }else {
            // 创建文件时写入内容
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
            NSLog(@"docDir:\n%@",docDir);
            NSString *filePath = [NSString stringWithFormat:@"%@/%@",docDir,fileName];
            BOOL suc = [fileManager createFileAtPath:filePath contents:data attributes:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (suc) {
                    [self.show setText:@"写入数据成功!"];
                }else{
                    [self.show setText:@"写入数据失败!"];
                }
            });
        }
    }];
    [dataTask resume];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
