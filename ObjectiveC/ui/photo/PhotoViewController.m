//
//  PickimageViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/4/17.
//  Copyright © 2019 William. All rights reserved.
//

#import "PhotoViewController.h"
#import <Photos/Photos.h>

@interface PhotoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *showImageV;
@property (weak, nonatomic) IBOutlet UISwitch *isEdit;
@property(nonatomic, strong)UIImagePickerController *imagePickerG;

@end

@implementation PhotoViewController

//检测前置摄像头是否可用
- (BOOL)isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}
//检测后置摄像头是否可用
- (BOOL)isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self isFrontCameraAvailable]) {
        NSLog(@"检测前置摄像头 可用");
    }else {
        NSLog(@"检测前置摄像头 不可用");
    }
    if ([self isRearCameraAvailable]) {
        NSLog(@"检测后置摄像头 可用");
    }else{
        NSLog(@"检测后置摄像头 不可用");
    }
}

- (IBAction)cameraAction:(UIButton *)sender {
    [self persentImagePicker];
}

- (IBAction)albumAction:(UIButton *)sender {
    [self persentImageAlbumPicker];
}

///调用相机
- (void)persentImagePicker{
    if (!_imagePickerG) {
        ///初始化
        _imagePickerG = [[UIImagePickerController alloc]init];
        ///代理
        _imagePickerG.delegate = self;
    }
    
    // 前面的摄像头是否可用
    if ([self isFrontCameraAvailable]) {
        _imagePickerG.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    // 后面的摄像头是否可用
    else if ([self isRearCameraAvailable]){
        _imagePickerG.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        NSLog(@"没有相机可用");
        return;
    }
    [_imagePickerG setAllowsEditing:self.isEdit.isOn]; // 允许拍照后裁剪
    [self presentViewController:_imagePickerG animated:YES completion:nil];
}

///调用本地相册
- (void)persentImageAlbumPicker{
    if (!_imagePickerG) {
        ///初始化
        _imagePickerG = [[UIImagePickerController alloc]init];
        ///代理
        _imagePickerG.delegate = self;
    }
    ///相册
    _imagePickerG.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [_imagePickerG setAllowsEditing:self.isEdit.isOn]; //是否允许编辑
    [self presentViewController:_imagePickerG animated:YES completion:nil];
}

///取消选择图片（拍照）
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

///选择图片完成（从相册或者拍照完成）
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if (self.isEdit.isOn) {
        UIImage *imageUp = [info objectForKey:UIImagePickerControllerEditedImage];//编辑后的图片
        self.showImageV.image = imageUp; //获取修剪后的图片
    }else{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];//原图
        self.showImageV.image = image; //获取原图
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveImageToPhoto:(UIButton *)sender {
    UIImage *img = self.showImageV.image;
    if(img) {
        // 图片保存到相册
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(error){
        NSLog(@"%@",[error localizedDescription]);
    }else {
        NSLog(@"图片保存成功!");
    }
}

- (IBAction)deleteAction:(id)sender {
    PHFetchResult *collectonResuts = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:[PHFetchOptions new]] ;
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        NSLog(@"%@",assetCollection.localizedTitle);
        if ([assetCollection.localizedTitle isEqualToString:@"最近项目"]) {
            PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[PHFetchOptions new]];
            [assetResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{ //获取相册的最后一张照片
                if (idx == [assetResult count] - 1) {
                    [PHAssetChangeRequest deleteAssets:@[obj]]; } } completionHandler:^(BOOL success, NSError *error) {
                        if(error) {
                            NSLog(@"Error: %@", error);
                        }else {
                            NSLog(@"success");
                        }
                    }];
            }];
        }
    }];
}

@end
