//
//  RoundView.h
//
//  Created by Exarcplus iOS 1 on 14/09/16.
//  Copyright © 2016 Exarplus. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface RoundView : UIView
@property (nonatomic, assign) IBInspectable CGFloat BorderWidth;
@property (nonatomic, assign) IBInspectable UIColor *BorderColor;
@property (nonatomic, assign) IBInspectable BOOL MaskToBounds;
@property (nonatomic, assign) IBInspectable BOOL Round;
@property (nonatomic, assign) IBInspectable CGFloat Radius;
@end
