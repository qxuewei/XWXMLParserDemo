//
//  Model.h
//  多线程-XML格式文件解析
//
//  Created by 邱学伟 on 16/8/29.
//  Copyright © 2016年 邱学伟. All rights reserved.
//  模型

#import <Foundation/Foundation.h>

@interface Model : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *url;
@end
