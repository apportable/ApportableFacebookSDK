//
//  RootViewController.m
//  AWVCExample
//
//  Created by Aaron Culliney on 7/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "RootViewController.h"

#ifdef ANDROID
#import "ApportableWebViewController.h"
#endif

@interface RootViewController ()

#ifdef ANDROID
@property (nonatomic, retain) ApportableWebViewController *awvc;
#endif

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
#ifdef ANDROID
    self.awvc = nil;
#endif
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
#ifdef ANDROID
    self.awvc = [ApportableWebViewController webViewControllerWithTitle:nil URL:[NSURL URLWithString:@"https://www.apportable.com/"] overrideURLLoadingPrefix:@"https://www.apportable.com/contact" withCompletion:^(NSString *urlString, NSError *error) {
        
        NSLog(@"returned from a WebDialog with urlString:%@ error:%@", urlString, error);
        
    }];
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:self.awvc animated:YES completion:^{
        NSLog(@"presented a WebDialog");
    }];
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
