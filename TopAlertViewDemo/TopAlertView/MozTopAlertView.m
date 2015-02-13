//
//  MozTopAlertView.m
//  MoeLove
//
//  Created by LuLucius on 14/12/7.
//  Copyright (c) 2014年 MOZ. All rights reserved.
//

#import "MozTopAlertView.h"
#import "UIFont+FontAwesome.h"
#import "NSString+FontAwesome.h"

#define MOZ_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;

#define hsb(h,s,b) [UIColor colorWithHue:h/360.0f saturation:s/100.0f brightness:b/100.0f alpha:1.0]

#define FlatSkyBlue hsb(204, 76, 86)
#define FlatGreen hsb(145, 77, 80)
#define FlatOrange hsb(28, 85, 90)
#define FlatRed hsb(6, 74, 91)
#define FlatSkyBlueDark hsb(204, 78, 73)
#define FlatGreenDark hsb(145, 78, 68)
#define FlatOrangeDark hsb(24, 100, 83)
#define FlatRedDark hsb(6, 78, 75)

@interface MozTopAlertView (){
    UILabel *leftIcon;
}

@property (nonatomic, copy) dispatch_block_t nextTopAlertBlock;

@end

@implementation MozTopAlertView

- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (BOOL)hasViewWithParentView:(UIView*)parentView{
    if ([self viewWithParentView:parentView]) {
        return YES;
    }
    return NO;
}

+ (MozTopAlertView*)viewWithParentView:(UIView*)parentView{
    NSArray *array = [parentView subviews];
    for (UIView *view in array) {
        if ([view isKindOfClass:[MozTopAlertView class]]) {
            return (MozTopAlertView *)view;
        }
    }
    return nil;
}

+ (MozTopAlertView*)viewWithParentView:(UIView*)parentView cur:(UIView*)cur{
    NSArray *array = [parentView subviews];
    for (UIView *view in array) {
        if ([view isKindOfClass:[MozTopAlertView class]] && view!=cur) {
            return (MozTopAlertView *)view;
        }
    }
    return nil;
}

+ (void)hideViewWithParentView:(UIView*)parentView{
    NSArray *array = [parentView subviews];
    for (UIView *view in array) {
        if ([view isKindOfClass:[MozTopAlertView class]]) {
            MozTopAlertView *alert = (MozTopAlertView *)view;
            [alert hide];
        }
    }
}

+ (MozTopAlertView*)showWithType:(MozAlertType)type text:(NSString*)text parentView:(UIView*)parentView{
    MozTopAlertView *alertView = [[MozTopAlertView alloc]initWithType:type text:text doText:nil];
    [parentView addSubview:alertView];
    [alertView show];
    return alertView;
}

+ (MozTopAlertView*)showWithType:(MozAlertType)type text:(NSString*)text doText:(NSString*)doText doBlock:(dispatch_block_t)doBlock parentView:(UIView*)parentView{
    MozTopAlertView *alertView = [[MozTopAlertView alloc]initWithType:type text:text doText:doText];
    alertView.doBlock = doBlock;
    [parentView addSubview:alertView];
    [alertView show];
    return alertView;
}

- (instancetype)initWithType:(MozAlertType)type text:(NSString*)text doText:(NSString*)doText// parentView:(UIView*)parentView
{
    self = [super init];
    if (self) {
        [self setType:type text:text doText:doText];
    }
    return self;
}

- (void)setType:(MozAlertType)type text:(NSString*)text{
    [self setType:type text:text doText:nil];
}

- (void)setType:(MozAlertType)type text:(NSString*)text doText:(NSString*)doText{
    _autoHide = YES;
    _duration = 3;
    CGFloat width = [UIScreen mainScreen].bounds.size.width*0.8;
    [self setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - width)*0.5, -40, width, 40)];
    
    leftIcon = [[UILabel alloc]initWithFrame:CGRectMake(6, 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame))];
    leftIcon.backgroundColor = [UIColor clearColor];
    [leftIcon setTextColor:[UIColor whiteColor]];
    leftIcon.textAlignment = NSTextAlignmentCenter;
    leftIcon.font = [UIFont fontAwesomeFontOfSize:30];
    [self addSubview:leftIcon];
    
    UIView *leftLine = [[UIView alloc]initWithFrame:CGRectMake(3, 0, 3, CGRectGetHeight(self.frame))];
    leftLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:leftLine];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 2;
    UIColor *doBtnColor = FlatSkyBlueDark;
    switch (type) {
        case MozAlertTypeInfo:{
            self.backgroundColor = FlatSkyBlue;
            leftIcon.hidden = YES;
            doBtnColor = FlatSkyBlueDark;
        }
            break;
        case MozAlertTypeSuccess:
            self.backgroundColor = FlatGreen;
            leftIcon.text = [NSString fontAwesomeIconStringForEnum:FACheckCircle];
            doBtnColor = FlatGreenDark;
            break;
        case MozAlertTypeWarning:
            self.backgroundColor = FlatOrange;
            leftIcon.text = [NSString fontAwesomeIconStringForEnum:FAExclamationCircle];
            doBtnColor = FlatOrangeDark;
            break;
        case MozAlertTypeError:
            self.backgroundColor = FlatRed;
            leftIcon.text = [NSString fontAwesomeIconStringForEnum:FATimesCircle];
            doBtnColor = FlatRedDark;
            break;
        default:
            break;
    }
    
    CGFloat textLabelWidth = width*0.68;
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake((width - textLabelWidth)*0.5, 0, textLabelWidth, CGRectGetHeight(self.frame))];
    textLabel.backgroundColor = [UIColor clearColor];
    [textLabel setTextColor:[UIColor whiteColor]];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:16];
    textLabel.text = text;
    [self addSubview:textLabel];
    
    if (doText) {
        _duration = 4;
        UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 50, 0, 50, CGRectGetHeight(self.frame))];
        
        [rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:doText];
        NSRange contentRange = {0,[content length]};
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        [content addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:contentRange];
        [rightBtn setAttributedTitle:content forState:UIControlStateNormal];
        
        [rightBtn setBackgroundImage:[self createImageWithColor:self.backgroundColor] forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        CGSize size = MOZ_TEXTSIZE(doText, rightBtn.titleLabel.font);
        
        CGFloat rightBtnWidth = size.width + 14;
        rightBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - rightBtnWidth, 0, rightBtnWidth, CGRectGetHeight(self.frame));
        
        textLabel.frame = CGRectMake((width - textLabelWidth)*0.5, 0, textLabelWidth + 30 - rightBtnWidth, CGRectGetHeight(self.frame));
        
        [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightBtn];
        UIView *rightLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - rightBtnWidth - 3, 0, 3, CGRectGetHeight(self.frame))];
        rightLine.backgroundColor = [UIColor whiteColor];
        [self addSubview:rightLine];
    }
    
    leftIcon.layer.opacity = 0;

//    [self show];
}

- (void)rightBtnAction{
    if (_doBlock) {
        _doBlock();
        _doBlock = nil;
    }
}

- (void)show{
    dispatch_block_t showBlock = ^{
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
            self.layer.position = CGPointMake(self.layer.position.x, self.layer.position.y + 60);
        } completion:^(BOOL finished) {
            leftIcon.layer.opacity = 1;
            leftIcon.transform = CGAffineTransformMakeScale(0, 0);
            
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
                leftIcon.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
            }];
        }];
        
        [self performSelector:@selector(hide) withObject:nil afterDelay:_duration];
    };
    
    MozTopAlertView *lastAlert = [MozTopAlertView viewWithParentView:self.superview cur:self];
    if (lastAlert) {
        lastAlert.nextTopAlertBlock = ^{
            showBlock();
        };
        [lastAlert hide];
    }else{
        showBlock();
    }
}

- (void)hide{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    [UIView animateWithDuration:0.2 animations:^{
        self.layer.position = CGPointMake(self.layer.position.x, self.layer.position.y - 60);
    } completion:^(BOOL finished) {
        if (_nextTopAlertBlock) {
            _nextTopAlertBlock();
            _nextTopAlertBlock = nil;
        }
        [self removeFromSuperview];
    }];

    if (_dismissBlock) {
        _dismissBlock();
        _dismissBlock = nil;
    }
}

-(void)setDuration:(NSInteger)duration{
    _duration = duration;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    [self performSelector:@selector(hide) withObject:nil afterDelay:_duration];
}

-(void)setAutoHide:(BOOL)autoHide{
    if (autoHide && !_autoHide) {
        [self performSelector:@selector(hide) withObject:nil afterDelay:_duration];
    }else{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    }
    _autoHide = autoHide;
}

-(void)dealloc{
    _doBlock = nil;
    _dismissBlock = nil;
    _nextTopAlertBlock = nil;
}

@end
