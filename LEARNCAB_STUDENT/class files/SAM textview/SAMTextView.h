//
//  SAMTextView.h
//  SAMTextView
//
//  Created by Sam Soffes on 8/18/10.
//  Copyright 2010-2014 Sam Soffes. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MBAutoGrowingTextView;
/**
 UITextView subclass that adds placeholder support like UITextField has.
 */
IB_DESIGNABLE
@interface SAMTextView : UITextView

/**
 The string that is displayed when there is no other text in the text view. This property reads and writes the
 attributed variant.

 The default value is `nil`.
 */
@property (null_unspecified, nonatomic) IBInspectable NSString *PlaceHolder;
@property (null_unspecified, nonatomic) IBInspectable UIColor *PlaceholderColor;
@property (nonatomic) IBInspectable CGFloat BorderWidth;
@property (null_unspecified, nonatomic) IBInspectable UIColor *BorderColor;
@property (null_unspecified, nonatomic) IBInspectable UIColor *Errorcolor;
@property (nonatomic) IBInspectable BOOL HasError;
@property (nonatomic, assign) IBInspectable CGFloat CornerRadius;
@property (nonatomic) IBInspectable BOOL MaskToBounds;
/**
 The attributed string that is displayed when there is no other text in the text view.

 The default value is `nil`.
 */
@property (null_unspecified, nonatomic) NSAttributedString *attributedPlaceholder;


/**
 Returns the drawing rectangle for the text views’s placeholder text.

 @param bounds The bounding rectangle of the receiver.
 @return The computed drawing rectangle for the placeholder text.
 */
- (CGRect)placeholderRectForBounds:(CGRect)bounds;

@end
