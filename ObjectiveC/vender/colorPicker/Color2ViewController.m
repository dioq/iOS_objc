//
//  Color2ViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/3/3.
//  Copyright © 2019 William. All rights reserved.
//

#import "Color2ViewController.h"
#import "KKColorListPicker.h"

@interface Color2ViewController () <KKColorListViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *showColorView;

@end

@implementation Color2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (IBAction)presentAction:(UIButton *)sender {
    KKColorListViewController *controller = [[KKColorListViewController alloc] initWithSchemeType:KKColorsSchemeTypeCrayola];
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)pushAction:(UIButton *)sender {
    KKColorListViewController *controller = [[KKColorListViewController alloc] initWithSchemeType:KKColorsSchemeTypeCrayola];
    controller.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)colorListController:(KKColorListViewController *)controller didSelectColor:(KKColor *)color
{
    self.showColorView.backgroundColor = [color uiColor];
    self.showColorView.hidden = NO;
}

- (void)colorListPickerDidComplete:(KKColorListViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
