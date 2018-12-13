//
//  RoundTextField.m
//  Foodboon
//
//  Created by Exarcplus iOS 1 on 22/09/16.
//  Copyright © 2016 index. All rights reserved.
//

#import "RoundTextField.h"


@implementation RoundTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupDefaults
{
    [self layoutIfNeeded];
    if (riconView == nil)
    {
        riconView = [[UIView alloc]initWithFrame:CGRectMake(0,0,34,self.frame.size.height)];
        riconIView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,22,22)];
        riconIView.center = CGPointMake(riconView.frame.size.width/2, riconView.frame.size.height/2);
        [riconView addSubview:riconIView];
        //riconView.backgroundColor = [UIColor redColor];
        self.rightViewMode = UITextFieldViewModeAlways;
    }
    
    if (liconView == nil)
    {
        liconView = [[UIView alloc]initWithFrame:CGRectMake(0,0,34,self.frame.size.height)];
        liconIView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,22,22)];
        liconIView.center = CGPointMake(liconView.frame.size.width/2, liconView.frame.size.height/2);
        [liconView addSubview:liconIView];
        //liconView.backgroundColor = [UIColor redColor];
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    [self setNeedsDisplay];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}
-(void)setBorderWidth:(CGFloat)BorderWidth
{
    [self layoutIfNeeded];
    self.layer.borderWidth = BorderWidth;
    [self setNeedsDisplay];
}
-(void)setBorderColor:(UIColor *)BorderColor
{
    [self layoutIfNeeded];
    _BorderColor = BorderColor;
    [self setNeedsDisplay];
}
-(void)setErrorcolor:(UIColor *)Errorcolor
{
    [self layoutIfNeeded];
    _Errorcolor = Errorcolor;
    [self setNeedsDisplay];
}
-(void)setMaskToBounds:(BOOL)MaskToBounds
{
    [self layoutIfNeeded];
    self.layer.masksToBounds = MaskToBounds;
    [self setNeedsDisplay];
}
-(void)setRound:(BOOL)Round
{
    [self layoutIfNeeded];
    _Round = Round;
    if (Round == YES)
    {
        self.layer.cornerRadius = self.frame.size.height/2;
    }
    else
    {
        self.layer.cornerRadius = _CornerRadius;
    }
    [self setNeedsDisplay];
}
-(void)setCornerRadius:(CGFloat)CornerRadius
{
    [self layoutIfNeeded];
    _CornerRadius = CornerRadius;
    if (_Round == YES)
    {
        self.layer.cornerRadius = self.frame.size.height/2;
    }
    else
    {
        self.layer.cornerRadius = _CornerRadius;
    }
    [self setNeedsDisplay];
}


-(void)setRIcon:(BOOL)rIcon
{
    [self layoutIfNeeded];
    if (rIcon == YES)
    {
        self.rightView = riconView;
    }
    else
    {
        self.rightView = [[UIView alloc]initWithFrame:CGRectMake(0,0,12, self.frame.size.height)];
    }
    [self setNeedsDisplay];
}
-(void)setRIconImage:(UIImage *)rIconImage
{
    [self layoutIfNeeded];
    riconIView.image = rIconImage;
    [self setNeedsDisplay];
}
-(void)setLIcon:(BOOL)lIcon
{
    [self layoutIfNeeded];
    if (lIcon == YES)
    {
        self.leftView = liconView;
    }
    else
    {
        liconView.hidden = YES;
        self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0,0,12, self.frame.size.height)];
    }
    [self setNeedsDisplay];
}

-(void)setLIconImage:(UIImage *)lIconImage
{
    [self layoutIfNeeded];
    liconIView.image = lIconImage;
    [self setNeedsDisplay];
}
-(void)setPlaceholderColor:(UIColor *)PlaceholderColor
{
    [self layoutIfNeeded];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:PlaceholderColor}];
    [self setNeedsDisplay];
}
-(void)setHasError:(BOOL)HasError
{
    [self layoutIfNeeded];
    _HasError = HasError;
    if (HasError == YES)
    {
        self.layer.borderColor = _Errorcolor.CGColor;
    }
    else
    {
        self.layer.borderColor = _BorderColor.CGColor;
    }
    [self setNeedsDisplay];
}

@end
