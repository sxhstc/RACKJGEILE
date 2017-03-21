//
//  ViewController.m
//  RACKJ
//
//  Created by hua on 2016/12/27.
//  Copyright © 2016年 hua. All rights reserved.
//

#import "ViewController.h"
#import "CircleListVC.h"
#import "UserModel.h"
#import "XHNetworking.h"

@interface ViewController ()

@property (nonatomic, strong) NSOperationQueue *opQueue;
@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake(40, 80, 100, 40);
    [btn setTitle:@"测试" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *nextbtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextbtn.frame=CGRectMake(230, 80, 100, 40);
    [nextbtn setTitle:@"下一页" forState:UIControlStateNormal];
    [nextbtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextbtn];
    
    
    
//    AFHTTPSessionManager*session = [AFHTTPSessionManager manager];
//    session.responseSerializer = [AFJSONResponseSerializer serializer];
//    session.requestSerializer = [AFJSONRequestSerializer serializer];
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    securityPolicy.allowInvalidCertificates = NO;//是否允许使用自签名证书
//    securityPolicy.validatesDomainName = YES;//是否需要验证域名，默认YES
//    session.securityPolicy=securityPolicy;
//    NSURLSessionDataTask *task=[session GET:@"https://test.365gl.com:7443/test/getuserpage?curpage=3" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"这里打印请求成功要做的事%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
//        NSLog(@"%@",error);  //这里打印错误信息
//    }];
//    
//    _opQueue = [[NSOperationQueue alloc] init];
//    _op=[[FailureTaskOperation alloc] init];
//    _op.task=task;
//    _task=task;
    
    
}

-(void)click{
    
    NSLog(@"测试按钮点击");
    
//    [_task resume];
//    [_opQueue addOperation:_op];
    
    
    
//    NSString *url=@"https://114.119.8.68:7443/test/getuserpage?curpage=";
//    for (int i=1; i<=5; i++) {
//        NSString *testUrl=[NSString stringWithFormat:@"%@%d",url,i];
//        [XHNetworking getWithUrl:testUrl params:nil success:^(NSURLSessionDataTask *task, id responseObject, BOOL fromCache) {
//        } fail:^(NSURLSessionDataTask *task, NSError *error, BOOL fromCache) {
//        }];
//    }
    
    
//    AFHTTPSessionManager*session = [AFHTTPSessionManager manager];
//    session.responseSerializer = [AFJSONResponseSerializer serializer];
//    session.requestSerializer = [AFJSONRequestSerializer serializer];
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    securityPolicy.allowInvalidCertificates = NO;//是否允许使用自签名证书
//    securityPolicy.validatesDomainName = YES;//是否需要验证域名，默认YES
//    session.securityPolicy=securityPolicy;
//    [session GET:@"https://test.365gl.com:7443/test/getuserpage?curpage=3" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"这里打印请求成功要做的事%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
//        NSLog(@"%@",error);  //这里打印错误信息
//    }];
//    
//    NSDictionary *dic=@{@"curpage": @1};
//    [session POST:@"https://114.119.8.68:7774/test/getuserpage" parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"这里打印请求成功要做的事%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);  //这里打印错误信息
//    }];
    

    
    /*
    UserModel *user1=[[UserModel alloc] init];
    user1.userId=1;
    user1.name=@"小明";
    user1.age=18;
    user1.icon=@"小明图片";
    //保存user1
    [user1 saveToDB];
    
    UserModel *user2=[[UserModel alloc] init];
    user2.userId=2;
    user2.name=@"小玲";
    user2.age=20;
    user2.icon=@"小玲图片";
    //保存user2
    [user2 saveToDB];
    
    //有多少行
    NSInteger row=[UserModel rowCountWithWhere:nil];
    DLog(@"rowCount:%ld",row);
    
    //查询
    NSMutableArray* array = [UserModel searchWithWhere:nil orderBy:nil offset:0 count:100];
    for (id obj in array) {
        [obj printAllPropertys];
    }
    
    //table中是否存在 根据主键判断是否存在
    BOOL exist=[UserModel isExistsWithModel:user1];
    DLog(@"exist:%d",exist);
    
    //更新
    user1.name = @"李浩";
    [UserModel updateToDB:user1 where:nil];
    
    //删除
    [UserModel deleteToDB:user1];
    */
    
    
    //获取沙盒根目录
    NSString *directory = NSHomeDirectory();
    NSLog(@"directory:%@", directory);
    
    
}

-(void)next{
//    NSLog(@"下一页");
    CircleListVC *vc=[[CircleListVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
