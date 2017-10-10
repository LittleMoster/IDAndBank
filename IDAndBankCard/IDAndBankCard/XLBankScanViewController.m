//
//  XLBankScanViewController.m
//  IDAndBankCard
//
//  Created by mxl on 2017/3/28.
//  Copyright © 2017年 mxl. All rights reserved.
//

#import "XLBankScanViewController.h"
#import "OverlayView.h"
#import "AFNetworking.h"

@interface XLBankScanViewController ()

@property (nonatomic, strong) OverlayView *overlayView;

@end

@implementation XLBankScanViewController


- (OverlayView *)overlayView {
    if(!_overlayView) {
        CGRect rect = [OverlayView getOverlayFrame:[UIScreen mainScreen].bounds];
        _overlayView = [[OverlayView alloc] initWithFrame:rect];
    }
    return _overlayView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"银行卡扫描";
    
    [self.view insertSubview:self.overlayView atIndex:0];
    
    self.cameraManager.sessionPreset = AVCaptureSessionPreset1280x720;
    
    if ([self.cameraManager configBankScanManager]) {
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
    
    [self.cameraManager.bankScanSuccess subscribeNext:^(id x) {
        [self showResult:x];
    }];
    [self.cameraManager.scanError subscribeNext:^(id x) {
        
    }];
}

- (void)showResult:(id)result {
    XLScanResultModel *model = (XLScanResultModel *)result;
    //6221506020009066385
    NSString *url=[NSString stringWithFormat:@"https://ccdcapi.alipay.com/validateAndCacheCardInfo.json?_input_charset=utf-8&cardNo=%@&cardBinCheck=true",model.bankNumber];
    [[AFHTTPSessionManager manager]POST:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    
    NSString *message = [NSString stringWithFormat:@"%@\n%@", model.bankName, model.bankNumber];
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"扫描成功" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertV show];
}


@end
