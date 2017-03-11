//
//  DSLStepper.h
//  DSLStepper
//
//  Created by 邓顺来 on 2017/2/25.
//  Copyright © 2017年 邓顺来. All rights reserved.
//

#import <UIKit/UIKit.h>

//支持xib
IB_DESIGNABLE
@interface DSLStepper : UIView

/**
 中间的textField
 */
@property (strong, nonatomic, readonly) UITextField *textField;

/**
 + 按钮
 */
@property (strong, nonatomic, readonly) UIButton *incrementButton;

/**
 - 按钮
 */
@property (strong, nonatomic, readonly) UIButton *decrementButton;

/**
 默认1
 */
@property (assign, nonatomic) IBInspectable NSInteger value;

/**
 最小值，默认1
 */
@property (assign, nonatomic) IBInspectable NSInteger minimum;

/**
 最大值，默认9999
 */
@property (assign, nonatomic) IBInspectable NSInteger maximum;

/**
 两个按钮的宽，默认35
 */
@property (assign, nonatomic) IBInspectable CGFloat buttonWidth;

/**
 边的颜色，默认0xfe4365
 */
@property (strong, nonatomic) IBInspectable UIColor *borderColor;

/**
 字体颜色，默认0xfe4365
 */
@property (strong, nonatomic) IBInspectable UIColor *textFieldTextColor;

/**
 字体大小，默认14
 */
@property (assign, nonatomic) IBInspectable CGFloat textFieldFontSize;

/**
 两个按钮的字体颜色，默认0xfe4365
 */
@property (strong, nonatomic) IBInspectable UIColor *buttonTextColor;

/**
 两个按钮的字体大小，默认Avenir-Black 23
 */
@property (assign, nonatomic) IBInspectable CGFloat buttionFontSize;

/**
 value变化后触发block
 */
- (void)setValueDidChangeBlock:(void (^)(NSInteger value))block;

/**
 点击 - + 按钮后触发block（value已发生变化）
 */
- (void)setDidClickBtnBlock:(void (^)(NSInteger value))didClickBtnBlock;

/**
 点击Done后触发block
 */
- (void)setDidClickDoneBlock:(void (^)(NSInteger value))didClickDoneBlock;

@end
