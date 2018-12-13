//
//  RoundView.m
//  AGF
//
//  Created by Exarcplus iOS 1 on 14/09/16.
//  Copyright © 2016 Exarplus. All rights reserved.
//

#import "RoundImageView.h"

@implementation RoundImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)setBorderWidth:(CGFloat)BorderWidth
{
    [self layoutIfNeeded];
    self.layer.borderWidth = BorderWidth;
    [self setNeedsDisplay];
}
-(void)setBorderColor:(UIColor *)BorderColor
{
    [self layoutIfNeeded];
    self.layer.borderColor = [BorderColor CGColor];
}
-(void)setMaskToBounds:(BOOL)MaskToBounds
{
    [self layoutIfNeeded];
    self.layer.masksToBounds = MaskToBounds;
    [self setNeedsDisplay];
}

-(void)setRound:(BOOL)Round
{
    _Round = Round;
    if (Round == YES)
    {
        self.layer.cornerRadius = self.frame.size.height/2;
    }
    else
    {
        self.layer.cornerRadius = _Radius;
    }
    [self setNeedsDisplay];
}
-(void)setRadius:(CGFloat)Radius
{
    _Radius = Radius;
    if (_Round == YES)
    {
        self.layer.cornerRadius = self.frame.size.height/2;
    }
    else
    {
        self.layer.cornerRadius = _Radius;
    }
    [self setNeedsDisplay];
}


@end
