//
//  ViewController.h
//  PiLock
//
//  Created by Robert Sobczyk on 06.12.2016.
//  Copyright © 2016 Robert Sobczyk. All rights reserved.
//

#import <UIKit/UIKit.h>
@import FirebaseAuth;
@import FirebaseDatabase;

@interface MainViewController : UIViewController
@property (nonatomic, readonly, strong) FIRDatabaseReference *ref;
//@property (nonatomic,strong) NSString *valid;

@end

