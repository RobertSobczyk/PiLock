//
//  FirstViewController.m
//  PiLock
//
//  Created by Robert Sobczyk on 06.12.2016.
//  Copyright © 2016 Robert Sobczyk. All rights reserved.
//

#import "FirstViewController.h"
@import FirebaseAuth;
@import FirebaseDatabase;

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth,
                                                    FIRUser *_Nullable user) {
        
        if (user == nil) {
            // No user is signed in.
            [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"USER %@", user);
            [self performSegueWithIdentifier:@"FirstViewShowLogin" sender:self];
            
        } else {
            // User is signed in.
            [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"USER %@", user);
            [self performSegueWithIdentifier:@"FirstViewShowMain" sender:self];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
