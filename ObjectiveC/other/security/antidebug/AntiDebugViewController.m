//
//  AntiDebugViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/11/16.
//  Copyright © 2022 my. All rights reserved.
//

#import "AntiDebugViewController.h"
#import "MyPtrace.h"
#import <mach-o/dyld.h>
#import <sys/sysctl.h>

@interface AntiDebugViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *show;

@end

@implementation AntiDebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.show.delegate = self;
}

- (IBAction)antiByPtrace:(UIButton *)sender {
    //app反调试防护,运行这行代码后就不再允许其他进程附加上了
    ptrace(PT_DENY_ATTACH, 0, 0, 0);
}

- (BOOL)isDebug{
    int name[4];//里面存放字节码
    name[0] = CTL_KERN;//内核查询
    name[1] = KERN_PROC;//查询进程
    name[2] = KERN_PROC_PID;//传递的参数是进程ID
    name[3] = getpid();//PID 进程ID
    
    struct kinfo_proc info;//查询到的结果放到此结构体
    
    size_t info_size = sizeof(info);
    
    //调试信息
    sysctl(name, sizeof(name)/sizeof(*name), &info, &info_size, 0, 0);
    
    //info.kp_proc.p_flag 第12位若为1则存在调试
    
    return ((info.kp_proc.p_flag & P_TRACED) !=0);
}
- (IBAction)antiDebugProcess:(UIButton *)sender {
    if([self isDebug]){
        [self.show setText:@"正在被调试"];
    }else{
        [self.show setText:@"没有被其他程序调试"];
    }
}

- (IBAction)injectCheck:(UIButton *)sender {
    // 待检测动态库
    NSArray *dylibArr = @[@"race",@"ptrace", @"substitute", @"erver", @"frida"];
    
    NSMutableString *dylib_name = [[NSMutableString alloc] init];
    
    uint32_t count = _dyld_image_count();
    for (uint32_t i = 0 ; i < count; ++i) {
        const char *name = _dyld_get_image_name(i);
        printf("%s\n",name);
        NSString *name2 = [NSString stringWithUTF8String:name];
        for (NSString *symbol_name in dylibArr) {
            if ([name2 containsString:symbol_name]) {
                [dylib_name appendString:name2];
                [dylib_name appendString:@"\n"];
            }
        }
    }
    [self.show setText:dylib_name];
}

- (IBAction)fridaCheck:(UIButton *)sender {
    NSString *frida_path = @"/usr/lib/frida/frida-agent.dylib";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:frida_path]) {
        [self.show setText:@"检测到 frida"];
    }else{
        [self.show setText:@"没有 frida"];
    }
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
