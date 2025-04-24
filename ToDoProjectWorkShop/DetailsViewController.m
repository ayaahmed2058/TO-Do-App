//
//  DetailsViewController.m
//  ToDoProjectWorkShop
//
//  Created by Macos on 24/04/2025.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *selectedTaskName;
@property (weak, nonatomic) IBOutlet UITextView *selectedTaskDescription;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectedTaskPeriority;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectedTaskState;
@property (weak, nonatomic) IBOutlet UIDatePicker *selectedTaskDate;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _selectedTaskName.text = _task.name;
    _selectedTaskName.enabled = NO;
    _selectedTaskDescription.text = _task.dis;
    _selectedTaskPeriority.selectedSegmentIndex = _task.priority;
    _selectedTaskState.selectedSegmentIndex = _task.status;
    if (_task.endDate) {
        _selectedTaskDate.date = _task.endDate;
    }
       
    [self configureDatePicker];
    [self setControlsEnabled:NO];
    
    if ([self.mode isEqualToString:@"done"]) {
        
            self.editBtn.hidden = YES;
        
    }else if([self.mode isEqualToString:@"inProgress"]){
        
        [self.selectedTaskState setEnabled:NO forSegmentAtIndex:0];
        
    }
    
}


- (void)configureDatePicker {
        // Set minimum date to the current date and time
        self.selectedTaskDate.minimumDate = [NSDate date];
      
}

- (void)setControlsEnabled:(BOOL)enabled {
    _selectedTaskDescription.editable = enabled;
    _selectedTaskPeriority.enabled = enabled;
    _selectedTaskState.enabled = enabled;
    _selectedTaskDate.enabled = enabled;
    

    _selectedTaskDescription.layer.borderWidth = enabled ? 1.0 : 0.0;
    _selectedTaskDescription.layer.borderColor = enabled ? [UIColor lightGrayColor].CGColor : nil;
    _selectedTaskDescription.layer.cornerRadius = enabled ? 5.0 : 0.0;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)editTask:(id)sender {
  
    BOOL isEditing = _selectedTaskDescription.editable;
     
       if (isEditing) {
           
           _task.dis = _selectedTaskDescription.text;
           _task.priority = (int)_selectedTaskPeriority.selectedSegmentIndex;
           _task.status = (int)_selectedTaskState.selectedSegmentIndex;
           _task.endDate = _selectedTaskDate.date;
           
           
           [self saveTaskChanges];
           
           [self.navigationController popViewControllerAnimated:YES];

       } else {
           
           [self setControlsEnabled:YES];
       }
       
       
    UIButton *button = (UIButton *)sender;
    [button setTitle:(isEditing ? @"Edit" : @"Save") forState:UIControlStateNormal];

}

- (void)saveTaskChanges {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *savedData = [defaults objectForKey:@"tasks"];
    if (savedData) {
        NSError *error;
        NSSet *classes = [NSSet setWithObjects:[NSMutableArray class], [ToDoListPojo class], nil];
        NSMutableArray *tasks = [[NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:savedData error:&error] mutableCopy];

        if (error) {
            NSLog(@"Error unarchiving tasks: %@", error.localizedDescription);
            return;
        }

        for (ToDoListPojo *t in tasks) {
            if ([t.name isEqualToString:self.task.name]) {
                t.dis = _selectedTaskDescription.text;
                t.priority = (int)_selectedTaskPeriority.selectedSegmentIndex;
                t.status = (int)_selectedTaskState.selectedSegmentIndex;
                t.endDate = _selectedTaskDate.date;
                break;
            }
        }

        NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:tasks requiringSecureCoding:YES error:&error];
        if (error) {
            NSLog(@"Error archiving tasks: %@", error.localizedDescription);
            return;
        }
        
        [defaults setObject:archiveData forKey:@"tasks"];
        [defaults synchronize];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskUpdatedNotification" object:nil];
    }
}


@end
