//
//  ESPCollectionViewController.m
//  EspTouchDemo
//
//  Created by jakeykaso on 2016/4/7.
//  Copyright © 2016年 白 桦. All rights reserved.
//

#import "ESPCollectionViewController.h"

@interface ESPCollectionViewController ()
@property (nonatomic, strong) UIButton* currentButton;
@property (nonatomic, assign) BOOL getIRPairing;

@property (nonatomic, strong) NSArray* items;
@end

@implementation ESPCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    button.frame = CGRectMake(100, 100, 80, 60);
//    //    button.backgroundColor = [UIColor blueColor];
//    //    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    //[button setImage:[UIImage imageNamed:@"btng.png"] forState:UIControlStateNormal];
//    [button setTitle:@"點擊" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];

//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell1"];
    
    self.items = [[NSArray alloc] initWithObjects:
                  @"Jack"
                  , @"Eric"
                  , @"Jason"
                  , @"Ray"
                  , @"Kevin"
                  , @"Jason"
                  , nil];
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

#pragma mark - Action

//-(void)buttonAction:(UIButton *)sender
//{
//    //    LOGD(@"title:%@", sender.currentTitle);
//
//    // 配對中
//    if (self.getIRPairing == YES) {
//        self.currentButton = sender;
//    }
//    else if ([sender.currentTitle isEqualToString:@"點擊"] == NO) {
////        NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
////        [dictionary setObject:sender.currentTitle forKey:@"setIR"];
////        NSString* json = [self.telnet jsonDictionaryToJsonString:dictionary];
////        [self.telnet sendWithString:json];
//    }
//}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UILabel* label = (UILabel*)[cell viewWithTag:100];
    [label setText:[self.items objectAtIndex:[indexPath row]]];
    [cell setBackgroundColor:[UIColor blueColor]];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
