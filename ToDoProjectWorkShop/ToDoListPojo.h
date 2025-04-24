//
//  ToDoListPojo.h
//  ToDoProjectWorkShop
//
//  Created by Macos on 23/04/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToDoListPojo : NSObject<NSCoding,NSSecureCoding>


@property NSString *name, *dis ;
@property NSDate *endDate ;
@property int priority ,status ;
-(void) encodeWithCoder:(NSCoder *)coder;
-(id)initWithCoder:(NSCoder *)coder;
- (BOOL)isEqual:(id)object ;


//- (instancetype)initWithName:(NSString *)name priority:(NSString *)priority taskDescription:(NSString *)taskDescription state:(NSString *)state date:(NSDate *)date;


@end

NS_ASSUME_NONNULL_END
