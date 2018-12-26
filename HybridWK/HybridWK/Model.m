//
//  Model.m
//  HybridWK
//
//  Created by whqfor on 2018/12/6.
//  Copyright © 2018年 whqfor. All rights reserved.
//

#import "Model.h"

@interface Model () <NSCoding>

@end

@implementation Model

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_dict forKey:@"dict"];
    [aCoder encodeObject:_arr forKey:@"arr"];
    [aCoder encodeObject:_date forKey:@"date"];
    [aCoder encodeInt:(int)_age forKey:@"age"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _dict = [aDecoder decodeObjectForKey:@"dict"];
        _arr = [aDecoder decodeObjectForKey:@"arr"];
        _date = [aDecoder decodeObjectForKey:@"date"];
        _age = [aDecoder decodeIntegerForKey:@"age"];
    }
    return self;
}

@end
