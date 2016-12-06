//
//  LoginViewController.h
//  PiLock
//
//  Created by Robert Sobczyk on 06.12.2016.
//  Copyright © 2016 Robert Sobczyk. All rights reserved.
//

#import <UIKit/UIKit.h>
@import FirebaseDatabase;

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (nonatomic, readonly, strong) FIRDatabaseReference * ref;
@end
