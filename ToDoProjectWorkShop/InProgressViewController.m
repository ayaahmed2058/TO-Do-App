//
//  InProgressViewController.m
//  ToDoProjectWorkShop
//
//  Created by Macos on 23/04/2025.
//

#import "InProgressViewController.h"
#import "ToDoListPojo.h"

@interface InProgressViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (weak, nonatomic) IBOutlet UIButton *sortBtn;

@property (strong, nonatomic) NSMutableArray<ToDoListPojo *> *inProgressTasks;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property NSMutableArray<ToDoListPojo*> *highPriority;
@property NSMutableArray<ToDoListPojo*> *mediumPriority;
@property NSMutableArray<ToDoListPojo*> *lowPriority;
@property BOOL isTAskSorted;

@end

#import "InProgressViewController.h"
#import "DetailsViewController.h"

@implementation InProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.searchBar.delegate = self;
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    _isTAskSorted = NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(loadTasks)
                                               name:@"TaskUpdatedNotification"
                                             object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _highPriority = [NSMutableArray new];
    _mediumPriority = [NSMutableArray new];
    _lowPriority = [NSMutableArray new];
    [self loadTasks];
    
}


- (void)loadTasks {
    self.inProgressTasks = [NSMutableArray new];
    _highPriority = [NSMutableArray new];
    _mediumPriority = [NSMutableArray new];
    _lowPriority = [NSMutableArray new];
    
    NSData *savedData = [self.defaults objectForKey:@"tasks"];
    
    if (savedData) {
        NSError *error;
        NSSet *classes = [NSSet setWithObjects:[NSMutableArray class], [ToDoListPojo class], nil];
        NSArray *allTasks = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:savedData error:&error];
        
        
//self.inProgressTasks = [NSMutableArray arrayWithArray:allTasks];
        
        if (!error && allTasks) {
            for (ToDoListPojo *task in allTasks) {
                if (task.status == 1) {
                    [self.inProgressTasks addObject:task];
                    
                    if (task.priority == 2) {
                        [_highPriority addObject:task];
                    } else if (task.priority == 1) {
                        [_mediumPriority addObject:task];
                    } else {
                        [_lowPriority addObject:task];
                    }
                }
            }
        }
    }

    [self.myTable reloadData];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(_isTAskSorted){
        
        return 3;
        
    }else {
        
        return 1;
    }

    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(_isTAskSorted){
        
        switch(section){
            case 0:
                return _lowPriority.count;
                break;
            case 1:
                return _mediumPriority.count;
                break;
            default:
                return _highPriority.count;
                break;
        }
    }else{
            
            return _inProgressTasks.count;
    }
        
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.inProgressTasks.count;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    ToDoListPojo *task;

    if(_isTAskSorted){
        
        switch (indexPath.section) {
            case 0:
                task = _lowPriority[indexPath.row];
                break;
            case 1:
                task = _mediumPriority[indexPath.row];
                break;
            case 2:
                task = _highPriority[indexPath.row];
                break;
        }
        
    }else{
        
        task = _inProgressTasks[indexPath.row];
    }
   

    cell.textLabel.text = task.name;
    
    if (task.priority == 2) {
        cell.imageView.image = [UIImage imageNamed:@"high.png"];
    } else if (task.priority == 1) {
        cell.imageView.image = [UIImage imageNamed:@"medium.png"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"low.png"];
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!_isTAskSorted) {
        return nil;
    }

    switch (section) {
        case 0: return @"Low Priority";
        case 1: return @"Medium Priority";
        case 2: return @"High Priority";
        default: return @"";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ToDoListPojo *selectedTask;
        
        switch (indexPath.section) {
            case 0:
                selectedTask = _lowPriority[indexPath.row];
                break;
            case 1:
                selectedTask = _mediumPriority[indexPath.row];
                break;
            case 2:
                selectedTask = _highPriority[indexPath.row];
                break;
            default:
                return;
        }
    
    DetailsViewController *SVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsScreen"];
    SVC.task = selectedTask;
    SVC.mode = @"inProgress";
    [self.navigationController pushViewController:SVC animated:YES];

}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        ToDoListPojo *taskToDelete;

        
        if (_isTAskSorted) {
            switch (indexPath.section) {
                case 2:
                    taskToDelete = _highPriority[indexPath.row];
                    [_highPriority removeObjectAtIndex:indexPath.row];
                    break;
                case 1:
                    taskToDelete = _mediumPriority[indexPath.row];
                    [_mediumPriority removeObjectAtIndex:indexPath.row];
                    break;
                case 0:
                    taskToDelete = _lowPriority[indexPath.row];
                    [_lowPriority removeObjectAtIndex:indexPath.row];
                    break;
            }
        } else {
            taskToDelete = _inProgressTasks[indexPath.row];
        }

        
        [self.inProgressTasks removeObject:taskToDelete];

        
        NSData *savedData = [self.defaults objectForKey:@"tasks"];
        if (savedData) {
            NSError *error;
            NSSet *classes = [NSSet setWithObjects:[NSMutableArray class], [ToDoListPojo class], nil];
            NSMutableArray *allTasks = [[NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:savedData error:&error] mutableCopy];

            if (!error && allTasks) {
                [allTasks removeObject:taskToDelete];
                NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:allTasks requiringSecureCoding:YES error:&error];
                if (!error) {
                    [self.defaults setObject:archiveData forKey:@"tasks"];
                    [self.defaults synchronize];
                }
            }
        }

        
        if (_isTAskSorted) {
            [tableView reloadData];
        } else {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterDataWithSearchText:searchText];
    [self.myTable reloadData];
}


- (void)filterDataWithSearchText:(NSString *)searchText {
    self.highPriority = [NSMutableArray new];
    self.mediumPriority = [NSMutableArray new];
    self.lowPriority = [NSMutableArray new];

    for (ToDoListPojo *task in self.inProgressTasks) {
        if (task.status != 1) continue;

        if (searchText.length > 0 &&
            ![task.name.lowercaseString containsString:searchText.lowercaseString]) {
            continue;
        }

        
        switch (task.priority) {
            case 2:
                [self.highPriority addObject:task];
                break;
            case 1:
                [self.mediumPriority addObject:task];
                break;
            case 0:
                [self.lowPriority addObject:task];
                break;
        }
    }
    
    [self.myTable reloadData];
}

- (IBAction)sortTasks:(id)sender {
    
    _isTAskSorted = !_isTAskSorted;

     if (_isTAskSorted) {
         _highPriority  = [NSMutableArray new];
         _mediumPriority = [NSMutableArray new];
         _lowPriority = [NSMutableArray new];

         for (ToDoListPojo *task in _inProgressTasks) {
             if (task.priority == 2) {
                 [_highPriority addObject:task];
             } else if (task.priority == 1) {
                 [_mediumPriority addObject:task];
             } else {
                 [_lowPriority addObject:task];
             }
         }

         [self.sortBtn setTitle:@"All" forState:UIControlStateNormal];
     } else {
         [self.sortBtn setTitle:@"Sort" forState:UIControlStateNormal]; 
     }

     [_myTable reloadData];
}

@end
