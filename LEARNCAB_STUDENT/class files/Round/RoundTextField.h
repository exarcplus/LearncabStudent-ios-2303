//
//  RoundTextField.h
//
//  Created by Exarcplus iOS 1 on 22/09/16.
//  Copyright © 2016 index. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoundTextField;
@protocol CustomTextFieldDelegate <NSObject>
@optional
- (BOOL)textFieldShouldBeginEditing:(RoundTextField *)textField;        // return NO to disallow editing.
- (void)textFieldDidBeginEditing:(RoundTextField *)textField;           // became first responder
- (BOOL)textFieldShouldEndEditing:(RoundTextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(RoundTextField *)textField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

- (BOOL)textField:(RoundTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text

- (BOOL)textFieldShouldClear:(RoundTextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)

- (BOOL)textFieldShouldReturn:(RoundTextField *)textField;              // called when 'return' key pressed. return NO to ignore.

@end
IB_DESIGNABLE
@interface RoundTextField : UITextField
{
    UIView *liconView;
    UIView *riconView;
    UIImageView *liconIView;
    UIImageView *riconIView;
}
@property (nonatomic, assign) IBInspectable BOOL Round;
@property (nonatomic, assign) IBInspectable CGFloat BorderWidth;
@property (nonatomic, assign) IBInspectable UIColor *BorderColor;
@property (nonatomic, assign) IBInspectable CGFloat CornerRadius;
@property (nonatomic, assign) IBInspectable BOOL MaskToBounds;
@property (nonatomic, assign) IBInspectable BOOL rIcon;
@property (nonatomic, assign) IBInspectable UIImage *rIconImage;
@property (nonatomic, assign) IBInspectable BOOL lIcon;
@property (nonatomic, assign) IBInspectable UIImage *lIconImage;
@property (nonatomic, assign) IBInspectable UIColor *PlaceholderColor;
@property (null_unspecified, nonatomic) IBInspectable UIColor *Errorcolor;
@property (nonatomic) IBInspectable BOOL HasError;
@property(nonatomic, weak) id<CustomTextFieldDelegate> delegate;
@end
