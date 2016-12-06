//
//  LoginViewController.m
//  PiLock
//
//  Created by Robert Sobczyk on 06.12.2016.
//  Copyright © 2016 Robert Sobczyk. All rights reserved.
//

#import "LoginViewController.h"
#import "UIViewController+Alert.h"
#import "AppDelegate.h"

@import FirebaseAuth;
@import FirebaseDatabase;

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didCreateAccount:(id)sender {
    
        _ref = [[FIRDatabase database] reference];
    
        [self showTextInputPromptWithMessage:@"Email:"  completionBlock:^(BOOL userPressedOK, NSString * _Nullable email) {
            if (_emailField.text != NULL){
                email = _emailField.text;
            }
            if (!userPressedOK || !email.length)
            {
                return;
            }
    
        [self showTextInputPromptWithMessage:@"Password:" completionBlock:^(BOOL userPressedOK, NSString * _Nullable password) {
            if (!userPressedOK || !password.length)
            {
                return;
            }
        [[FIRAuth auth] createUserWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            if (error)
            {
                [self showMessagePrompt:error.localizedDescription];
                return;
            }
            [self showMessagePrompt:@""];
            [[[_ref child:@"users"] child:user.uid] setValue:@{@"username":email}];
            NSLog(@"%@ created", user.email);
            [self.navigationController popViewControllerAnimated:YES];
        }];
        }];
        }];
}


- (IBAction)didForgotPassword:(id)sender {
    
        [self showTextInputPromptWithMessage:@"Email:" completionBlock:^(BOOL userPressedOK, NSString *_Nullable userInput) {
            if (!userPressedOK || !userInput.length)
            {
                return;
            }
         
        [[FIRAuth auth] sendPasswordResetWithEmail:userInput completion:^(NSError *_Nullable error) {
            if (error)
            {
                [self showMessagePrompt:error.localizedDescription];
                return;
            }
             
            [self showMessagePrompt:@"Sent"];
        }];
        }];
}
- (IBAction)didTouchLogin:(id)sender {
    
        [[FIRAuth auth] signInWithEmail:_emailField.text password:_passwordField.text completion:^(FIRUser *user, NSError *error){
            if (error)
            {
                [self showMessagePrompt: error.localizedDescription];
                return;
            }
        
            [self.navigationController popViewControllerAnimated:YES];
            //To do - segue to scanner
            //[self performSegueWithIdentifier:@"" sender:self];
    }];
    
}

- (IBAction)shortcut:(id)sender {
    NSString *email = @"szopkowy@gmail.com";
    NSString *password = @"abc123";
        [[FIRAuth auth] signInWithEmail:email password:password completion:^(FIRUser *user, NSError *error){
            if (error)
            {
                [self showMessagePrompt: error.localizedDescription];
                return;
            }
        
        [self.navigationController popViewControllerAnimated:YES];
        //To do - segue to scanner
        //[self performSegueWithIdentifier:@"" sender:self];
    }];
    
}


@end
