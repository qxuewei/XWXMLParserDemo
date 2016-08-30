//
//  Model.m
//  多线程-XML格式文件解析
//
//  Created by 邱学伟 on 16/8/29.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "Model.h"
#import "MJExtension.h"
@implementation Model

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    //前者模型中key,后者网络数据中key
    return @{
             @"ID":@"id"
             };
}

@end
