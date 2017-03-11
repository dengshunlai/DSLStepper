//
//  DSLStepper.m
//  DSLStepper
//
//  Created by 邓顺来 on 2017/2/25.
//  Copyright © 2017年 邓顺来. All rights reserved.
//

#import "DSLStepper.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface DSLStepper ()

@property (copy, nonatomic) void (^valueDidChangeBlock)(NSInteger value);
@property (copy, nonatomic) void (^didClickBtnBlock)(NSInteger value);
@property (copy, nonatomic) void (^didClickDoneBlock)(NSInteger value);

@end

@implementation DSLStepper

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    _value = 1;
    _minimum = 1;
    _maximum = 9999;
    _buttonWidth = 35;
    _borderColor = UIColorFromRGB(0xfe4365);
    _buttonTextColor = UIColorFromRGB(0xfe4365);
    _textFieldTextColor = UIColorFromRGB(0xfe4365);
    _buttionFontSize = 23;
    _textFieldFontSize = 14;
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = _borderColor.CGColor;
    self.layer.borderWidth = 1;
    
    _incrementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_incrementButton setTitleColor:_buttonTextColor forState:UIControlStateNormal];
    _incrementButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:_buttionFontSize];
    [_incrementButton setTitle:@"+" forState:UIControlStateNormal];
    [_incrementButton addTarget:self action:@selector(increment:) forControlEvents:UIControlEventTouchUpInside];
    
    _decrementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_decrementButton setTitleColor:_buttonTextColor forState:UIControlStateNormal];
    _decrementButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:_buttionFontSize];
    [_decrementButton setTitle:@"-" forState:UIControlStateNormal];
    [_decrementButton addTarget:self action:@selector(decrement:) forControlEvents:UIControlEventTouchUpInside];
    
    _textField = [[UITextField alloc] init];
    _textField.font = [UIFont systemFontOfSize:_textFieldFontSize];
    _textField.textColor = _textFieldTextColor;
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.layer.borderColor = _borderColor.CGColor;
    _textField.layer.borderWidth = 1;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.text = @(_value).stringValue;
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 35)];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                             style:0 target:self action:@selector(done:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil action:nil];
    [done setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x666666),
                                   NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    toolBar.items = @[space, done];
    _textField.inputAccessoryView = toolBar;
    [_textField addTarget:self action:@selector(tfValueDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_textField addTarget:self action:@selector(tfDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    [self addSubview:_incrementButton];
    [self addSubview:_decrementButton];
    [self addSubview:_textField];
    _incrementButton.translatesAutoresizingMaskIntoConstraints = NO;
    _decrementButton.translatesAutoresizingMaskIntoConstraints = NO;
    _textField.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _decrementButton.frame = CGRectMake(0, 0, _buttonWidth, self.frame.size.height);
    _textField.frame = CGRectMake(_buttonWidth, 0, self.frame.size.width - 2 * _buttonWidth, self.frame.size.height);
    _incrementButton.frame = CGRectMake(self.frame.size.width - _buttonWidth, 0, _buttonWidth, self.frame.size.height);
}

#pragma mark - API

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
    _textField.layer.borderColor = _borderColor.CGColor;
}

- (void)setTextFieldTextColor:(UIColor *)textFieldTextColor
{
    _textFieldTextColor = textFieldTextColor;
    _textField.textColor = _textFieldTextColor;
}

- (void)setTextFieldFontSize:(CGFloat)textFieldFontSize
{
    _textFieldFontSize = textFieldFontSize;
    _textField.font = [UIFont systemFontOfSize:_textFieldFontSize];
}

- (void)setButtonTextColor:(UIColor *)buttonTextColor
{
    _buttonTextColor = buttonTextColor;
    [_incrementButton setTitleColor:_buttonTextColor forState:UIControlStateNormal];
    [_decrementButton setTitleColor:_buttonTextColor forState:UIControlStateNormal];
}

- (void)setButtionFontSize:(CGFloat)buttionFontSize
{
    _buttionFontSize = buttionFontSize;
    _incrementButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:_buttionFontSize];
    _decrementButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:_buttionFontSize];
}

- (void)setButtonWidth:(CGFloat)buttonWidth
{
    _buttonWidth = buttonWidth;
    [self setNeedsLayout];
}

- (void)setValue:(NSInteger)value
{
    if (value > _maximum) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_value > _maximum) {
                _value = _maximum;
                _textField.text = @(_value).stringValue;
                if (self.valueDidChangeBlock) {
                    self.valueDidChangeBlock(_maximum);
                }
            }
        });
    }
    NSInteger oldValue = _value;
    _value = value;
    _textField.text = @(_value).stringValue;
    if (value <= _maximum && oldValue != value) {
        if (self.valueDidChangeBlock) {
            self.valueDidChangeBlock(value);
        }
    }
}

- (void)setMinimum:(NSInteger)minimum
{
    _minimum = minimum;
    if (_value < _minimum) {
        self.value = _minimum;
    }
}

- (void)setMaximum:(NSInteger)maximum
{
    _maximum = maximum;
    if (_value > _maximum) {
        self.value = _maximum;
    }
}

#pragma mark - Action

- (void)tfValueDidChange:(UITextField *)tf
{
    NSRange range = [tf.text rangeOfString:@"^[0-9]+$" options:NSRegularExpressionSearch];
    if (range.location == NSNotFound) {
        range = [tf.text rangeOfString:@"^[0-9]*" options:NSRegularExpressionSearch];
        if (range.location == NSNotFound) {
            self.value = _minimum;
        } else {
            self.value = [tf.text substringWithRange:range].integerValue;
        }
    } else {
        self.value = tf.text.integerValue;
    }
}

- (void)tfDidEndEditing:(UITextField *)tf
{
    if (tf.text.integerValue < _minimum) {
        self.value = _minimum;
    }
}

- (void)increment:(UIButton *)sender
{
    if (_value < _maximum) {
        self.value += 1;
    }
    if (self.didClickBtnBlock) {
        self.didClickBtnBlock(self.value);
    }
}

- (void)decrement:(UIButton *)sender
{
    if (_value > _minimum) {
        self.value -= 1;
    }
    if (self.didClickBtnBlock) {
        self.didClickBtnBlock(self.value);
    }
}

- (void)done:(UIBarButtonItem *)sender
{
    [_textField resignFirstResponder];
    if (self.didClickDoneBlock) {
        if (self.value > _maximum) {
            self.didClickDoneBlock(_maximum);
        } else {
            self.didClickDoneBlock(self.value);
        }
    }
}

@end
