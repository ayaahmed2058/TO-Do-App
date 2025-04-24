//
//  ToDOViewController.m
//  ToDoProjectWorkShop
//
//  Created by Macos on 23/04/2025.
//

#import "ToDOViewController.h"
#import "AddTaskViewController.h"
#import "ToDoListPojo.h"
#import "ToDoTableViewCell.h"
#import "DetailsViewController.h"

@interface ToDOViewController ()


@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (strong, nonatomic) NSMutableArray<ToDoListPojo *> *todoTasks;



@end

@implementation ToDOViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    _highPriority = [NSMutableArray new];
    _mediumPriority = [NSMutableArray new];
    _lowPriority = [NSMutableArray new];
    _allTasks = [NSMutableArray new];

    _defult = [NSUserDefaults standardUserDefaults];

    NSData *savedData = [_defult objectForKey:@"tasks"];

    if (savedData != nil) {
        NSError *error;
        NSSet *classes = [NSSet setWithObjects:[NSMutableArray class], [ToDoListPojo class], nil];

        _arr = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:savedData error:&error];

        self.allTasks = [NSMutableArray arrayWithArray:_arr];

        for (ToDoListPojo *task in _arr) {
            if (task.status != 0) continue;

            if (task.priority == 2) {
                [_highPriority addObject:task];
            } else if (task.priority == 1) {
                [_mediumPriority addObject:task];
            } else {
                [_lowPriority addObject:task];
            }
        }
    }

    [_myTable reloadData];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myTable.delegate=self;
    _myTable.dataSource=self;
    _searchBar.delegate = self;
    _defult=[NSUserDefaults standardUserDefaults];
    
    NSData *savedData = [_defult objectForKey:@"tasks"];
    
    if (savedData != nil) {
        NSError *error;
        NSSet *classes = [NSSet setWithObjects:[NSMutableArray class], [ToDoListPojo class], nil];
        
        _arr = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:savedData error:&error];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewWillAppear:)
                                                 name:@"TaskUpdatedNotification"
                                               object:nil];

   
    
    
    [_myTable reloadData];
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 2) return @"High Priority";
    if (section == 1) return @"Medium Priority";
    return @"Low Priority";
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

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
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    _proirity=_ref.priority ;
//
//    switch (indexPath.section) {
//        case 0:
//            _ref=_lowPriority[indexPath.row];
//            cell.textLabel.text = _ref.name;
//
//            break;
//        case 1:
//            _ref=_mediumPriority[indexPath.row];
//            cell.textLabel.text = _ref.name;
//            break;
//            
//        default:
//            _ref=_highPriority[indexPath.row];
//            cell.textLabel.text = _ref.name;
//
//            break;
//    }
//   
//
//    return cell;
//}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        ToDoListPojo *taskToDelete;
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
        
        
        NSData *savedData = [_defult objectForKey:@"tasks"];
        NSMutableArray *existingTasks = [NSMutableArray new];
        if (savedData) {
            NSError *error;
            NSSet *classes = [NSSet setWithObjects:[NSMutableArray class], [ToDoListPojo class], nil];
            existingTasks = [[NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:savedData error:&error] mutableCopy];
        }

        
        [existingTasks removeObject:taskToDelete];

        
        NSError *archiveError;
        NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:existingTasks requiringSecureCoding:YES error:&archiveError];
        if (!archiveError) {
            [_defult setObject:archiveData forKey:@"tasks"];
            [_defult synchronize];
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
        SVC.task=selectedTask;
        [self.navigationController pushViewController:SVC animated:YES];



}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ToDoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    ToDoListPojo *task;
    switch (indexPath.section) {
        case 0:
            task = _lowPriority[indexPath.row];
            break;
        case 1:
            task = _mediumPriority[indexPath.row];
            break;
        default:
            task = _highPriority[indexPath.row];
            break;
    }

    cell.taskLabel.text = task.name;
    
    
    if (task.priority == 2) {
        cell.priorityImageView.image = [UIImage imageNamed:@"high.png"];
    } else if (task.priority == 1) {
        cell.priorityImageView.image = [UIImage imageNamed:@"medium.png"];
    } else {
        cell.priorityImageView.image = [UIImage imageNamed:@"low.png"];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0; 
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterDataWithSearchText:searchText];
    [self.myTable reloadData];
}


- (void)filterDataWithSearchText:(NSString *)searchText {
    self.highPriority = [NSMutableArray new];
    self.mediumPriority = [NSMutableArray new];
    self.lowPriority = [NSMutableArray new];

    for (ToDoListPojo *task in self.allTasks) {
        
        if (task.status != 0) continue;

        if (searchText.length > 0 &&
            ![task.name.lowercaseString containsString:searchText.lowercaseString]) {
            continue;
        }

        switch (task.priority) {
            case 2: [self.highPriority addObject:task]; break;
            case 1: [self.mediumPriority addObject:task]; break;
            case 0: [self.lowPriority addObject:task]; break;
        }
    }

}


- (IBAction)addTask:(id)sender {
    
    AddTaskViewController *SVC = [self.storyboard instantiateViewControllerWithIdentifier:@"toDoScreen"];
    
    [self.navigationController pushViewController:SVC animated:YES];
    
}



@end
