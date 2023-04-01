//
//  TimeViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/9/2.
//  Copyright © 2022 my. All rights reserved.
//

#import "TimeViewController.h"

@interface TimeViewController ()

@end

@implementation TimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)timestampAction:(UIButton *)sender {
    // 以下这个结果是10位数
    NSDate *date = [NSDate date];
    NSLog(@"date = %@\n",date);
    // date = 2017-10-27 05:03:09 +0000

    NSTimeInterval interval = [date timeIntervalSince1970];
    NSInteger timestamp = interval;
    NSLog(@"timestamp:%ld",timestamp); //时间戳
    
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:interval];
    NSLog(@"date = %@\n",date2);
}

- (IBAction)basicAPI:(UIButton *)sender {
    NSDate *date = [NSDate date];
    NSLog(@"date = %@\n",date);
    // date = 2017-10-27 05:03:09 +0000

    NSTimeInterval interval = [date timeIntervalSince1970];
    NSInteger timestamp = interval;
    NSLog(@"timestamp:%ld",timestamp); //时间戳
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd aHH:mm:ss"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    // 2017-10-27 下午13:30:52

    [dateFormatter setDateFormat:@"'公元（G=GG=GGG=GGGG=GGGGG）':G'='GG'='GGG'='GGGG'='GGGGG"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    // 公元（G=GG=GGG=GGGG=GGGGG）:公元=公元=公元=公元=公元

    [dateFormatter setDateFormat:@"'年度（y=yy=yyy=yyyy=yyyyy）':y'='yy'='yyy'='yyyy'='yyyyy"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    // 年度（y=yy=yyy=yyyy=yyyyy）:2017=17=2017=2017=02017

    [dateFormatter setDateFormat:@"'季度（Q=QQ=QQQ=QQQQ）':Q'='QQ'='QQQ'='QQQQ"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    // 季度（Q=QQ=QQQ=QQQQ）:4=04=4季度=第四季度

    [dateFormatter setDateFormat:@"'季度（q=qq=qqq=qqq）':q'='qq'='qqq'='qqqq"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    // 季度（q=qq=qqq=qqq）:4=04=4季度=第四季度

    [dateFormatter setDateFormat:@"'月份（M=MM=MMM=MMMM=MMMMM）':M'='MM'='MMM'='MMMM'='MMMMM"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    // 月份（M=MM=MMM=MMMM=MMMMM）:10=10=10月=十月=10
    // 月份（M=MM=MMM=MMMM=MMMMM）:3=03=3月=三月=3

    [dateFormatter setDateFormat:@"'本年第几周（w）':w"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    // 本年第几周（w）:43

    [dateFormatter setDateFormat:@"'本月第几周（W）':W"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    // 本月第几周（W）:4

    [dateFormatter setDateFormat:@"'本年第几天（D）':D"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    // 本年第几天（D）:300

    [dateFormatter setDateFormat:@"'本月第几天（d=dd）':d'='dd"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    // 本月第几天（d=dd）:27=27
    // 本月第几天（d=dd）:3=03

    [dateFormatter setDateFormat:@"'本周第几天（F）':F"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    // 本周第几天（F）:4

    [dateFormatter setDateFormat:@"'星期（e=ee=eee=eeee=eeeee）':e'='ee'='eee'='eeee'='eeeee"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    // 星期（e=ee=eee=eeee=eeeee）:6=06=周五=星期五=五

    [dateFormatter setDateFormat:@"'星期（c=ccc=cccc=ccccc）':c'='ccc'='cccc'='ccccc"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    // 星期（c=ccc=cccc=ccccc）:6=周五=星期五=五

    [dateFormatter setDateFormat:@"'上午/下午（a）':a"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    // 上午/下午（a）:下午

    [dateFormatter setDateFormat:@"'小时（h=hh=H=HH）':h'='hh'='H'='HH"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    // 小时（h=hh=H=HH）:1=01=13=13

    [dateFormatter setDateFormat:@"'分钟（m=mm）':m'='mm"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    // 分钟（m=mm）:3=03

    [dateFormatter setDateFormat:@"'秒（s=ss）':s'='ss"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    // 秒（s=ss）:9=09

    [dateFormatter setDateFormat:@"'毫秒（S）':S"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    // 毫秒（S）:9

    [dateFormatter setDateFormat:@"'一天中的毫秒（A）':A"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    // 一天中的毫秒（A）:46989943

    [dateFormatter setDateFormat:@"'时区（z/zz/zzz=zzzz=v=vvvv）':z'='zzzz'='v'='vvvv"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    // 时区（z/zz/zzz=zzzz=v=vvvv）:GMT+8=中国标准时间=中国时间=中国标准时间

    [dateFormatter setDateFormat:@"'时区编号（Z/ZZ/ZZZ=ZZZZ）':Z'='ZZZZ"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    // 时区编号（Z/ZZ/ZZZ=ZZZZ）:+0800=GMT+08:00
}

@end
