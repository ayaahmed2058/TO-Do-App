//
//  DetailsViewController.h
//  ToDoProjectWorkShop
//
//  Created by Macos on 24/04/2025.
//

#import <UIKit/UIKit.h>
#import "ToDoListPojo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property ToDoListPojo *task;
@property NSString *mode;

@end

NS_ASSUME_NONNULL_END
