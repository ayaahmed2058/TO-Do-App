//
//  AddTaskViewController.m
//  ToDoProjectWorkShop
//
//  Created by Macos on 23/04/2025.
//

#import "AddTaskViewController.h"
#import "ToDoListPojo.h"



@interface AddTaskViewController ()

@property (weak, nonatomic) IBOutlet UITextField *taskName;

@property (weak, nonatomic) IBOutlet UITextView *taskDescription;
@property (weak, nonatomic) IBOutlet UISegmentedControl *taskPeriority;
@property (weak, nonatomic) IBOutlet UISegmentedControl *taskState;
@property (weak, nonatomic) IBOutlet UIDatePicker *taskDeadlineDate;


@property (nonatomic, strong) NSUserDefaults *defaults;

@property int status , property;

@end

@implementation AddTaskViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _defaults=[NSUserDefaults standardUserDefaults];
    [self.taskState setEnabled:NO forSegmentAtIndex:1];
    [self.taskState setEnabled:NO forSegmentAtIndex:2];
    _status = 0;
    // Do any additional setup after loading the view.

    [self configureDatePicker];
}


- (void)configureDatePicker {
    // Set minimum date to the current date and time
    self.taskDeadlineDate.minimumDate = [NSDate date];
  
}


- (IBAction)addTask:(id)sender {

    
        
        if (_taskName.text.length == 0 || _taskDescription.text.length == 0) {
            [self showAlertWithMessage:@"Fields cannot be empty"];
            return;
        }

        NSData *savedData = [_defaults objectForKey:@"tasks"];
        NSMutableArray *tasks;
        
        if (savedData != nil) {
            NSError *error;
            NSSet *classes = [NSSet setWithObjects:[NSArray class], [ToDoListPojo class], nil];
            tasks = [[NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:savedData error:&error] mutableCopy];
            if (!tasks) tasks = [NSMutableArray new];
        } else {
            tasks = [NSMutableArray new];
        }
        
        for (ToDoListPojo *existingTask in tasks) {
            if ([existingTask.name isEqualToString:_taskName.text]) {
                [self showAlertWithMessage:@"Task already exists"];
                return;
            }
        }
        
        ToDoListPojo *task = [ToDoListPojo new];
        task.name = _taskName.text;
        task.dis = _taskDescription.text;
        task.priority = _property;
        task.status = 0;
        task.endDate = _taskDeadlineDate.date;
        
        [tasks addObject:task];
        
        NSError *error;
        NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:tasks requiringSecureCoding:YES error:&error];
        [_defaults setObject:archiveData forKey:@"tasks"];
        [_defaults synchronize];
        
        [self.navigationController popViewControllerAnimated:YES];
    

    
}
         

            
- (IBAction)addPriority:(UISegmentedControl *)sender {
    _property = (int)sender.selectedSegmentIndex;

}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
