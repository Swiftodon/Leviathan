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

@protocol MAICollectionViewLayoutInvalidationContextProtocol
@property(readonly, getter=invalidateEverything) BOOL invalidateEverything;
@property(readonly, getter=invalidateDataSourceCounts) BOOL invalidateDataSourceCounts;
@property(setter=setContentOffsetAdjustment:, getter=contentOffsetAdjustment) CGPoint contentOffsetAdjustment;

#if TARGET_OS_IPHONE
#else
#endif

@end

#if TARGET_OS_IPHONE
@interface MAICollectionViewLayoutInvalidationContext : UICollectionViewLayoutInvalidationContext<MAICollectionViewLayoutInvalidationContextProtocol>
#else
@interface MAICollectionViewLayoutInvalidationContext : NSCollectionViewLayoutInvalidationContext<MAICollectionViewLayoutInvalidationContextProtocol>
#endif
@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
