#import "Cedar.h"
#import "UIApplication+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

@implementation CedarApplicationDelegate (Actions)

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
}

@end

@implementation UIApplicationShortcutItem (Equatable)

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if(![other isKindOfClass:[self class]]){
        return NO;
    } else {
        UIApplicationShortcutItem *otherItem = (UIApplicationShortcutItem
                                                *)other;
        
        return ([self.type isEqualToString:otherItem.type] || self.type == otherItem.type) &&
        ([self.localizedTitle isEqualToString:otherItem.localizedTitle] || self.localizedTitle == otherItem.localizedTitle) &&
        ([self.localizedSubtitle isEqualToString:otherItem.localizedSubtitle] || self.localizedSubtitle == otherItem.localizedSubtitle);
    }
}

- (NSUInteger)hash
{
    return [self.type hash] ^ [self.localizedTitle hash] ^ [self.localizedSubtitle hash];
}

@end

SPEC_BEGIN(UIApplicationSpecSpec)

describe(@"UIApplication (spec extensions)", ^{
    
    it(@"should have a test host", ^{
        [UIApplication sharedApplication] should_not be_nil;
    });

    describe(@"- openURL:", ^{
        __block NSURL *url;
        
        beforeEach(^{
            url = [NSURL URLWithString:@"http://example.com/xyzzy"];
            
            [[UIApplication sharedApplication] openURL:url];
        });

        it(@"should record the last URL", ^{
            [UIApplication lastOpenedURL] should equal(url);
        });

        describe(@"when -reset is called", ^{
            beforeEach(^{
                [UIApplication reset];
            });
            it(@"should no longer keeps track of opened URLs", ^{
                [UIApplication lastOpenedURL] should be_nil;
            });
        });
    });
    
    describe(@"home screen shortcuts", ^{
        __block id<UIApplicationDelegate> appDelegate;
        __block UIApplicationShortcutItem *shortcutItem1, *shortcutItem2;
        
        beforeEach(^{
            shortcutItem1 = [[UIApplicationShortcutItem alloc] initWithType:@"ShortcutType1" localizedTitle:@"Shortcut1"];
            shortcutItem2 = [[UIApplicationShortcutItem alloc] initWithType:@"ShortcutType2" localizedTitle:@"Shortcut2"];
            
            [UIApplication sharedApplication].shortcutItems = @[shortcutItem1, shortcutItem2];
            
            appDelegate = [UIApplication sharedApplication].delegate;
            
            spy_on(appDelegate);
        });
        
        afterEach(^{
            stop_spying_on(appDelegate);
        });
        
        context(@"tapping by index", ^{
            it(@"when index is greater than amount of shortcuts should raise exception", ^{
                ^{
                    [[UIApplication sharedApplication] tapHomeScreenShortcutAtIndex:2];
                } should raise_exception.with_reason(@"Shortcut does not exist at specified index");
            });
            
            it(@"should trigger delegate call when index exists", ^{
                [[UIApplication sharedApplication] tapHomeScreenShortcutAtIndex:0];
                
                appDelegate should have_received(@selector(application:performActionForShortcutItem:completionHandler:)).with([UIApplication sharedApplication], shortcutItem1, Arguments::anything);
            });
        });
        
        context(@"tapping by title", ^{
            it(@"when title does not exist should raise exception", ^{
                ^{
                    [[UIApplication sharedApplication] tapHomeScreenShortcutWithLocalizedTitle:@"Shortcut3"];
                } should raise_exception.with_reason(@"Can't find shortcut with specified localized title");
            });
            
            it(@"should trigger delegate call when title exists", ^{
                [[UIApplication sharedApplication] tapHomeScreenShortcutWithLocalizedTitle:@"Shortcut2"];
                
                appDelegate should have_received(@selector(application:performActionForShortcutItem:completionHandler:)).with([UIApplication sharedApplication], shortcutItem2, Arguments::anything);
            });
        });
    });
});

SPEC_END
