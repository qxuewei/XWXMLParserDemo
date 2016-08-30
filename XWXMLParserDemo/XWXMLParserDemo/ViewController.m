//
//  ViewController.m
//  多线程-XML格式文件解析
//
//  Created by 邱学伟 on 16/8/29.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "ViewController.h"
#import "MJExtension.h"
#import "Model.h"

#import "GDataXMLNode.h"

@interface ViewController ()<NSXMLParserDelegate>
@property (nonatomic,strong) NSMutableArray *dataArrM;
@end

@implementation ViewController
-(NSMutableArray *)dataArrM{
    if (!_dataArrM) {
        _dataArrM = [NSMutableArray array];
    }
    return _dataArrM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self requestData];
}
//请求网络数据
-(void)requestData{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://120.25.226.186:32812/video?type=XML"]];
    request.timeoutInterval = 2.0f;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"data:%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        [self XMLGDataXMLNodeWithData:data];
    }];
    [task resume];
}

//*利用 NSXMLParser 方式
-(void)XMLParserWithData:(NSData *)data{
    //1.创建NSXMLParser
    NSXMLParser *XMLParser = [[NSXMLParser alloc] initWithData:data];
    //2.设置代理
    [XMLParser setDelegate:self];
    //3.开始解析
    [XMLParser parse];
}

//*利用 GDataXMLNode 方式
-(void)XMLGDataXMLNodeWithData:(NSData *)data{
    //1.加载XML数据
    GDataXMLDocument *XMLDocument = [[GDataXMLDocument alloc] initWithData:data error:nil];
    //2.拿到XML文件中根元素下需要解析的子元素数组
    NSArray *elements = [XMLDocument.rootElement elementsForName:@"video"];
    //3.对子元素数组中所有数据进行解析
    [elements enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GDataXMLElement *XMLElement = (GDataXMLElement *)obj;
        NSLog(@"XMLElement:%@",XMLElement);
        //打印发现 GDataXMLElement 对象是对每条数据进行了一层封装,可将其转化为字典进行字典模型转换
        Model *model = [[Model alloc] init];
        model.ID = [XMLElement attributeForName:@"id"].stringValue;
        model.name = [XMLElement attributeForName:@"name"].stringValue;
        model.image = [XMLElement attributeForName:@"image"].stringValue;
        model.url = [XMLElement attributeForName:@"url"].stringValue;
        [self.dataArrM addObject:model];
    }];
    NSLog(@"XML所有元素解析完毕:%@",self.dataArrM);
}

#pragma mark - NSXMLParserDelegate
//1.开始解析XML文件
-(void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"开始解析XML文件");
}
//2.解析XML文件中所有的元素
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    NSLog(@"解析XML文件中所有的元素:elementName:%@,attributeDict:%@",elementName,attributeDict);
    if ([elementName isEqualToString:@"video"]) {
        //MJExtension 解析数据
        Model *model = [Model mj_objectWithKeyValues:attributeDict];
        [self.dataArrM addObject:model];
    }
}
//3.XML文件中每一个元素解析完成
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    NSLog(@"XML文件中每一个元素解析完成:elementName:%@,qName:%@",elementName,qName);
}
//4.XML所有元素解析完毕
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"XML所有元素解析完毕:%@",self.dataArrM);
}
@end
