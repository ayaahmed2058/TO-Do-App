//
//  ToDOViewController.h
//  ToDoProjectWorkShop
//
//  Created by Macos on 23/04/2025.
//

#import <UIKit/UIKit.h>
#import "ToDoListPojo.h"

NS_ASSUME_NONNULL_BEGIN

@interface ToDOViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property NSMutableArray<ToDoListPojo*> *highPriority;
@property NSMutableArray<ToDoListPojo*> *mediumPriority;
@property NSMutableArray<ToDoListPojo*> *lowPriority;
@property NSMutableArray<ToDoListPojo *> *allTasks;


@property NSMutableArray<ToDoListPojo*> *arr;
@property NSUserDefaults *defult;
@property ToDoListPojo *ref;
@property int proirity ;
@property NSMutableArray<ToDoListPojo *> *tempList;
@property NSMutableArray<ToDoListPojo *> *filtterList;


@end

NS_ASSUME_NONNULL_END
