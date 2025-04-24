//
//  ToDoListPojo.m
//  ToDoProjectWorkShop
//
//  Created by Macos on 23/04/2025.
//

#import "ToDoListPojo.h"

@implementation ToDoListPojo

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_dis forKey:@"dis"];
    [coder encodeInt:_priority  forKey:@"priority"];
    [coder encodeInt:_status forKey:@"status"];
    [coder encodeObject:_endDate forKey:@"endDate"];


}

- (id)initWithCoder:(nonnull NSCoder *)decoder {
    if((self = [super init])){
        _name=[decoder decodeObjectOfClass:[NSString class] forKey:@"name" ];
        _dis=[decoder decodeObjectOfClass:[NSString class] forKey:@"dis" ];
        _priority=[decoder decodeIntForKey:@"priority" ];
        _status=[decoder decodeIntForKey:@"status" ];
        _endDate=[decoder decodeObjectOfClass:[NSDate class] forKey:@"endDate" ];
    }
    return  self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[ToDoListPojo class]]) return NO;
    ToDoListPojo *other = (ToDoListPojo *)object;
    return [self.name isEqualToString:other.name];
}

- (NSUInteger)hash {
    return self.name.hash;
}


//- (instancetype)initWithName:(NSString *)name priority:(NSString *)priority taskDescription:(NSString *)taskDescription state:(NSString *)state date:(NSDate *)date {
//    self = [super init];
//    if (self) {
//        _taskName = name;
//        _state =state ;
//        _taskDescription=taskDescription;
//        _priority=priority;
//        _taskDate=date;
//    }
//    return self;
//}
@end



