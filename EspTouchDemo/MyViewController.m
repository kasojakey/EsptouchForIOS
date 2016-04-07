//
//  MyViewController.m
//  EspTouchDemo
//
//  Created by jakeykaso on 2016/4/7.
//  Copyright © 2016年 白 桦. All rights reserved.
//

#import "MyViewController.h"
#import "Telnet.h"

@interface MyViewController ()
@property (nonatomic, strong) Telnet* telnet;
@property (nonatomic, strong) NSMutableArray* itemList;
@end

@implementation MyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.telnet = [Telnet sharedInstance];
    
    DraggableCollectionViewFlowLayout* flowLayout = [[DraggableCollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setItemSize:CGSizeMake(100, 100)];
    
    UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.draggable = YES;
    collectionView.backgroundColor = [UIColor blueColor];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [self.view addSubview:collectionView];
    
    self.itemList = [[NSMutableArray alloc] initWithCapacity:20];
    for (int i=1 ; i<=9 ; i++) {
        [self.itemList addObject:@(i)];
    }
}

- (void)didReceiveMemoryWarning
{
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

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.itemList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    NSNumber* index = [self.itemList objectAtIndex:indexPath.item];
    
    for (UIView* subView in cell.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        }
    }
    
    UILabel* label = [[UILabel alloc] initWithFrame:cell.bounds];
    label.text = [NSString stringWithFormat:@"%d", [index intValue]];
    label.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:label];
    
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
    
//    long val = 0x06F93AC5;
//    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
//    [dictionary setObject:[NSNumber numberWithLong:val] forKey:@"setIR"];
//    NSString* json = [self.telnet jsonDictionaryToJsonString:dictionary];
//    [self.telnet sendWithString:json];
}

@end
