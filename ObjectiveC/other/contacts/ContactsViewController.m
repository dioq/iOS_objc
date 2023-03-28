//
//  ContactsViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/8/12.
//  Copyright © 2022 my. All rights reserved.
//

#import "ContactsViewController.h"
#import <Contacts/Contacts.h>
#import "LJContactManager.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "LJPerson.h"
#import "LJPeoplePickerDelegate.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "LJPickerDetailDelegate.h"
#import "NSString+LJExtension.h"

@interface ContactsViewController ()<ABNewPersonViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate, CNContactViewControllerDelegate, CNContactPickerDelegate>

@property(nonatomic,assign)BOOL contactAuthor;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestContactAuthorAfterSystemVersion9];
}

//请求通讯录权限
#pragma mark 请求通讯录权限
- (void)requestContactAuthorAfterSystemVersion9{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
            if (error) {
                NSLog(@"授权失败");
            }else {
                NSLog(@"成功授权");
            }
        }];
    }else if(status == CNAuthorizationStatusRestricted) {
        NSLog(@"用户拒绝");
        self.contactAuthor = NO;
        [self showAlertViewAboutNotAuthorAccessContact];
    }else if (status == CNAuthorizationStatusDenied) {
        NSLog(@"用户拒绝");
        self.contactAuthor = NO;
        [self showAlertViewAboutNotAuthorAccessContact];
    }else if (status == CNAuthorizationStatusAuthorized)//已经授权
    {
        //有通讯录权限-- 进行下一步操作
        //        [self openContact];
        self.contactAuthor = YES;
    }
}

- (IBAction)readAction:(UIButton *)sender {
    if (self.contactAuthor) {
        [self openContact];
    }else{
        [self requestContactAuthorAfterSystemVersion9];
    }
}

- (IBAction)writeAction:(UIButton *)sender {
    NSString *phoneNum = @"14242342342";
//    [[LJContactManager sharedInstance] createNewContactWithPhoneNum:@"775543557666776" controller:self];
    CNMutableContact *contact = [[CNMutableContact alloc] init];
    CNLabeledValue *labelValue = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile
                                                                 value:[CNPhoneNumber phoneNumberWithStringValue:phoneNum]];
    contact.phoneNumbers = @[labelValue];
    CNContactViewController *contactController = [CNContactViewController viewControllerForNewContact:contact];
    contactController.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:contactController];
    [self presentViewController:nav animated:YES completion:nil];
}

//有通讯录权限-- 进行下一步操作
- (void)openContact{
    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSLog(@"-------------------------------------------------------");
        NSString *givenName = contact.givenName;
        NSString *familyName = contact.familyName;
        NSLog(@"givenName=%@, familyName=%@", givenName, familyName);
        //拼接姓名
        NSString *nameStr = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
        
        NSArray *phoneNumbers = contact.phoneNumbers;
        //        CNPhoneNumber  * cnphoneNumber = contact.phoneNumbers[0];
        //        NSString * phoneNumber = cnphoneNumber.stringValue;
        for (CNLabeledValue *labelValue in phoneNumbers) {
            //遍历一个人名下的多个电话号码
//            NSString *label = labelValue.label;
            //   NSString *    phoneNumber = labelValue.value;
            CNPhoneNumber *phoneNumber = labelValue.value;
            NSString * string = phoneNumber.stringValue ;
            //去掉电话中的特殊字符
            string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSLog(@"姓名=%@, 电话号码是=%@", nameStr, string);
        }
        
        //    *stop = YES; // 停止循环，相当于break；
    }];
}

//提示没有通讯录权限
- (void)showAlertViewAboutNotAuthorAccessContact{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"请授权通讯录权限"
                                          message:@"请在iPhone的\"设置-隐私-通讯录\"选项中,允许花解解访问你的通讯录"
                                          preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - ABNewPersonViewControllerDelegate

//- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(nullable ABRecordRef)person
//{
//    [newPersonView dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark - CNContactViewControllerDelegate

- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
