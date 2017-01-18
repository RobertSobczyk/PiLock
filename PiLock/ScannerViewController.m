//
//  ScannerViewController.m
//  PiLock
//
//  Created by Robert Sobczyk on 14.12.2016.
//  Copyright © 2016 Robert Sobczyk. All rights reserved.
//

#import "ScannerViewController.h"
#import "LoginViewController.h"
#import "QRCodeReaderViewController.h"
#import "UIViewController+Alert.h"
@import FirebaseAuth;
@import FirebaseDatabase;
@interface ScannerViewController ()

@end

@implementation ScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    _codes = [[NSMutableArray alloc] init];
    [_codes removeAllObjects];
    [self dataLoad];
}

-(void)dataLoad {

    _ref = [[FIRDatabase database] reference];
    
    _codes = [[NSMutableArray alloc] init];
    
    [[_ref child:@"barcodes"]
     observeEventType:FIRDataEventTypeChildAdded
     withBlock:^(FIRDataSnapshot *snapshot)
    {
         if ([snapshot.value[@"usedBy"] isEqualToString:@""])
         {
             [_codes addObject:snapshot.value[@"name"]];
         }
        [self.tableView reloadData];
    }];
    [self.tableView reloadData];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didLogout:(id)sender {
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    
    if (!error) {
        LoginViewController *LoginController = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstViewController"];
        [self presentViewController:LoginController animated:YES completion:nil];
        
    }

}
- (IBAction)openScanner:(UIButton *)sender {
    
    _ref = [[FIRDatabase database] reference];
    NSString *userID = [FIRAuth auth].currentUser.uid;
    
    QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    QRCodeReaderViewController *vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Anuluj" codeReader:reader startScanningAtLoad:YES];
    
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    
    
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        
        [[_ref child:@"barcodes"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            if ([snapshot.key isEqualToString:resultAsString]){
                
                [[[_ref child:@"users"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSString *userMail = snapshot.value[@"username"];
                
                    if ([snapshot.value[@"haveCode"] isEqualToString:@"true"]){
                        [self showMessagePrompt:@"Posiadasz już szafkę"];
                    }
                    else
                    {
                        [[[_ref child:@"barcodes"] child:resultAsString] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    
                            if ([snapshot.value[@"usedBy"] isEqualToString:@""]){
                                [[[_ref child:@"barcodes"] child:resultAsString]
                                 setValue:@{@"name": snapshot.value[@"name"], @"usedBy": userID, @"open": snapshot.value[@"open"] }];
                                [[[_ref child:@"users"] child:userID]
                                 setValue:@{@"username": userMail, @"haveCode": @"true"}];
                                //Dopisanie usera do szafki
                            }
                            else
                            {
                                if ([snapshot.value[@"usedBy"] isEqualToString:userID]){
                                    [self showMessagePrompt:@"Szafka jest zajęta przez Ciebie"];
                                }
                                else
                                {
                                    [self showMessagePrompt:@"Szafka jest zajęta"];
                                }
                            }
                        }];}
                }];
            }
            NSLog(@"nazwa szafki %@",snapshot.value[@"name"]);
            NSLog(@"Snapshot key %@", snapshot.key);
        }];
        
        [self dismissViewControllerAnimated:YES completion:NULL];
        
    }];
    
    [self presentViewController:vc animated:YES completion:NULL];
}

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
     NSLog(@"%@", result);
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    NSLog(@" Anuluj naciśnięte ");
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _codes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellId=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==Nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }

    cell.textLabel.text=[_codes objectAtIndex:indexPath.row];
    return cell;
}

@end

