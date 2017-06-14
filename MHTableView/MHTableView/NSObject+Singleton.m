//
//  NSObject+Singleton.m
//  MHTableView
//
//  Created by MH on 2017/5/20.
//  Copyright © 2017年 MH. All rights reserved.
//

#import "NSObject+Singleton.h"
// 使用可变数组可以储存每个类的单一实例，键为类名，值为该类的对象
// 声明为静态对象，可存储上次的值
static NSMutableDictionary * instanceDic;
id instance;
@implementation NSObject (Singleton)

+ (instancetype)sharedInstance{
    @synchronized (self) {
        // 初始化字典
        if (instanceDic == nil) {
            instanceDic = [[NSMutableDictionary alloc] init];
        }
        //获取类名
        NSString  * className = NSStringFromClass([self class]);
        if (className) {
            // 查找字典中该类的对象，使用类名去查找，可以确保一个类只被储存一次
            instance = instanceDic[className];
            if (instance == nil) {
                // 该类没有实例化，就进行初始化，并根据键值对存储
                instance = [[self.class alloc] init];
                [instanceDic setValue:instance forKey:className];
            }else{
                // 该类已存储在字典中，直接返回instance
            }
        }else{
            // 没有获取类名，说明sharedInstance是个类方法，用类进行调用
        }
    }
    return instance;
}

@end
