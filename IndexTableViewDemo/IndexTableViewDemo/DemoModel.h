//
//  DemoModel.h
//  IndexTableViewDemo
//
//  Created by Stronger_WM on 16/6/16.
//  Copyright © 2016年 Stronger_WM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemoModel : NSObject

@property (nonatomic ,copy) NSString *province;     //省份
@property (nonatomic ,copy) NSString *city_name;    //市的名字
@property (nonatomic ,assign) BOOL is_selected;     //是否选中

@end
