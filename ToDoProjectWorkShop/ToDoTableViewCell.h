//
//  ToDoTableViewCell.h
//  ToDoProjectWorkShop
//
//  Created by Macos on 23/04/2025.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToDoTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *taskLabel;
@property (weak, nonatomic) IBOutlet UIImageView *priorityImageView;



@end

NS_ASSUME_NONNULL_END
