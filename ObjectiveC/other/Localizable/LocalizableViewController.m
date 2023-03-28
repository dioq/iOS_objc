//
//  LocalizableViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/3/31.
//  Copyright © 2019 William. All rights reserved.
//

#import "LocalizableViewController.h"

@interface LocalizableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *myImaeV;
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property (weak, nonatomic) IBOutlet UILabel *myLabel2;

@end

@implementation LocalizableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"本地化";
    NSString *imageName = [[NSBundle mainBundle] localizedStringForKey:@"mainImage" value:@"" table:nil];
    self.myImaeV.image = [UIImage imageNamed:imageName];
    
    NSString *text =  [[NSBundle mainBundle] localizedStringForKey:@"mainText" value:@"" table:nil];
    self.myLabel.text = text;
    
    NSString *text2 = NSLocalizedString(@"mainText", @"description for this key.");
    self.myLabel2.text = text2;
}

@end
