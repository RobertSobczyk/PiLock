//
//  ViewController.m
//  PiLock
//
//  Created by Robert Sobczyk on 06.12.2016.
//  Copyright © 2016 Robert Sobczyk. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "ScannerViewController.h"
@import FirebaseAuth;
@import FirebaseDatabase;
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didLogout:(id)sender {
    
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    
    if (!error) {
        //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        LoginViewController *LoginController = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstViewController"];
        [self presentViewController:LoginController animated:YES completion:nil];
        
    }
}
@end
