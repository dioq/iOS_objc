//
//  ScreenshotViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/8/19.
//  Copyright © 2022 my. All rights reserved.
//

#import "ScreenshotViewController.h"

@interface ScreenshotViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgv;
@property (weak, nonatomic) IBOutlet UIImageView *targetIMGV;

@end

@implementation ScreenshotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)shot:(UIButton *)sender {
    UIImage *img = [self screenShotView:self.imgv];
    [self.targetIMGV setImage:img];
    
    // 图片保存到相册
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

//传入需要截取的view
-(UIImage *)screenShotView:(UIView *)view{
    UIImage *imageRet = [[UIImage alloc]init];
    UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageRet;
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(error){
        NSLog(@"%@",[error localizedDescription]);
    }else {
        NSLog(@"图片保存成功!");
    }
}

@end
