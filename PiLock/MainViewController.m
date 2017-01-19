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

NSString *doorName;
NSString *isOpen;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataLoad];
    if ([isOpen  isEqual: @"true"]) {
        NSLog(@"%@", isOpen);
    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self dataLoad];
    if ([isOpen  isEqual: @"true"]) {
        NSLog(@"%@", isOpen);
    }
    
}

-(void)dataLoad {
    
    _ref = [[FIRDatabase database] reference];
    NSString *userID = [FIRAuth auth].currentUser.uid;
    
    [[[_ref child:@"users"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString *code = snapshot.value[@"code"];
        
        [[[_ref child:@"barcodes"] child:code] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSString *cropString = snapshot.value[@"name"];
            doorName = [cropString stringByReplacingOccurrencesOfString:@"Szafka numer " withString:@""];
            isOpen = snapshot.value[@"open"];
            _doorNameLabel.text = doorName;
            
            if ([isOpen  isEqual: @"false"]){
                _doorStatusLabel.textColor = [UIColor colorWithRed:1.00 green:0.00 blue:0.00 alpha:1.0];
                _doorStatusLabel.text = @"Zamknięta";
            }
            else{
                _doorStatusLabel.textColor = [UIColor colorWithRed:0.38 green:0.59 blue:0.33 alpha:1.0];
                _doorStatusLabel.text = @"Otwarta";
            }
        }];
    }];
}

- (IBAction)unlockButton:(id)sender {
    _doorStatusLabel.textColor = [UIColor colorWithRed:0.38 green:0.59 blue:0.33 alpha:1.0];
    _doorStatusLabel.text = @"Otwarta";
}

- (IBAction)lockButton:(id)sender {
    _doorStatusLabel.textColor = [UIColor colorWithRed:1.00 green:0.00 blue:0.00 alpha:1.0];
    _doorStatusLabel.text = @"Zamknięta";

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
