//
//  ViewController.h
//  BluetoothSearchTool
//
//  Created by zhangwen on 15/2/6.
//  Copyright (c) 2015年 Appscomm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController : UIViewController<CBCentralManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *timeoutPickerView;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;
- (IBAction)startToSearch:(id)sender;

@end

