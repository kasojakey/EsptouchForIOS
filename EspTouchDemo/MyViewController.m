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

@interface MyViewController ()
@property (nonatomic, strong) UICollectionView* collectionView;

@property (nonatomic, strong) Telnet* telnet;
@property (nonatomic, strong) id<NSObject> observer;

@property (nonatomic, strong) NSMutableArray* itemList;
@property (nonatomic, assign) long currentIR;
@property (nonatomic, assign) BOOL getIRPairing;
@end

@implementation MyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.telnet = [Telnet sharedInstance];
    [self.telnet registerDidReadData:^(NSNotification *notification) {
        NSDictionary *dict = notification.userInfo;
        LOGD(@"dict:%@", dict);
        
        NSNumber* getIRObject = [dict objectForKey:@"getIR"];
        if (getIRObject != nil) {
            long getIR = [getIRObject longValue];
            if (getIR != 0 && getIR != 1 && getIR != -1) {
                self.currentIR = getIR;
                LOGD(@"currentIR:%ld", self.currentIR);
            }
        }
    }];

//    [[NSUserDefaults standardUserDefaults] setValue:@(0x06F93AC5) forKey:@"myString"];
//    [userDefaults synchronize];
//    long val = [[[NSUserDefaults standardUserDefaults] objectForKey:@"myString"] longValue];
//    LOGD(@"val:%ld", val);
    
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
    
    self.itemList = [[NSMutableArray alloc] initWithCapacity:20];
    for (int i=1 ; i<=9 ; i++) {
        [self.itemList addObject:@(i)];
    }
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

#pragma mark - Action

- (IBAction)pairButton:(UIButton *)sender
{
    self.getIRPairing = !self.getIRPairing;
    
    if (self.getIRPairing == YES) {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
    }
    else {
        [sender setTitle:@"配對" forState:UIControlStateNormal];
    }
    
//    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
//    [dict setObject:[NSNumber numberWithBool:YES] forKey:@"getIR"];
//    NSString* json = [self.telnet jsonDictionaryToJsonString:dict];
//    [self.telnet sendWithString:json];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.itemList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell *cell = (MyCollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    NSNumber* index = [self.itemList objectAtIndex:indexPath.item];
    
    for (UIView* subView in cell.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        }
    }
    
    cell.label = [[UILabel alloc] initWithFrame:cell.bounds];
    cell.label.text = [NSString stringWithFormat:@"%d", [index intValue]];
    cell.label.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:cell.label];
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    NSNumber* index = [self.itemList objectAtIndex:sourceIndexPath.item];
    [self.itemList removeObjectAtIndex:sourceIndexPath.item];
    [self.itemList insertObject:index atIndex:destinationIndexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LOGD(@"didSelectItemAtIndexPath");
    
    MyCollectionViewCell *cell = (MyCollectionViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
    LOGD(@"label.text:%@", cell.label.text);
    
    // 配對中
    if (self.getIRPairing == YES) {
        LOGD(@"currentIR:%ld", self.currentIR);
        
        [[NSUserDefaults standardUserDefaults] setValue:@(self.currentIR) forKey:cell.label.text];
//        cell.label.text = [NSString stringWithFormat:@"%ld", self.currentIR];
    }
    // 使用中
    else {
        long val = [[[NSUserDefaults standardUserDefaults] objectForKey:cell.label.text] longValue];
        LOGD(@"val:%ld", val);
        
        NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:@(val) forKey:@"setIR"];
        NSString* json = [self.telnet jsonDictionaryToJsonString:dictionary];
        [self.telnet sendWithString:json];
    }
    
//    long val = 0x06F93AC5;
//    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
//    [dictionary setObject:[NSNumber numberWithLong:val] forKey:@"setIR"];
//    NSString* json = [self.telnet jsonDictionaryToJsonString:dictionary];
//    [self.telnet sendWithString:json];
}

@end
