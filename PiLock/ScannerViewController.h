//
//  ScannerViewController.h
//  PiLock
//
//  Created by Robert Sobczyk on 14.12.2016.
//  Copyright © 2016 Robert Sobczyk. All rights reserved.
//

#import <UIKit/UIKit.h>
@import FirebaseDatabase;

@interface ScannerViewController : UIViewController
@property (nonatomic, readonly, strong) FIRDatabaseReference * ref;

@end
