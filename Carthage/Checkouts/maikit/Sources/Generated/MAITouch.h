#import <TargetConditionals.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-no-attribute"

#if TARGET_OS_IPHONE
@import UIKit;
#else
@import AppKit;
#endif

#import "MAIEnums.h"
#import "MAIDeclarations.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MAITouchProtocol
-(CGPoint)locationInView:(nullable id<MAIViewProtocol>)view;
-(CGPoint)previousLocationInView:(nullable id<MAIViewProtocol>)view;
@property(readonly, getter=type) MAITouchType type;

#if TARGET_OS_IPHONE
#else
#endif

@end

#if TARGET_OS_IPHONE
@interface MAITouch : UITouch<MAITouchProtocol>
#else
@interface MAITouch : NSTouch<MAITouchProtocol>
#endif
@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
