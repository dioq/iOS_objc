//
//  NetworkViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/5/15.
//  Copyright © 2019 William. All rights reserved.
//

#import "NSURLSessionVC.h"

//#define url_prefix @"http://127.0.0.1:8090"
#define url_prefix @"http://jobs8.cn:8090"

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
    NSString *urlStr = [NSString stringWithFormat:@"%@/get?name=dio&age=100", url_prefix];
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
            [self showTip:[error localizedDescription]];
        }else {
            // 解析服务器返回的数据
            NSString *resultString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            [self showTip:resultString];
        }
    }];
    [dataTask resume];
}

// 尚未实现
- (IBAction)get2:(UIButton *)sender {
    [self.show setText:@""];
    //1.确定请求路径
    NSString *urlStr = [NSString stringWithFormat:@"%@/get", url_prefix];
    NSURL *url = [NSURL URLWithString:urlStr];
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3. 指定网络请求所走的代理(指定网络代理后,代理抓包获取不到网络数据)
    NSString *host = @"jobs8.cn";//@"127.0.0.1";
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
            [self showTip:[error localizedDescription]];
        }else {
            // 解析服务器返回的数据
            NSString *resultString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            [self showTip:resultString];
        }
    }];
    [dataTask resume];
}

- (IBAction)postAction:(UIButton *)sender {
    [self.show setText:@""];
    NSString *urlStr = [NSString stringWithFormat:@"%@/post", url_prefix];
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
    NSError *error;
    NSData *data= [NSJSONSerialization dataWithJSONObject:[params copy] options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        [self showTip:[error localizedDescription]];
        return;
    }
    request.HTTPBody = data;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        if (error) {
            [self showTip:[error localizedDescription]];
        }else {
            // 解析服务器返回的数据
            NSString *resultString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            [self showTip:resultString];
        }
    }];
    [dataTask resume];
}

- (IBAction)submitAction:(UIButton *)sender {
    [self.show setText:@""];
    NSString *urlStr = [NSString stringWithFormat:@"%@/form", url_prefix];
    
    NSMutableDictionary *textMutDict = [NSMutableDictionary dictionary];
    [textMutDict setValue:@"Dio" forKey:@"name"];
    [textMutDict setValue:@"Beijing" forKey:@"address"];
    [textMutDict setValue:@"18" forKey:@"age"];
    
    NSMutableDictionary *fileMutDict = [NSMutableDictionary dictionary];
    UIImage *image1 = [UIImage imageNamed:@"22"];
    NSData *dt1 = UIImagePNGRepresentation(image1);
    UIImage *image2 = [UIImage imageNamed:@"33"];
    NSData *dt2 = UIImagePNGRepresentation(image2);
    UIImage *image3 = [UIImage imageNamed:@"44"];
    NSData *dt3 = UIImagePNGRepresentation(image3);
    [fileMutDict setValue:dt1 forKey:@"image1.png"];
    [fileMutDict setValue:dt2 forKey:@"image2.png"];
    [fileMutDict setValue:dt3 forKey:@"image3.png"];
    
    /** 以下是提交 form 表单的过程 **/
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 30;
    request.HTTPMethod = @"POST";
    
    NSString *uuidStr = [[NSUUID UUID] UUIDString];
    NSString *boundary = [uuidStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *content_type = [NSString stringWithFormat:@"multipart/form-data;boundary=%@", boundary];
    [request setValue:content_type forHTTPHeaderField:@"Content-Type"];
    
    NSString *line_break = @"\r\n"; // 换行
    NSString *item_start = [NSString stringWithFormat:@"--%@%@",boundary,line_break]; // form-data 每一项开始标志
    NSString *body_end = [NSString stringWithFormat:@"%@--%@--%@",line_break,boundary,line_break]; // body 结束标志
    
    // TEXT 类型数据拼装
    NSMutableData *textMutData = [[NSMutableData alloc] init];
    // 遍历 textMutData
    for (NSString *key in [textMutDict allKeys]) {
        // 1. 每一项的开始
        [textMutData appendData:[item_start dataUsingEncoding:NSUTF8StringEncoding]];
        // 2. 每一项的描述信息
        NSString *content_disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=%@",key];
        [textMutData appendData:[content_disposition dataUsingEncoding:NSUTF8StringEncoding]];
        // 3. 描述信息和数据之间 换2行
        [textMutData appendData:[line_break dataUsingEncoding:NSUTF8StringEncoding]];
        [textMutData appendData:[line_break dataUsingEncoding:NSUTF8StringEncoding]];
        // 4. 每一项的数据
        NSString *value = [textMutDict objectForKey:key];
        [textMutData appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
        // 5. 每一项结束时换行
        [textMutData appendData:[line_break dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // FILE 类型数据拼装
    NSMutableData *fileMutData = [[NSMutableData alloc] init];
    // 遍历 textMutData
    for (NSString *key in [fileMutDict allKeys]) {
        // 1. 每一项的开始
        [fileMutData appendData:[item_start dataUsingEncoding:NSUTF8StringEncoding]];
        // 2. 每一项的描述信息
        NSString *content_disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=%@;",key, key];
        [fileMutData appendData:[content_disposition dataUsingEncoding:NSUTF8StringEncoding]];
        // 3. 描述信息和数据之间 换2行
        [fileMutData appendData:[line_break dataUsingEncoding:NSUTF8StringEncoding]];
        [fileMutData appendData:[line_break dataUsingEncoding:NSUTF8StringEncoding]];
        // 4. 每一项的数据
        NSData *value = [fileMutDict objectForKey:key];
        [fileMutData appendData:value];
        // 5. 每一项结束时换行
        [fileMutData appendData:[line_break dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // body 二进制数据
    NSMutableData *bodyMutData = [[NSMutableData alloc] init];
    [bodyMutData appendData:[textMutData copy]];
    [bodyMutData appendData:[fileMutData copy]];
    
    // body 结束标志
    [bodyMutData appendData:[body_end dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionUploadTask *dataTask = [session uploadTaskWithRequest:request fromData:[bodyMutData copy] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [self showTip:[error localizedDescription]];
        }else {
            NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            [self showTip:result];
        }
    }];
    [dataTask resume];
}

- (IBAction)download:(UIButton *)sender {
    [self.show setText:@""];
    NSString *fileName = @"test.png";
    NSString *urlStr = [NSString stringWithFormat:@"%@/download/%@",url_prefix,fileName];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [self showTip:[error localizedDescription]];
        }else {
            //            NSLog(@"%@", response);
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            long status = [httpResponse statusCode];
            
            if (status == 200) {
                // 创建文件时写入内容
                NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
                NSLog(@"docDir:\n%@",docDir);
                NSString *filePath = [NSString stringWithFormat:@"%@/%@",docDir,fileName];
                BOOL suc = [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
                if (suc) {
                    [self showTip:@"写入数据成功!"];
                }else{
                    [self showTip:@"写入数据失败!"];
                }
            }else {
                NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [self showTip:msg];
            }
        }
    }];
    [dataTask resume];
}

-(void)showTip:(NSString * _Nonnull)tip {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.show setText:tip];
    });
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
