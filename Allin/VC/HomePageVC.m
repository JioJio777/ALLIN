//
//  ViewController.m
//  Allin
//
//  Created by 郑子炯 on 2023/1/29.
//

#import "HomePageVC.h"
#import "demoCell.h"

@interface HomePageVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)NSMutableArray* arrayPrice;
//@property(nonatomic,strong)NSTimer *timer;
@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self pollingWithDuration:0.3 handle:^{
        [self requestPriceWithCoinName:@"BNB"];
        [self requestPriceWithCoinName:@"BTC"];
        [self requestPriceWithCoinName:@"ETH"];
        [self requestPriceWithCoinName:@"APT"];
        [self requestPriceWithCoinName:@"CFX"];

    }];
    

}
-(void)setUpUI{
    self.tableview = [[UITableView alloc]init];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.frame =  CGRectMake(0, 0, 400, 1000);
    self.tableview.backgroundColor  = [UIColor blackColor];
    self.arrayPrice = [[NSMutableArray alloc]initWithArray:@[@"老板发财",@"老板发财",@"老板发财",@"老板发财",@"老板发财"]];
    [self.view addSubview:self.tableview];
//    self.label = [[UILabel alloc]init];
//    self.label.text = @"0";
//    //self.label.font = UIFont
//    self.label.textColor = [UIColor greenColor];
//    self.label.frame = CGRectMake(0, 0, 40, 40);
//    [self.tableview.tableHeaderView addSubview:self.label];
    //[self.view addSubview:self.label];
}

//轮询请求
-(void)pollingWithDuration:(NSInteger)second handle:(void(^)(void))pollingOperation{
    //https://juejin.cn/post/7051428160130252836
//    self.timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(requestBTCPrice) userInfo:nil repeats:YES];
//    [self.timer fire];
    //https://www.jianshu.com/p/3e26887185a8
    static dispatch_source_t _timer;
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0); //每秒执行

    dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                //需要轮询的内容
                pollingOperation();
            });
    });

    // 开启定时器
    dispatch_resume(_timer);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 轮询超时
            dispatch_cancel(_timer);
    });
}
//请求价格
-(NSString *)requestPriceWithCoinName:(NSString *)coinName{
    NSString *priceString = @"";
    //https://juejin.cn/post/6847902224501194765 nice!!!
    //https://juejin.cn/post/6844903968120766477
    //    1. 创建一个url
    NSURL *url= [NSURL URLWithString: [NSString stringWithFormat:@"https://api.binance.com/api/v3/ticker/price?symbol=%@USDT", coinName]];
    //    2. 创建一个网络请求，网络请求不指定方法默认是GET
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    //    request.HTTPMethod = @"GET";


    //    自定义请求配置
    //    NSURLSessionConfiguration *config = [[NSURLSessionConfiguration alloc] init];
    //    config.timeoutIntervalForRequest= 20;// 请求超超时时间
    //    //...还有很多参数
    //    NSURLSession *session = [NSURLSession sessionWithConfiguration: config];
    //    3. 创建网络管理
    NSURLSession *session = [NSURLSession sharedSession];

    //    4. 创建一个网络任务
    /*
        第一个参数 : 请求对象
        第二个参数 :
            completionHandler回调 ( 请求完成 ["成功"or"失败"] 的回调 )
            data : 响应体信息(期望的数据)
            response : 响应头信息,主要是对服务器端的描述
            error : 错误信息 , 如果请求失败 , 则error有值
    */
    NSURLSessionDataTask *task= [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // data就是服务器返回的数据,response为服务器的响应
        if(!error){
            // 强转为NSHTTPURLResponse

            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            if(res.statusCode == 200){
               // 更新UI必须回到主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                     //self.imgView.image = [UIImage imageWithData:data];
                    //NSLog(data);
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
                    if(dic){
                        NSString *priceString = [NSString stringWithFormat:@"%.4f",[(NSString *)dic[@"price"] floatValue]];
                        priceString = [NSString stringWithFormat:@"%@ : %@",coinName,priceString];
                        NSLog(priceString);
                        if(coinName == @"BTC"){
                            self.arrayPrice[0] = priceString;
                        }
                        else if(coinName == @"ETH"){
                            self.arrayPrice[1] = priceString;
                        }
                        else if(coinName == @"BNB"){
                            self.arrayPrice[2] = priceString;
                        }
                        else if(coinName == @"APT"){
                            self.arrayPrice[3] = priceString;
                        }
                        else if(coinName == @"CFX"){
                            self.arrayPrice[4] = priceString;
                        }
                    }
                    [self.tableview reloadData];
                });
            }

        }else{
            NSLog(@"报错啦,%@",error);
        }
    }];
    //    5. 开启任务
    [task resume];
    return priceString;
}
#pragma <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    demoCell *cell = [[demoCell alloc]init];
    cell.textLabel.text = self.arrayPrice[indexPath.row];
    return  cell;
}



@end
