//
//  CFObjectViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2023/2/28.
//  Copyright © 2023 my. All rights reserved.
//

#import "CFObjectViewController.h"

@interface CFObjectViewController ()

@end

@implementation CFObjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)typeSwitch:(UIButton *)sender {
    /*
     有一些数据类型是能够在 Core Foundation Framework 和 Foundation Framework 之间交换使用的。这意味着，对于同一个数据类型，你既可以将其作为参数传入 Core Foundation 函数，也可以将其作为接收者对其发送 Objective-C 消息（即调用ObjC类方法）。这种在 Core Foundation 和 Foundation 之间交换使用数据类型的技术就叫 Toll-Free Bridging.
     
     三种数据类型转换的形式:
     __bridge:              只做类型转换，但是不修改对象（内存）管理权；
     __bridge_retained:     将Objective-C的对象转换为Core Foundation的对象，同时将对象（内存）的管理权交给我们，后续需要使用CFRelease或者相关方法来释放对象
     __bridge_transfer:     将Core Foundation的对象转换为Objective-C的对象，同时将对象（内存）的管理权交给ARC
     **/
    
    //__bridge：NSArray -> CFArrayRef
    //__bridge不会转换内存管理所有权，ARC仍然具备这个Objective-C对象所有权
    NSArray *aNSArray = @[@1,@2,@3];
    CFArrayRef aCFArray = (__bridge CFArrayRef)aNSArray;
    NSLog(@"size of array = %li",CFArrayGetCount(aCFArray));
    
    //__bridge_retained：NSArray -> CFArrayRef
    //__bridge_retained会转换所有权，ARC失去所有权，而且在不使用时，必须释放。
    NSArray *bNSArray = @[@1,@2,@3];
    CFArrayRef bCFArray = (__bridge_retained CFArrayRef)bNSArray;
    CFRelease(bCFArray);
    
    //__bridge_transfer：CFArrayRef -> NSArray
    // __bridge_transfer 会转换所有权,内存管理交给ARC
    NSString *values[] = {@"hello", @"world"};
    CFArrayRef cCFArray = CFArrayCreate(kCFAllocatorDefault,  (void *)values, (CFIndex)2, NULL);
    NSArray *cNSArray = (__bridge_transfer NSArray*)cCFArray;
    NSLog(@"%@",cNSArray);
}

- (IBAction)cfType:(UIButton *)sender {
    NSArray *testArr = [NSArray arrayWithObjects:@1,@2,@3, nil];
    CFArrayRef theArray = (__bridge_retained CFArrayRef)testArr;
    if(CFGetTypeID(theArray) == CFArrayGetTypeID())
    {
        NSLog(@"is CFArrayRef");
    }else {
        NSLog(@"not CFArrayRef");
    }
    
    NSDictionary *testDict = [NSDictionary dictionaryWithObjectsAndKeys:@1,@"a",@2,@"b", nil];
    CFDictionaryRef theDictionary = (__bridge_retained CFDictionaryRef)testDict;
    NSLog(@"%ld",CFDictionaryGetTypeID());
    if(CFGetTypeID(theDictionary) == CFDictionaryGetTypeID())
    {
        NSLog(@"is CFDictionaryRef");
    }else {
        NSLog(@"not CFDictionaryRef");
    }
    
    NSData *testData = [@"this is a test string" dataUsingEncoding:NSUTF8StringEncoding];
    CFDataRef theData = (__bridge_retained CFDataRef)testData;
    if(CFGetTypeID(theData) == CFDataGetTypeID())
    {
        NSLog(@"is CFDataRef");
    }else {
        NSLog(@"not CFDataRef");
    }
    
    /*
     typedef const void *CFTypeRef;
     CFTypeRef 任意类型
     **/
    CFTypeRef theType = theData;//CFSTR("this a test CFTypeRef demo");
    NSLog(@"theType type:%lu",CFGetTypeID(theType));
    if(CFGetTypeID(theType) == CFDataGetTypeID())
    {
        NSLog(@"is CFDataRef");
    }else {
        NSLog(@"not CFDataRef");
    }
    
    NSDate *date = [NSDate date];
    CFDateRef theDateRef = (__bridge_retained CFDateRef)date;
    if(CFGetTypeID(theDateRef) == CFDateGetTypeID())
    {
        NSLog(@"is CFDateRef");
        NSLog(@"%@", theDateRef);
    }else {
        NSLog(@"not CFDateRef");
    }
    
    NSLog(@"%@",CFCopyTypeIDDescription(301));
    NSLog(@"%@",CFCopyTypeIDDescription(CFDateGetTypeID()));
}

- (IBAction)cftring:(UIButton *)sender {
    char *bytes;
    CFStringRef cfstr;
    bytes = CFAllocatorAllocate(CFAllocatorGetDefault(),6,0);
    strcpy(bytes,"hello");
    cfstr = CFStringCreateWithCStringNoCopy(NULL,bytes,kCFStringEncodingMacRoman,NULL);
    NSLog(@"cfstr:%@",cfstr);
    
    // 直接用 C 字符串 生成 CFStringRef
    CFStringRef cfstr1 = CFStringCreateWithCString(CFAllocatorGetDefault(), "this is a test string", kCFStringEncodingUTF8);
    NSLog(@"%@",cfstr1);
    // 直接用 宏实现
    CFStringRef cfstr2 = CFSTR("this is a new test string 222");
    NSLog(@"%@",cfstr2);
    
    CFRelease(cfstr2);
    CFRelease(cfstr1);
    CFRelease(cfstr); /*默认内存分配一样需要释放bytes内存*/
}

- (IBAction)cfstring2:(UIButton *)sender {
    CFStringRef stringRef = CFSTR("This is 'a test string' for Core Fundation");
    
    // 分割字符串 成字符串数组
    CFStringRef seperatorStringRef = CFSTR("'");
    CFArrayRef stringArrayRef = CFStringCreateArrayBySeparatingStrings(kCFAllocatorDefault, stringRef, seperatorStringRef);
    NSLog(@"stringArrayRef:\n%@\ncount = %ld",stringArrayRef,CFArrayGetCount(stringArrayRef));
    
    // 将字符串数组 拼接成新的字符串
    CFStringRef combineStringRef = CFStringCreateByCombiningStrings(kCFAllocatorDefault, stringArrayRef, CFSTR("|"));
    NSLog(@"combineStringRef:\n%@",combineStringRef);
    
    // 复制字符串
    CFStringRef copyStringRef = CFStringCreateCopy(kCFAllocatorDefault, stringRef);
    NSLog(@"copyStringRef:\n%@",copyStringRef);
    
    CFIndex len = CFStringGetLength(copyStringRef);
    NSLog(@"copyStringRef len = %ld",len);
    
    Boolean flag = CFEqual(stringRef, copyStringRef);
    if(flag) {
        NSLog(@"字符串相同");
    }else{
        NSLog(@"字符串不同");
    }
    
    CFRelease(stringRef);
    CFRelease(seperatorStringRef);
    CFRelease(stringArrayRef);
    CFRelease(combineStringRef);
    CFRelease(copyStringRef);
}

- (IBAction)cfDictionary:(UIButton *)sender {
    CFStringRef keys[] = {CFSTR("key01"), CFSTR("key02")};
    CFStringRef values[] = {CFSTR("Value01"), CFSTR("Value02")};
    
    /*
     创建字典
     keyCallBacks:字典键值的回调，系统预设值kCFTypeDictionaryKeyCallBacks适用于所有CFTypes类型；当KEY是可变类型时，需要保存一个不可变的副本，需要使用kCFCopyStringDictionaryKeyCallBacks；
     valueCallBacks:系统预设值kCFTypeDictionaryValueCallBacks适用于所有CFTypes类型
     */
    CFDictionaryRef dict = CFDictionaryCreate(CFAllocatorGetDefault(), (const void**)keys, (const void**)values, 2, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    NSLog(@"dict:\n%@",dict);
    
    //获取KEY对应的value
    CFStringRef value1 = CFDictionaryGetValue(dict, keys[0]);
    NSLog(@"获取 %@ 对应的值:%@",keys[0],value1);
    
    //判断字典是否包含键、值
    Boolean flag = CFDictionaryContainsKey(dict, keys[0]);
    if(flag) {
        NSLog(@"%@\n包含key:%@",dict,keys[0]);
    }else {
        NSLog(@"%@\n不包含key:%@",dict,keys[0]);
    }
    flag = CFDictionaryContainsValue(dict, value1);
    if(flag) {
        NSLog(@"%@\n包含value:%@",dict,value1);
    }else {
        NSLog(@"%@\n不包含value:%@",dict,value1);
    }
    
    //获取键值对个数
    CFIndex count = CFDictionaryGetCount(dict);
    NSLog(@"获取键值对个数:%ld", count);
    
    // 遍历 CFDictionaryRef
    CFTypeRef *keysTypeRef = (CFTypeRef *)malloc(count * sizeof(CFTypeRef));
    CFTypeRef *valuesTypeRef = (CFTypeRef *) malloc(count * sizeof(CFTypeRef) );
    CFDictionaryGetKeysAndValues(dict, (const void **)keysTypeRef, (const void **)valuesTypeRef);
    const void **keys2 = (const void **) keysTypeRef;
    const void **values2 = (const void **) valuesTypeRef;
    for (CFIndex i = 0; i < count; i++) {
        CFStringRef k = keys2[i];
        CFStringRef v = values2[i];
        NSLog(@"%@:%@",k,v);
        CFRelease(k);
        CFRelease(v);
    }
    
    // 字典的复制
    CFDictionaryRef dictionaryRef2 = CFDictionaryCreateCopy(kCFAllocatorDefault, dict);
    NSLog(@"dictionaryRef2:\n%@",dictionaryRef2);
    
    //根据KEY获取value，如果KEY不存在返回false
    CFStringRef value = NULL;
    flag = CFDictionaryGetValueIfPresent(dict, keys[0], (const void **)&value);
    if(flag){
        NSLog(@"%@\n里%@对应的值:%@",dict,keys[0],value);
    }else{
        NSLog(@"%@\n里没%@对应的值",dict,keys[0]);
    }
    
    if(value) {
        CFRelease(value);
    }
    CFRelease(value1);
    CFRelease(dictionaryRef2);
    CFRelease(dict);
}

- (IBAction)cfmutableDictionary:(UIButton *)sender {
    CFStringRef values[] = {CFSTR("k1"), CFSTR("v1")};
    CFArrayRef arrayRef = CFArrayCreate(kCFAllocatorDefault, (void *)values, (CFIndex)2, NULL);
    CFStringRef values2[] = {CFSTR("k2"), CFSTR("v2")};
    CFArrayRef arrayRef2 = CFArrayCreate(kCFAllocatorDefault, (void *)values2, (CFIndex)2, NULL);
    CFStringRef values3[] = {CFSTR("k3"), CFSTR("v3")};
    CFArrayRef arrayRef3 = CFArrayCreate(kCFAllocatorDefault, (void *)values3, (CFIndex)2, NULL);
    
    //创建可变字典 0表示不限制个数
    CFMutableDictionaryRef mutDic = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    //添加键、值
    CFDictionaryAddValue(mutDic, CFSTR("genp"), arrayRef);
    CFDictionaryAddValue(mutDic, CFSTR("cert"), arrayRef2);
    NSLog(@"添加键值:\n%@",mutDic);
    
    //获取键值对个数
    CFIndex count = CFDictionaryGetCount(mutDic);
    NSLog(@"获取键值对个数:%ld", count);
    
    // 遍历 CFDictionary 中的所有 key 和 value
    NSLog(@"遍历键值");
    CFDictionaryApplyFunction(mutDic, keyAndvalue, NULL);
    
    //修改值
    CFDictionarySetValue(mutDic, CFSTR("cert"), arrayRef3);
    NSLog(@"修改键值:\n%@",mutDic);
    
    // 可变字典的复制
    CFMutableDictionaryRef muDicRef2 = CFDictionaryCreateMutableCopy(kCFAllocatorDefault, 0, mutDic);
    
    //删除键、值
    CFDictionaryRemoveValue(mutDic, CFSTR("cert"));
    NSLog(@"删除键值:\n%@",mutDic);
    
    NSLog(@"muDicRef2:\n%@",muDicRef2);
    
    //清空字典
    CFDictionaryRemoveAllValues(mutDic);
    
    // 释放内存
    CFRelease(muDicRef2);
    CFRelease(mutDic);
    CFRelease(arrayRef3);
    CFRelease(arrayRef2);
    CFRelease(arrayRef);
}

void keyAndvalue(const void *key, const void *value, void *context)
{
    CFStringRef _key = (CFStringRef)key;
    CFArrayRef _value = (CFArrayRef)value;
    NSLog(@"%@:%@", _key, _value);
}

- (IBAction)allKeysAndValues:(UIButton *)sender {
    CFStringRef values[] = {CFSTR("k1"), CFSTR("v1")};
    CFArrayRef arrayRef1 = CFArrayCreate(kCFAllocatorDefault, (void *)values, (CFIndex)2, NULL);
    CFStringRef values2[] = {CFSTR("k2"), CFSTR("v2")};
    CFArrayRef arrayRef2 = CFArrayCreate(kCFAllocatorDefault, (void *)values2, (CFIndex)2, NULL);
    CFStringRef values3[] = {CFSTR("k3"), CFSTR("v3")};
    CFArrayRef arrayRef3 = CFArrayCreate(kCFAllocatorDefault, (void *)values3, (CFIndex)2, NULL);
    
    //创建可变字典 0表示不限制个数
    CFMutableDictionaryRef mutDic = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    //添加键、值
    CFDictionaryAddValue(mutDic, CFSTR("genp"), arrayRef1);
    CFDictionaryAddValue(mutDic, CFSTR("cert"), arrayRef2);
    CFDictionaryAddValue(mutDic, CFSTR("inet"), arrayRef3);
    
    CFIndex count = CFDictionaryGetCount(mutDic);
    
    // 遍历 CFDictionaryRef
    CFTypeRef *keysTypeRef = (CFTypeRef *)malloc(count * sizeof(CFTypeRef));
    CFTypeRef *valuesTypeRef = (CFTypeRef *)malloc(count * sizeof(CFTypeRef));
    CFDictionaryGetKeysAndValues(mutDic, (const void **)keysTypeRef, (const void **)valuesTypeRef);
    const void **allKeys = (const void **) keysTypeRef;
    const void **allValues = (const void **) valuesTypeRef;
    for (CFIndex i = 0; i < count; i++) {
        CFStringRef k = allKeys[i];
        CFArrayRef v = allValues[i];
        NSLog(@"%@:\n%@",k,v);
        CFRelease(k);
        CFRelease(v);
    }
    
    free(valuesTypeRef);
    free(keysTypeRef);
//    CFRelease(valuesTypeRef);
//    CFRelease(keysTypeRef);
    CFRelease(mutDic);
}

- (IBAction)cfArray:(UIButton *)sender {
    CFStringRef values[] = {CFSTR("aaa"), CFSTR("bbb")};
    CFArrayRef arrayRef = CFArrayCreate(kCFAllocatorDefault, (void *)values, (CFIndex)2, NULL);
    NSLog(@"%@",arrayRef);
    
    CFIndex count = CFArrayGetCount(arrayRef);
    NSLog(@"count:%ld", count);
    
    CFStringRef value = CFArrayGetValueAtIndex(arrayRef, 1);
    NSLog(@"values[1] %@",value);
    
    // 数组的复制
    CFArrayRef cfArrayCopyNew = CFArrayCreateCopy(kCFAllocatorDefault, arrayRef);
    NSLog(@"%@",cfArrayCopyNew);
    
    CFRelease(cfArrayCopyNew);
    CFRelease(value);
    CFRelease(arrayRef);
}

- (IBAction)cfMutableArrayRef:(UIButton *)sender {
    //可变
    CFMutableArrayRef muArrayRef1 = CFArrayCreateMutable(kCFAllocatorDefault, 0, NULL);
    //添加元素
    CFArrayAppendValue(muArrayRef1, CFSTR("this is first string"));
    CFArrayAppendValue(muArrayRef1, CFSTR("this is second string"));
    NSLog(@"muArrayRef1:\n%@",muArrayRef1);
    CFStringRef value = CFArrayGetValueAtIndex(muArrayRef1, 1);
    NSLog(@"arr[1]=%@",value);
    
    // 可变数组的复制
    CFMutableArrayRef muArrayRef2 = CFArrayCreateMutableCopy(kCFAllocatorDefault, 0, muArrayRef1);
    CFArrayAppendValue(muArrayRef2, CFSTR("this is third string"));
    NSLog(@"muArrayRef2:\n%@",muArrayRef2);
    // 删除元素
    CFArrayRemoveValueAtIndex(muArrayRef2, 1);
    NSLog(@"muArrayRef2:\n%@",muArrayRef2);
    NSLog(@"muArrayRef1:\n%@",muArrayRef1);
    
    CFRelease(value);
    CFRelease(muArrayRef2);
    CFRelease(muArrayRef1);
}

@end
