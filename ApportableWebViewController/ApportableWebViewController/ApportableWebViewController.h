//
//  ApportableWebViewController.h
//
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <UIKit/UIViewController.h>

typedef void (^ApportableWebViewCompletionBlock)(NSString *urlString, NSError *error);

/*!
 @discussion    ApportableWebViewController is an Apportable-specific subclass of UIViewController.
 Its intended use is to present an Android dialog with WebView content.  Set the url property
 and call [parentViewController presentViewController:animated:completion:] with an object of
 this class to present the web view.
 */

@interface ApportableWebViewController : UIViewController

/*!
 @method        +webViewControllerWithTitle:URL:
 @abstract      Get an instance of an ApportableWebViewController.
 @param         title    an NSString title of the web dialog
 @param         url      an NSURL to load
 @result        an ApportableWebViewController.
 */
+ (ApportableWebViewController *)webViewControllerWithTitle:(NSString *)title URL:(NSURL *)url;

/*!
 @method        +webViewControllerWithTitle:URL:overrideURLLoadingPrefix:withCompletion:
 @abstract      Get an instance of an ApportableWebViewController that will invoke a completion block upon being requested to
 open a URL matching a particular prefix
 @param         title    an NSString title of the web dialog
 @param         url      an NSURL to load
 @param         prefix   an NSString URL prefix
 @param         completion    a block to invoke when a URL loading prefix is encountered
 @result        an ApportableWebViewController.
 @note          This ApportableWebViewController will automatically close when it encounters a matching prefix
 @note          If no prefix is found, completion block will not be invoked
 */
+ (ApportableWebViewController *)webViewControllerWithTitle:(NSString *)title URL:(NSURL *)url overrideURLLoadingPrefix:(NSString *)prefix withCompletion:(ApportableWebViewCompletionBlock)completion;

/*!
 @method        +webViewControllerWithTitle:URL:overrideURLLoadingPrefixes:withCompletion:
 @abstract      Get an instance of an ApportableWebViewController that will invoke a completion block upon being requested to
 open a URL matching any of a list of prefixes
 @param         title    an NSString title of the web dialog
 @param         url      an NSURL to load
 @param         prefixes an NSArray of NSString prefixes
 @param         completion    a block to invoke when a URL loading prefix is encountered
 @result        an ApportableWebViewController.
 @note          This ApportableWebViewController will automatically close when it encounters a matching prefix
 @note          If no prefix is found, completion block will not be invoked
 */
+ (ApportableWebViewController *)webViewControllerWithTitle:(NSString *)title URL:(NSURL *)url overrideURLLoadingPrefixes:(NSArray *)prefixes withCompletion:(ApportableWebViewCompletionBlock)completion;

/*!
 @method        -initWithTitle:URL:
 @abstract      Constructor to create an ApportableWebViewController.
 @param         title    an NSString title of the web dialog
 @param         url      an NSURL to load
 @result        an ApportableWebViewController.
 */
- (instancetype)initWithTitle:(NSString *)title URL:(NSURL *)url;

/*!
 @method        -initWithTitle:URL:overrideURLLoadingPrefix:withCompletion:
 @abstract      Get an instance of an ApportableWebViewController that will invoke a completion block upon being requested to
 open a URL matching a particular prefix
 @param         title    an NSString title of the web dialog
 @param         url      an NSURL to load
 @param         prefix   an NSString URL prefix
 @param         completion    a block to invoke when a URL loading prefix is encountered
 @result        an ApportableWebViewController.
 @note          This ApportableWebViewController will automatically close when it encounters a matching prefix
 @note          If no prefix is found, completion block will not be invoked
 */
- (instancetype)initWithTitle:(NSString *)title URL:(NSURL *)url overrideURLLoadingPrefix:(NSString *)prefix withCompletion:(ApportableWebViewCompletionBlock)completion;

@end
