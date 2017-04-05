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

@protocol MAICollectionViewLayoutProtocol
-(void)invalidateLayout;
-(void)invalidateLayoutWithContext:(id<MAICollectionViewLayoutInvalidationContextProtocol>)context;
-(void)registerClass:(nullable Class)viewClass forDecorationViewOfKind:(NSString*)elementKind;
-(void)registerNib:(nullable id<MAINibProtocol>)nib forDecorationViewOfKind:(NSString*)elementKind;
-(void)prepareLayout;
-(nullable id<MAICollectionViewLayoutAttributesProtocol>)layoutAttributesForItemAtIndexPath:(NSIndexPath*)indexPath;
-(nullable id<MAICollectionViewLayoutAttributesProtocol>)layoutAttributesForSupplementaryViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath*)indexPath;
-(nullable id<MAICollectionViewLayoutAttributesProtocol>)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath*)indexPath;
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds;
-(id<MAICollectionViewLayoutInvalidationContextProtocol>)invalidationContextForBoundsChange:(CGRect)newBounds;
-(BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes:(id<MAICollectionViewLayoutAttributesProtocol>)preferredAttributes withOriginalAttributes:(id<MAICollectionViewLayoutAttributesProtocol>)originalAttributes;
-(id<MAICollectionViewLayoutInvalidationContextProtocol>)invalidationContextForPreferredLayoutAttributes:(id<MAICollectionViewLayoutAttributesProtocol>)preferredAttributes withOriginalAttributes:(id<MAICollectionViewLayoutAttributesProtocol>)originalAttributes;
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity;
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset;
-(void)prepareForCollectionViewUpdates:(NSArray<MAICollectionViewUpdateItem*>*)updateItems;
-(void)finalizeCollectionViewUpdates;
-(void)prepareForAnimatedBoundsChange:(CGRect)oldBounds;
-(void)finalizeAnimatedBoundsChange;
-(void)prepareForTransitionToLayout:(id<MAICollectionViewLayoutProtocol>)newLayout;
-(void)prepareForTransitionFromLayout:(id<MAICollectionViewLayoutProtocol>)oldLayout;
-(void)finalizeLayoutTransition;
-(nullable id<MAICollectionViewLayoutAttributesProtocol>)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath*)itemIndexPath;
-(nullable id<MAICollectionViewLayoutAttributesProtocol>)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath*)itemIndexPath;
-(nullable id<MAICollectionViewLayoutAttributesProtocol>)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath*)elementIndexPath;
-(nullable id<MAICollectionViewLayoutAttributesProtocol>)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath*)elementIndexPath;
-(nullable id<MAICollectionViewLayoutAttributesProtocol>)initialLayoutAttributesForAppearingDecorationElementOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath*)decorationIndexPath;
-(nullable id<MAICollectionViewLayoutAttributesProtocol>)finalLayoutAttributesForDisappearingDecorationElementOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath*)decorationIndexPath;
@property(readonly, nullable, getter=collectionView) id<MAICollectionViewProtocol> collectionView;

#if TARGET_OS_IPHONE
-(instancetype)init NS_UNAVAILABLE;
-(nullable instancetype)initWithCoder:(NSCoder*)aDecoder NS_UNAVAILABLE;
+(Class)layoutAttributesClass NS_UNAVAILABLE;
+(Class)invalidationContextClass NS_UNAVAILABLE;
#else
#endif

@end

#if TARGET_OS_IPHONE
@interface MAICollectionViewLayout : UICollectionViewLayout<MAICollectionViewLayoutProtocol>
#else
@interface MAICollectionViewLayout : NSCollectionViewLayout<MAICollectionViewLayoutProtocol>
#endif
@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
