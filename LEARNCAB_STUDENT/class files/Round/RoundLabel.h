//
//  RoundLabel.h
//
//  Created by Exarcplus iOS 1 on 13/10/16.
//  Copyright © 2016 exarcplus. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface RoundLabel : UILabel
@property (nonatomic, assign) IBInspectable CGFloat BorderWidth;
@property (nonatomic, assign) IBInspectable UIColor *BorderColor;
@property (nonatomic, assign) IBInspectable BOOL MaskToBounds;
@property (nonatomic, assign) IBInspectable BOOL Round;
@property (nonatomic, assign) IBInspectable CGFloat Radius;
@end
