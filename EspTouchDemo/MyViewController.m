//
//  MyViewController.m
//  EspTouchDemo
//
//  Created by jakeykaso on 2016/4/7.
//  Copyright © 2016年 白 桦. All rights reserved.
//

#import "MyViewController.h"
#import "MyCollectionViewCell.h"
#import "Telnet.h"

#define Cell_Label_Tag 100
#define IR_User_defaults @"IR_User_defaults"

@interface MyViewController ()
@property (nonatomic, strong) UICollectionView* collectionView;

@property (nonatomic, strong) Telnet* telnet;
@property (nonatomic, strong) id<NSObject> observer;

@property (nonatomic, strong) NSMutableArray* IRPojoList;
@property (nonatomic, strong) MyCollectionViewCell* currentCell;
@property (nonatomic, strong) NSIndexPath* currentIndexPath;

@property (nonatomic, assign) BOOL getIRPairing;
@end

@implementation MyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.telnet = [Telnet sharedInstance];
    [self.telnet registerDidReadData:^(NSNotification *notification) {
        NSDictionary *dict = notification.userInfo;
        LOGD(@"dict:%@", dict);
        
        NSNumber* getIRObject = [dict objectForKey:@"getIR"];
        if (getIRObject != nil) {
            long getIR = [getIRObject longValue];
            if (getIR != 0 && getIR != 1 && getIR != -1) {
                if (self.currentCell != nil) {
                    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:[self.IRPojoList objectAtIndex:self.currentIndexPath.item]];
                    [dict setValue:@(getIR) forKey:@"IR"];
                    [self.IRPojoList replaceObjectAtIndex:self.currentIndexPath.item withObject:dict];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:self.IRPojoList forKey:IR_User_defaults];
                    self.currentCell.backgroundColor = [UIColor greenColor];
                    self.currentCell = nil;
                }
            }
        }
    }];
    
    DraggableCollectionViewFlowLayout* flowLayout = [[DraggableCollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setItemSize:CGSizeMake(100, 100)];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.draggable = YES;
    self.collectionView.backgroundColor = [UIColor blueColor];
    [self.collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:self.collectionView];
    
    self.IRPojoList = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:IR_User_defaults]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Method

-(void)addIR
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:@"預設" forKey:@"name"];
    [dict setValue:@(-1) forKey:@"IR"];
    [self.IRPojoList addObject:dict];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.IRPojoList forKey:IR_User_defaults];
    [self.collectionView reloadData];
}

#pragma mark - Action

- (IBAction)pairButtonAction:(UIButton *)sender
{
    self.getIRPairing = !self.getIRPairing;
    
    if (self.getIRPairing == YES) {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
    }
    else {
        if (self.currentCell != nil) {
            self.currentCell.backgroundColor = [UIColor whiteColor];
            self.currentCell = nil;
        }
        
        [sender setTitle:@"編輯" forState:UIControlStateNormal];
    }
}

- (IBAction)addIRButtonAction:(UIButton *)sender
{
    [self addIR];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.IRPojoList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell *cell = (MyCollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:[self.IRPojoList objectAtIndex:indexPath.item]];
    
    for (UIView* subView in cell.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        }
    }
    
    cell.label = [[UILabel alloc] initWithFrame:cell.bounds];
    cell.label.text = [dict objectForKey:@"name"];
    cell.label.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:cell.label];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
//    NSNumber* index = [self.IRPojoList objectAtIndex:sourceIndexPath.item];
//    [self.IRPojoList removeObjectAtIndex:sourceIndexPath.item];
//    [self.IRPojoList insertObject:index atIndex:destinationIndexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    LOGD(@"didSelectItemAtIndexPath");
    
    MyCollectionViewCell *cell = (MyCollectionViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
//    LOGD(@"label.text:%@", cell.label.text);
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:[self.IRPojoList objectAtIndex:indexPath.item]];
    
    // 配對中
    if (self.getIRPairing == YES) {
//        LOGD(@"currentIR:%ld", self.currentIR);
        
        if (self.currentCell != nil) {
            self.currentCell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.backgroundColor = [UIColor yellowColor];
        self.currentCell = cell;
        self.currentIndexPath = indexPath;
    }
    // 使用中
    else {
        NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:[dict objectForKey:@"IR"] forKey:@"setIR"];
        NSString* json = [self.telnet jsonDictionaryToJsonString:dictionary];
        [self.telnet sendWithString:json];
    }
}

#pragma mark - UICollectionViewDataSource_Draggable

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.getIRPairing) {
        __block MyCollectionViewCell *cell = (MyCollectionViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
        __block UIAlertController* alert =  [UIAlertController
                                             alertControllerWithTitle:@"編輯"
                                             message:@""
                                             preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       cell.label.text = alert.textFields[0].text;
                                                       LOGD(@"alert.textFields[0].text:%@", alert.textFields[0].text);
                                                       NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:[self.IRPojoList objectAtIndex:indexPath.item]];
                                                       [dict setObject:cell.label.text forKey:@"name"];
                                                       [self.IRPojoList replaceObjectAtIndex:indexPath.item withObject:dict];
                                                       
                                                       // 設定新值
                                                      [[NSUserDefaults standardUserDefaults] setObject:self.IRPojoList forKey:IR_User_defaults];
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        
        UIAlertAction* delete = [UIAlertAction actionWithTitle:@"刪除"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        [alert addAction:delete];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"名稱";
            textField.text = cell.label.text;
        }];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;
    }
    else {
        return YES;
    }
}

@end
