#import "UIApplication+Spec.h"
#import <objc/runtime.h>

static NSString *exceptionName = @"Untappable";
static NSString *cannotBeFoundExceptionReason = @"Can't find shortcut with specified localized title";
static NSString *indexOutOfBoundsExceptionReason = @"Shortcut does not exist at specified index";

@implementation UIApplication (Spec)

static NSMutableArray<NSURL *> *URLs = nil;
static NSMutableArray<UIApplicationShortcutItem *> *shortCutItems = nil;

+ (void)load {
    URLs = [NSMutableArray array];
    shortCutItems = [NSMutableArray array];
    id cedarHooksProtocol = NSProtocolFromString(@"CDRHooks");
    if (cedarHooksProtocol) {
        class_addProtocol(self, cedarHooksProtocol);
    }
}

+ (void)afterEach {
    [self reset];
}

+ (void)reset {
    [URLs removeAllObjects];
}

+ (NSURL *)lastOpenedURL {
    return [URLs lastObject];
}

- (void)tapHomeScreenShortcutAtIndex:(NSUInteger)index {
    if(index >= self.shortcutItems.count) {
        [[NSException exceptionWithName:exceptionName
                                 reason:indexOutOfBoundsExceptionReason
                               userInfo:nil] raise];
    }
    
    UIApplicationShortcutItem *shortcutItem = [self.shortcutItems objectAtIndex:index];
    
    [self.delegate application:self
  performActionForShortcutItem:shortcutItem
             completionHandler:^(BOOL succeeded) {
                 
             }];
}

- (void)tapHomeScreenShortcutWithLocalizedTitle:(NSString *)title {
    UIApplicationShortcutItem *foundShortCutItem;
    
    for(UIApplicationShortcutItem *shortCutItem in self.shortcutItems) {
        if([shortCutItem.localizedTitle isEqualToString:title]) {
            foundShortCutItem = shortCutItem;
            break;
        }
    }
    
    if(!foundShortCutItem) {
        [[NSException exceptionWithName:exceptionName
                                 reason:cannotBeFoundExceptionReason
                               userInfo:nil] raise];
    }
    
    [self.delegate application:self
  performActionForShortcutItem:foundShortCutItem
             completionHandler:^(BOOL succeeded) {
                 
             }];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)openURL:(NSURL *)url {
    [URLs addObject:url];
}

#pragma clang diagnostic pop

@end
