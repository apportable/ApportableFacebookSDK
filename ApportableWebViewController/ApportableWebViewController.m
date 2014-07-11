//
//  ApportableWebViewController.m
//
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ApportableWebViewController.h"

#if !defined(ANDROID)
#warning unimplemented on non-Android platform
#else

// 2014/07/11 - requires Apportable BridgeKit 2.x
#import <BridgeKit/JavaObject.h>
#import <BridgeKit/AndroidActivity.h>

@protocol _ApportableWebDialogDelegate
- (void)overrideURL:(NSString *)url;
- (void)userClosed;
@end

@interface _ApportableWebDialog : JavaObject
@property (nonatomic, assign) id<_ApportableWebDialogDelegate> delegate;
- (id)initWithTitle:(NSString *)title URL:(NSString *)url andContext:(AndroidContext *)context;
- (void)setOverrideURLLoadingPrefix:(NSString *)prefix;
- (void)addOverrideURLLoadingPrefix:(NSString *)prefix;
- (void)show;
- (void)cancel;
@end

#pragma clang diagnostic push
// Do not warn about missing bridged methods
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation _ApportableWebDialog

@synthesize delegate = _delegate;

+ (void)initializeJava
{
    [super initializeJava];
    
    [_ApportableWebDialog registerConstructorWithSelector:@selector(initWithTitle:URL:andContext:) arguments:[NSString className], [NSString className], [AndroidContext className], NULL];
    
    [_ApportableWebDialog registerInstanceMethod:@"show" selector:@selector(show) returnValue:NULL arguments:NULL];
    
    [_ApportableWebDialog registerInstanceMethod:@"cancel" selector:@selector(cancel) returnValue:NULL arguments:NULL];
    
    [_ApportableWebDialog registerInstanceMethod:@"setOverrideURLLoadingPrefix" selector:@selector(setOverrideURLLoadingPrefix:) returnValue:NULL arguments:[NSString className], NULL];
    
    [_ApportableWebDialog registerInstanceMethod:@"addOverrideURLLoadingPrefix" selector:@selector(addOverrideURLLoadingPrefix:) returnValue:NULL arguments:[NSString className], NULL];
    
    [_ApportableWebDialog registerCallback:@"onOverrideURL" selector:@selector(onOverrideURL:) returnValue:nil arguments:[NSString className], nil];
    
    [_ApportableWebDialog registerCallback:@"onClose" selector:@selector(onUserClosed) returnValue:nil arguments:nil];
}

+ (NSString *)className
{
    return @"com.apportable.ui.ApportableWebDialog";
}

- (void)onOverrideURL:(NSString *)url
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate overrideURL:url];
    });
}

- (void)onUserClosed
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate userClosed];
    });
}

@end

#pragma clang diagnostic pop

@interface ApportableWebViewController () <_ApportableWebDialogDelegate>
@end

@implementation ApportableWebViewController {
    _ApportableWebDialog *_webView;
    NSArray *_prefixes;
    ApportableWebViewCompletionBlock _completionBlock;
}

+ (ApportableWebViewController *)webViewControllerWithTitle:(NSString *)title URL:(NSURL *)url;
{
    return [ApportableWebViewController webViewControllerWithTitle:title URL:url overrideURLLoadingPrefix:nil withCompletion:nil];
}

+ (ApportableWebViewController *)webViewControllerWithTitle:(NSString *)title URL:(NSURL *)url overrideURLLoadingPrefix:(NSString *)prefix withCompletion:(ApportableWebViewCompletionBlock)completion
{
    ApportableWebViewController *controller = [[ApportableWebViewController alloc] initWithTitle:title URL:url overrideURLLoadingPrefix:prefix withCompletion:completion];
    return [controller autorelease];
}

+ (ApportableWebViewController *)webViewControllerWithTitle:(NSString *)title URL:(NSURL *)url overrideURLLoadingPrefixes:(NSArray *)prefixes withCompletion:(ApportableWebViewCompletionBlock)completion
{
    ApportableWebViewController *controller = [[ApportableWebViewController alloc] initWithTitle:title URL:url overrideURLLoadingPrefixes:prefixes withCompletion:completion];
    return [controller autorelease];
}

- (instancetype)initWithTitle:(NSString *)title URL:(NSURL *)url;
{
    return [self initWithTitle:title URL:url overrideURLLoadingPrefixes:nil withCompletion:nil];
}

- (instancetype)initWithTitle:(NSString *)title URL:(NSURL *)url overrideURLLoadingPrefix:(NSString *)prefix withCompletion:(ApportableWebViewCompletionBlock)completion
{
    return [self initWithTitle:title URL:url overrideURLLoadingPrefixes:[NSArray arrayWithObjects:prefix, nil] withCompletion:completion];
}

- (instancetype)initWithTitle:(NSString *)title URL:(NSURL *)url overrideURLLoadingPrefixes:(NSArray *)prefixes withCompletion:(ApportableWebViewCompletionBlock)completion
{
    self = [super init];
    if (self)
    {
        _webView = [[_ApportableWebDialog alloc] initWithTitle:title URL:[url absoluteString] andContext:[AndroidActivity currentActivity]];
        _prefixes = [prefixes copy];
        for (NSString *overrideURL in _prefixes)
        {
            [_webView addOverrideURLLoadingPrefix:overrideURL];
        }
        if (!completion)
        {
            completion = ^(NSString *urlString, NSError *error) { };
        }
        _completionBlock = Block_copy(completion);
        [_webView setDelegate:self];
    }
    return self;
}

- (void)loadView
{
    UIView *fakeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 420, 300)];
    [fakeView setHidden:YES];
    [self setView:fakeView];
    [fakeView release];
}

- (instancetype)init
{
    [self release];
    return nil;
}

- (void)dealloc
{
    [_webView release];
    _webView = nil;
    [_prefixes release];
    _prefixes = nil;
    if (_completionBlock)
    {
        Block_release(_completionBlock);
    }
    _completionBlock = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Overridden UIViewController methods

- (void)viewDidAppear:(BOOL)animated
{
    [_webView show];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //[_webView cancel];
}

#pragma mark -
#pragma mark _ApportableWebDialogDelegate

- (void)overrideURL:(NSString *)url
{
    _completionBlock(url, nil);
}

- (void)userClosed
{
    NSError *error = [NSError errorWithDomain:@"ApportableWebDialog was canceled by user" code:-1 userInfo:nil];
    _completionBlock(nil, error);
}

#pragma mark -

@end

#endif // ANDROID
