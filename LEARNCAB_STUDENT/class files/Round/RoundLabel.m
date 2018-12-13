//
//  RoundLabel.m
//  MyCarzy
//
//  Created by Exarcplus iOS 1 on 13/10/16.
//  Copyright © 2016 exarcplus. All rights reserved.
//

#import "RoundLabel.h"

@implementation RoundLabel

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
        self.layer.cornerRadius = _Radius;
    }
    [self setNeedsDisplay];
}
-(void)setRadius:(CGFloat)Radius
{
    [self layoutIfNeeded];
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
