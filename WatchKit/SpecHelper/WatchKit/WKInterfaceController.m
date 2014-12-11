#import "WKInterfaceController.h"
#import "InterfaceControllerLoader.h"


@interface WKInterfaceController ()

@property (nonatomic) WKInterfaceController *childController;
@property (nonatomic) InterfaceControllerLoader *loader;

@end


@implementation WKInterfaceController

-(instancetype)initWithContext:(id)context {
    self = [super init];
    if (self) {
        self.loader = [[InterfaceControllerLoader alloc] init];
    }
    return self;
}

- (void)willActivate
{
    
}

- (void)didDeactivate
{
    
}

- (void)pushControllerWithName:(NSString *)name context:(id)context
{
    self.childController = [self.loader interfaceControllerWithStoryboardName:@"Interface" identifier:name context:nil];
}

@end

