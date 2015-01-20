//
//  HXChanelCell.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-3.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

/**
 *  频道Cell
 */

#import <UIKit/UIKit.h>
#import "HXChanelModel.h"

@protocol HXChanelCellDelegate;

@interface HXChanelCell : UITableViewCell

// 第一个左视图
@property (weak, nonatomic) IBOutlet UIImageView *cellOneLeftImage;

// 第一个左标签
@property (weak, nonatomic) IBOutlet UILabel *cellOneLeftLabel;

// 第一个左标记图
@property (weak, nonatomic) IBOutlet UIImageView *cellOneLeftFlag;

// 第一个右视图
@property (weak, nonatomic) IBOutlet UIImageView *cellOneRightImage;

// 第一个右标签
@property (weak, nonatomic) IBOutlet UILabel *cellOneRightLabel;

// 第一个右标记视图
@property (weak, nonatomic) IBOutlet UIImageView *cellOneRightFlag;


/********************************/
// 第二个左视图
@property (weak, nonatomic) IBOutlet UIImageView *cellTwoLeftImage;

// 第二个左标签
@property (weak, nonatomic) IBOutlet UILabel *cellTwoLeftLabel;

// 第二个左标签
@property (weak, nonatomic) IBOutlet UIImageView *cellTwoLeftFlag;

// 第二个中视图
@property (weak, nonatomic) IBOutlet UIImageView *cellTwoMiddleImage;

// 第二个中标签
@property (weak, nonatomic) IBOutlet UILabel *cellTwoMiddleLabel;

// 第二个中标记视图
@property (weak, nonatomic) IBOutlet UIImageView *cellTwoMiddleFlag;

// 第二个右视图
@property (weak, nonatomic) IBOutlet UIImageView *cellTwoRightImage;

// 第二个右标签
@property (weak, nonatomic) IBOutlet UILabel *cellTwoRightLabel;

// 第二个右标记视图
@property (weak, nonatomic) IBOutlet UIImageView *cellTwoRightFlag;


/********************************/

// 第三个左视图
@property (weak, nonatomic) IBOutlet UIImageView *cellThreeLeftImage;

// 第三个左标签
@property (weak, nonatomic) IBOutlet UILabel *cellThreeLeftLabel;

// 第三个左标记视图
@property (weak, nonatomic) IBOutlet UIImageView *cellThreeLeftFlag;

// 第三个右视图
@property (weak, nonatomic) IBOutlet UIImageView *cellThreeRightImage;

// 第三个右标签
@property (weak, nonatomic) IBOutlet UILabel *cellThreeRightLabel;

// 第三个右标记视图
@property (weak, nonatomic) IBOutlet UIImageView *cellThreeRightFlag;


/********************************/

// 第四个左视图
@property (weak, nonatomic) IBOutlet UIImageView *cellFourLeftImage;

// 第四个左标签
@property (weak, nonatomic) IBOutlet UILabel *cellFourLeftLabel;

// 第四个标记视图
@property (weak, nonatomic) IBOutlet UIImageView *cellFourLeftFlag;

// 第四个右视图
@property (weak, nonatomic) IBOutlet UIImageView *cellFourRightImage;

// 第四个右标签
@property (weak, nonatomic) IBOutlet UILabel *cellFourRightLabel;

// 第四个右标记视图
@property (weak, nonatomic) IBOutlet UIImageView *cellFourRightFlag;


// 存放装有模型的数组
@property (nonatomic, strong) NSArray *chanelModels;

// 选择的频道
@property (nonatomic, assign) NSInteger chanelSelect;

// 代理
@property (nonatomic, assign) id<HXChanelCellDelegate> delegate;

// 点击图片
- (IBAction)tapImage:(UITapGestureRecognizer *)sender;

// 设置Cell
- (void) setChanelCellWith: (NSArray *) chanelModels andChanelCell: (NSInteger) chanelSelect;

@end


// 代理协议
@protocol HXChanelCellDelegate <NSObject>

@optional

// 点击图片时被调用
- (void) tapImageViewToTransferWith: (HXChanelModel *)chanelModel;

@end
