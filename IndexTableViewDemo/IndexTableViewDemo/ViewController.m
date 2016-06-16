//
//  ViewController.m
//  IndexTableViewDemo
//
//  Created by Stronger_WM on 16/6/16.
//  Copyright © 2016年 Stronger_WM. All rights reserved.
//

#import "ViewController.h"
#import "DemoModel.h"
#import "IndexTableView.h"

@interface ViewController ()
@property (nonatomic ,strong) NSMutableArray *indexArr;
@property (nonatomic ,strong) NSMutableArray *detailArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //模拟网络请求数据
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
//    NSDictionary *dataDic = [NSDictionary dictionaryWithContentsOfFile:dataPath];
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:dataPath];
    
    //对请求的数据进行处理
    NSMutableArray *originalData = [NSMutableArray array];
    
    for (int i=0; i<dataArr.count; i++) {
        NSDictionary *dic = dataArr[i];
        DemoModel *model = [DemoModel new];
        model.is_selected = [[dic objectForKey:@"is_selected"] boolValue];
        model.province = [dic objectForKey:@"province"];
        model.city_name = [dic objectForKey:@"city"];
        if (i==0) {
            model.is_selected = YES;
        }
        [originalData addObject:model];
    }
    
    NSArray *keyArr = [self filteredCityArrSourceArr:originalData];//巴黎
    
    //创建二维数组
    for (int i=0; i<keyArr.count; i++) {
        NSString *currentKey = keyArr[i];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (DemoModel *model in originalData) {
            if ([model.province isEqualToString:currentKey]) {
                [tempArr addObject:model];
            }
        }
        [self.detailArr addObject:tempArr];
    }
    
    //合成indexArr,从二维数组中每组去一个model就ok了
    for (int i = 0; i<self.detailArr.count; i++) {
        [self.indexArr addObject:self.detailArr[i][0]];
    }
    
    //创建UI，并刷新数据
    CGRect frame = [UIScreen mainScreen].bounds;
    IndexTableView *tableView = [[IndexTableView alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, frame.size.height-20)];
    tableView.backgroundColor  = [UIColor redColor];
    [self.view addSubview:tableView];
    
    [tableView updateViewIndexArr:_indexArr detailArr:_detailArr];
}

//过滤数组中重复的元素，生成左边的索引数组
- (NSArray *)filteredCityArrSourceArr:(NSArray *)sourceArr
{
    NSMutableArray *resultArr = [NSMutableArray array];
    //找出原始城市数据
    NSMutableArray *originalCityArr = [NSMutableArray array];
    for (DemoModel *model in sourceArr) {
        [originalCityArr addObject:model.province];
    }
    
    //去掉重复的字符串元素
    for (NSString *str in originalCityArr) {
        if (![resultArr containsObject:str]) {
            [resultArr addObject:str];
        }
        else
        {
            continue;
        }
    }
    return resultArr;
}


- (NSMutableArray *)indexArr
{
    if (_indexArr == nil) {
        _indexArr = [NSMutableArray array];
    }
    return _indexArr;
}

- (NSMutableArray *)detailArr
{
    if (_detailArr == nil) {
        _detailArr = [NSMutableArray array];
    }
    return _detailArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
