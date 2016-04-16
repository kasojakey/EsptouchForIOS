//
//  MyViewController.h
//  EspTouchDemo
//
//  Created by jakeykaso on 2016/4/7.
//  Copyright © 2016年 白 桦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraggableCollectionViewFlowLayout.h"
#import "UICollectionView+Draggable.h"

#define IR_User_defaults @"IR_User_defaults"

@interface PairViewController : UIViewController <UICollectionViewDataSource_Draggable, UICollectionViewDelegate>

- (IBAction)pairButtonAction:(UIButton *)sender;
- (IBAction)addIRButtonAction:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *pairButton;
@property (strong, nonatomic) IBOutlet UIButton *addIRButton;

@end
