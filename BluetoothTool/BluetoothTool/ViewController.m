//
//  ViewController.m
//  BluetoothTool
//
//  Created by JamesMac on 2/10/15.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize selectedIndexPath,barNavigation,textViewContext,textCommand;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupNavigationBar];
    [self setupOutputScreen];
}

-(void)setupNavigationBar{
    self.barNavigation.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.barNavigation setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.barNavigation.layer.masksToBounds = NO;
    self.barNavigation.layer.shadowOffset = CGSizeMake(0, 3);
    self.barNavigation.layer.shadowOpacity = 0.6;
    self.barNavigation.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.navigationController.navigationBar.bounds].CGPath;
    self.barNavigation.tintColor = [UIColor whiteColor];
    NSDictionary *barTitleColor = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.barNavigation.titleTextAttributes = barTitleColor;
}

-(void)setupOutputScreen{
    //To make the border look very close to a UITextField
    [self.textViewContext.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.textViewContext.layer setBorderWidth:2.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    self.textViewContext.layer.cornerRadius = 5;
    self.textViewContext.clipsToBounds = YES;
    self.textViewContext.editable = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showDeviceListView{
    listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    listView.titleName.text = @"Choose Device";
    listView.datasource = self;
    listView.delegate = self;
    [listView setCancelButtonTitle:@"Cancel" block:^{
        NSLog(@"cancel");
    }];
    [listView setDoneButtonWithTitle:@"OK" block:^{
        NSLog(@"Done");
    }];
    [listView show];
}

- (IBAction)btnBarScan:(id)sender {
    [self showDeviceListView];    
}

//Todo: send command to sensor
- (IBAction)btnSend:(id)sender {
}


#pragma mark - ZSYPopoverListView delegate method
- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [BlueToothHelper shared].discoveredPeripherals.count;
}

- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ZSYPopoverIdentifier";
    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
    
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if ( self.selectedIndexPath && NSOrderedSame == [self.selectedIndexPath compare:indexPath])
    {
        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    }
    
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    }
    
    cell.textLabel.text = [[BlueToothHelper shared].discoveredPeripherals[indexPath.row] name];

    return cell;
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    NSLog(@"deselect:%ld", (long)indexPath.row);
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    NSLog(@"select:%ld", (long)indexPath.row);
}

#pragma mark - UITextFieldDelegate Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//keyboard 216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.textCommand isFirstResponder] && [touch view] != self.textCommand){
        [self.textCommand resignFirstResponder];
    }
    
    [super touchesBegan:touches withEvent:event];
}
@end
