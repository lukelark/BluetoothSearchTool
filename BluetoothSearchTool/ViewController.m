//
//  ViewController.m
//  BluetoothSearchTool
//
//  Created by zhangwen on 15/2/6.
//  Copyright (c) 2015年 Appscomm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    CBCentralManager *blmanager;
    NSMutableArray *devicesArray;
    NSMutableArray *timeoutNumArray;
    NSTimer *timer;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    devicesArray = [[NSMutableArray alloc] initWithCapacity:1];
    timeoutNumArray = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i = 5; i < 31; i++) {
        [timeoutNumArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    self.searchButton.backgroundColor = [UIColor greenColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startToSearch:(id)sender {
    [devicesArray removeAllObjects];
    self.numLabel.text = [NSString stringWithFormat:@"%ld", (long)devicesArray.count];
    if (blmanager == nil) {
        blmanager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }else{
        self.searchButton.backgroundColor = [UIColor redColor];
        self.searchButton.enabled = NO;
        [self.searchButton setTitle:@"正在搜索蓝牙设备" forState:UIControlStateNormal];
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(starttoScan) userInfo:nil repeats:NO];
    }
}

-(void)starttoScan{
    NSInteger sel = [self.timeoutPickerView selectedRowInComponent:0];
    int timeout = [timeoutNumArray[sel] intValue];
    timer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(stoptoScan) userInfo:nil repeats:NO];
    [blmanager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@NO }];
}

-(void)stoptoScan{
    self.searchButton.backgroundColor = [UIColor greenColor];
    self.searchButton.enabled = YES;
    [self.searchButton setTitle:@"开始搜索" forState:UIControlStateNormal];
    [blmanager stopScan];
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self startToSearch:self.searchButton];
    }else {
        blmanager = nil;
    }
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI {

        if(![devicesArray containsObject:peripheral]){
            NSLog(@"发现设备:%@",peripheral);
            [devicesArray addObject:peripheral];
            self.numLabel.text = [NSString stringWithFormat:@"%ld", (long)devicesArray.count];
        }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return timeoutNumArray[row];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return timeoutNumArray.count;
}

@end
