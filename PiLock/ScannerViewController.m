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
    // Do any additional setup after loading the view.
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
    
    // Instantiate the view controller
    QRCodeReaderViewController *vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
    
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    
    
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        NSString *emptyString = @"";
        
        _ref = [[FIRDatabase database] reference];
        [[_ref child:@"barcodes"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            if ([snapshot.key isEqualToString:resultAsString])
            {
                [[[_ref child:@"users"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                
                if ([snapshot.value[@"haveCode"] isEqualToString:@"true"]){
                    [self showMessagePrompt:@"Posiadasz już szafkę"];
                }
                else
                {
                [[[_ref child:@"barcodes"] child:resultAsString] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    
                    
                        if ([snapshot.value[@"usedBy"] isEqualToString:emptyString]){
                            [[[_ref child:@"barcodes"] child:resultAsString]
                             setValue:@{@"name": snapshot.value[@"name"], @"usedBy": userID}];
                            [[[_ref child:@"users"] child:userID]
                             setValue:@{@"username": userID, @"haveCode": @"true"}];
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
@end
