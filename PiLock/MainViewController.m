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
    
    _valid = @"True";
    _ref = [[FIRDatabase database] reference];
    
    [[_ref child:@"barcodes"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString *userID = [FIRAuth auth].currentUser.uid;
        
        if ( [_valid  isEqual: @"True"])
        {
            if ([snapshot.value[@"usedBy"] isEqualToString:userID]){
            
                NSLog(@"Zalogowany user jest dopisany do szafki");
                _valid = @"False";
                
            }else{
                
                NSLog(@"Zalogowany user NIE jest dopisany do szafki");
                
                ScannerViewController *SkannerController = [self.storyboard instantiateViewControllerWithIdentifier:@"ScannerViewController"];
                [self presentViewController:SkannerController animated:YES completion:nil];
            }
            
        }
    }];
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
