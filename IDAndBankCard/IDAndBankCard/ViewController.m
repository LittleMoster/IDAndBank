//
//  ViewController.m
//  IDAndBankCard
//
//  Created by mxl on 2017/3/28.
//  Copyright © 2017年 mxl. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    [self getBank:@"6221506020009066385"];
    [self getBankImage:@"CCB"];
    self.view.backgroundColor=[UIColor whiteColor];
    
}

-(void)getBank:(NSString *)bankNumber
{
    NSString *url=[NSString stringWithFormat:@"https://ccdcapi.alipay.com/validateAndCacheCardInfo.json?_input_charset=utf-8&cardNo=%@&cardBinCheck=true",bankNumber];
    [[AFHTTPSessionManager manager]POST:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

-(void)getBankImage:(NSString *)bank
{
//    https://apimg.alipay.com/combo.png?d=cashier&t=CCB
    NSString *url=[NSString stringWithFormat:@"https://apimg.alipay.com/combo.png?d=cashier&t=%@",bank];
    
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:NSDataReadingMappedIfSafe error:nil];
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(50, 80, 126, 36)];
    UIImage *image=[UIImage imageWithData:data];
    imageview.image=image;
    [self.view addSubview:imageview];
    
   

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
