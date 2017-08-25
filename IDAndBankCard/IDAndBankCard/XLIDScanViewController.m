//
//  XLIDScanViewController.m
//  IDAndBankCard
//
//  Created by  on 2017/3/28.
//  Copyright © 2017年 mxl. All rights reserved.
//

#import "XLIDScanViewController.h"
#import "IDOverLayerView.h"

@interface XLIDScanViewController ()

@property (nonatomic, strong) IDOverLayerView *overlayView;

@end

@implementation XLIDScanViewController

-(IDOverLayerView *)overlayView {
    if(!_overlayView) {
        CGRect rect = [IDOverLayerView getOverlayFrame:[UIScreen mainScreen].bounds];
        _overlayView = [[IDOverLayerView alloc] initWithFrame:rect];
    }
    return _overlayView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"身份证扫描";
    
    [self.view insertSubview:self.overlayView atIndex:0];
    
    self.cameraManager.sessionPreset = AVCaptureSessionPresetHigh;
    
    if ([self.cameraManager configIDScanManager]) {
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        [self.view insertSubview:view atIndex:0];
        AVCaptureVideoPreviewLayer *preLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.cameraManager.captureSession];
        preLayer.frame = [UIScreen mainScreen].bounds;
        
        preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [view.layer addSublayer:preLayer];
        
        [self.cameraManager startSession];
    }
    else {
        NSLog(@"打开相机失败");
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self.cameraManager.idCardScanSuccess subscribeNext:^(id x) {
        [self showResult:x];
    }];
    [self.cameraManager.scanError subscribeNext:^(id x) {
        
    }];
}

- (void)showResult:(id)result {
    XLScanResultModel *model = (XLScanResultModel *)result;
    UIImage *image=model.idImage;
   
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    
    image=[self getHeaderImage:image];
  
    imageview.image=image;
    [self.view addSubview:imageview];
    
//    NSString *message = [NSString stringWithFormat:@"%@", [model toString]];
//    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"扫描成功" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    [alertV show];
}
- (UIImage *)imageRotatedByRadians:(CGFloat)radians image:(UIImage*)image
{
    // 定义一个执行旋转的CGAffineTransform结构体
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    // 对图片的原始区域执行旋转，获取旋转后的区域
    CGRect rotatedRect = CGRectApplyAffineTransform(
                                                    CGRectMake(0.0 , 0.0, image.size.width, image.size.height) , t);
    // 获取图片旋转后的大小
    CGSize rotatedSize = rotatedRect.size;
    // 创建绘制位图的上下文
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 指定坐标变换，将坐标中心平移到图片的中心
    CGContextTranslateCTM(ctx, rotatedSize.width/2, rotatedSize.height/2);
    // 执行坐标变换，旋转过radians弧度
    CGContextRotateCTM(ctx , radians);
    // 执行坐标变换，执行缩放
    CGContextScaleCTM(ctx, 1.0, -1.0);
    // 绘制图片
    CGContextDrawImage(ctx, CGRectMake(-image.size.width / 2
                                       , -image.size.height / 2,
                                       image.size.width,
                                       image.size.height), image.CGImage);
    // 获取绘制后生成的新图片
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 返回新图片
    
    return newImage;
}

-(UIImage*)getHeaderImage:(UIImage*)image
{
 
    
    image= [self imageRotatedByRadians:90.0* M_PI / 180 image:image];
    CGRect rect= CGRectMake(image.size.width*1/4,image.size.height*3/5+5, image.size.width*3/5+15, image.size.height*2/5-30);//创建矩形框
 image= [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], rect)];

    return [self imageRotatedByRadians:-90.0* M_PI / 180 image:image];
}


@end
