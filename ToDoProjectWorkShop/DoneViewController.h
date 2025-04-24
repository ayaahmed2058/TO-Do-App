//
//  DoneViewController.h
//  ToDoProjectWorkShop
//
//  Created by Macos on 23/04/2025.
//

#import <UIKit/UIKit.h>
#import "ToDoListPojo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DoneViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property NSMutableArray<ToDoListPojo *> *tempList;
@property NSMutableArray<ToDoListPojo *> *filtterList;

@end

NS_ASSUME_NONNULL_END
