//
//  ViewController.m
//  EMHTTPClientWorkSpace
//
//  Created by 郭家正 on 16/12/19.
//  Copyright © 2016年 郭家正. All rights reserved.
//

#import "ViewController.h"
#import "EMHTTPClient.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [EMHTTPClient asyncRawDataGet:@"http://www.baidu.com"
                        paramters:nil
                          timeout:10
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              NSString *string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                              //下载来下
                              
                              [self.webView loadHTMLString:string baseURL:nil];
                              //更新webView
                          } faild:^(AFHTTPRequestOperation *operation, NSError *error) {
                              
                          }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
