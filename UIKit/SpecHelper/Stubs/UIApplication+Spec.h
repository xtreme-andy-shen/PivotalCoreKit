#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (Spec)

+ (nullable NSURL *)lastOpenedURL;
+ (void)reset;

- (void)tapHomeScreenShortcutAtIndex:(NSUInteger)index;
- (void)tapHomeScreenShortcutWithLocalizedTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
