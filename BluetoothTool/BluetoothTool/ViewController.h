//
//  ViewController.h
//  BluetoothTool
//
//  Created by JamesMac on 2/10/15.
//

#import <UIKit/UIKit.h>
#import "ZSYPopoverListView.h"

@interface ViewController : UIViewController<ZSYPopoverListDatasource, ZSYPopoverListDelegate, UITextFieldDelegate, UITextViewDelegate>{
    ZSYPopoverListView *listView;
}
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@property (weak, nonatomic) IBOutlet UITextField *textCommand;
@property (weak, nonatomic) IBOutlet UINavigationBar *barNavigation;
- (IBAction)btnBarScan:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textViewContext;

- (IBAction)btnSend:(id)sender;
@end

