//
//  SharedUserDefaults.m
//  ToDoProjectWorkShop
//
//  Created by Macos on 23/04/2025.
//

#import "SharedUserDefaults.h"

@implementation SharedUserDefaults


+ (NSUserDefaults *)sharedUserDefaults {
    static NSUserDefaults *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [NSUserDefaults standardUserDefaults];
    });
    return sharedInstance;
}


@end
