//
//  ScannerViewController.h
//  PiLock
//
//  Created by Robert Sobczyk on 14.12.2016.
//  Copyright © 2016 Robert Sobczyk. All rights reserved.
//

#import <UIKit/UIKit.h>
@import FirebaseDatabase;

@interface ScannerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, readonly, strong) FIRDatabaseReference * ref;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *codes;
@property (strong, nonatomic) FIRDatabaseReference *codesRef;

@end
