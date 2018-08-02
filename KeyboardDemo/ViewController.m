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
    
    NSNotificationCenter *ctr = [NSNotificationCenter defaultCenter];
    [ctr addObserver:self selector:@selector(moveKeyboardInResponseToWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    
     [ctr addObserver:self selector:@selector(moveKeyboardInResponseToWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)resignKeyboard:(id)sender {
    [self.textField resignFirstResponder];
}

-(void) moveKeyboardInResponseToWillShowNotification:(NSNotification *) notification {
    
    NSDictionary *info = [notification userInfo];
    CGRect kbRect;
    
    if([notification.name isEqualToString:UIKeyboardWillShowNotification]){
        kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    } else {
        kbRect = CGRectZero;
    }
    
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] floatValue];
    UIViewAnimationCurve curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [self.view layoutSubviews];
    
    //Animate
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:true];
    
//    UIScrollView *scrollView;
//    scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top, scrollView.contentInset.left, MAX(kbRect.size.height, scrollView.contentInset.bottom), scrollView.contentInset.right);
    
    self.bottomLayout.constant = kbRect.size.height;
    
    [self.view layoutSubviews];
    
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
