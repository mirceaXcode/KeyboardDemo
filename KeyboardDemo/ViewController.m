//
//  ViewController.m
//  KeyboardDemo
//
//  Created by Mircea Popescu on 8/2/18.
//  Copyright © 2018 Mircea Popescu. All rights reserved.
//


// I had to do uncheck Use Safe Area Layout Guides in order to get the Bottom and Top Layout. You don't have them by default in iOS 11 anymore.
// All you need to do is open the storyboard in IB, make sure the Utilities panel is open, then select the File Inspector tab. If you look in the Interface Builder Document section of the panel you'll see a new checkbox: Use Safe Area Layout Guides.
// https://forums.developer.apple.com/thread/79400

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // NSNotificationCenter is the place in iOS that broadcast information of what's going to the phone, of which your app might want to grab some
    // Getting a connection to the Notification Center itself
    NSNotificationCenter *ctr = [NSNotificationCenter defaultCenter];
    // Getting notified when the Keyboard will Show and run the function specified in the selector
    [ctr addObserver:self selector:@selector(moveKeyboardInResponseToWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    // Getting notified if the keyboard is hidden and run the function specified in the selector when the keyboard is about to hide
    [ctr addObserver:self selector:@selector(moveKeyboardInResponseToWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

// Deregister from the NotificationCenter by deallocating the memory, when the object gets destroyed
-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)resignKeyboard:(id)sender {
    [self.textField resignFirstResponder];
}

-(void) moveKeyboardInResponseToWillShowNotification:(NSNotification *) notification {
    
    // Getting information fromt he notification, we are particullary intrested in the keyboard, where the keybpard is.
    NSDictionary *info = [notification userInfo];
    
    // Declare a keyboard and get information of where it is
    CGRect kbRect;
    kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    // Getting information about the animation that is happening with the keybboard, how long does it take to come up and whats the shape of it
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] floatValue];
    UIViewAnimationCurve curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    // Finish constructing the autolayout and any annimation that is in process(laying out the UI), so we can go ahead and create our own
    [self.view layoutSubviews];
    
    // Begin the Animation!
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    // If there is any other animation goin on, stop that and begin this one, we want to take over the Animation
    [UIView setAnimationBeginsFromCurrentState:true];
    
    // We are setting the bottom layout of our View to the hight of the keyboard, so the image/text window will resize and include the keyboard bellow
    self.bottomLayout.constant = kbRect.size.height;
    
    [self.view layoutSubviews];
    
    // Go ahead and animate the process
    [UIView commitAnimations];
}

-(void) moveKeyboardInResponseToWillHideNotification:(NSNotification *) notification {
    
    NSDictionary *info = [notification userInfo];
    CGRect kbRect = CGRectZero;
    
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] floatValue];
    UIViewAnimationCurve curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [self.view layoutSubviews];
    
    //Animate
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:true];
    
    
    self.bottomLayout.constant = kbRect.size.height;
    
    [self.view layoutSubviews];
    
    [UIView commitAnimations];
}

@end
