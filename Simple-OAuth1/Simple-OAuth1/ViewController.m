//
//  ViewController.m
//  Simple-OAuth1
//
//  Created by Christian Hansen on 02/12/12.
//  Copyright (c) 2012 Christian-Hansen. All rights reserved.
//

#import "ViewController.h"
#import "OAuth1Controller.h"
#import "LoginWebViewController.h"

@interface ViewController ()

@property (nonatomic, strong) OAuth1Controller *oauth1Controller;
@property (nonatomic, strong) NSString *oauthToken;
@property (nonatomic, strong) NSString *oauthTokenSecret;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginTapped:(id)sender
{
    LoginWebViewController *loginWebViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginWebViewController"];
    
    [self presentViewController:loginWebViewController
                       animated:YES
                     completion:^{
                         [self.oauth1Controller loginWithWebView:loginWebViewController.webView completion:^(NSDictionary *oauthTokens, NSError *error) {
                             if (!error)
                             {
                                 // Store your tokens for later authenticating your later requests, consider storing the tokens in the Keychain
                                 
                                 self.oauthToken = oauthTokens[@"oauth_token"];
                                 self.oauthTokenSecret = oauthTokens[@"oauth_token_secret"];
                                 
                                 self.accessTokenLabel.text = self.oauthToken;
                                 self.accessTokenSecretLabel.text = self.oauthTokenSecret;
                             }
                             else
                             {
                                 NSLog(@"Error authenticating: %@", error.localizedDescription);
                             }
                             [self dismissViewControllerAnimated:YES completion:
                              ^{
                                  self.oauth1Controller = nil;
                              }];
                         }];
                     }];
}


- (OAuth1Controller *)oauth1Controller
{
    if (_oauth1Controller == nil) {
        _oauth1Controller = [[OAuth1Controller alloc] init];
    }
    return _oauth1Controller;
}


- (IBAction)testGETRequest
{
    // Tumblr GET Request
    
    NSString *path = @"blog/chrhansen.tumblr.com/info";                 // Insert your Tumblr name here
    NSDictionary *parameters = @{@"api_key" : @"CONSUMER_KEY"};         // Insert your Tumblr API-key/CONSUMER_KEY here
    
    
    // LinkedIn GET Request
    
//    NSString *path = @"people/~";
//    NSDictionary *parameters = @{@"format" : @"json"};
    
    
    // Build authorized request based on path, parameters, tokens, timestamp etc.
    NSURLRequest *preparedRequest = [OAuth1Controller preparedRequestForPath:path
                                                                  parameters:parameters
                                                                  HTTPmethod:@"GET"
                                                                  oauthToken:self.oauthToken
                                                                 oauthSecret:self.oauthTokenSecret];
    
    // Send the request and log response when received
    [NSURLConnection sendAsynchronousRequest:preparedRequest
                                       queue:NSOperationQueue.mainQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   self.responseTextView.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   
                                   if (error) NSLog(@"Error in API request: %@", error.localizedDescription);
                               });
                           }];
}


- (IBAction)testPOSTRequest
{
    // Tumblr Get Request
    NSString *path = @"blog/YOUR_TUMBLR_NAME.tumblr.com/post";            // set your Tumblr name here
    NSDictionary *parameters = @{@"type"  : @"text",
                                 @"title" : @"Simple OAuth1.0a for iOS by Christian Hansen",
                                 @"body"  : @"https://github.com/Christian-Hansen/simple-oauth1"};
    
    // Build authorized request based on path, parameters, tokens, timestamp etc.
    NSURLRequest *preparedRequest = [OAuth1Controller preparedRequestForPath:path
                                                                  parameters:parameters
                                                                  HTTPmethod:@"POST"
                                                                  oauthToken:self.oauthToken
                                                                 oauthSecret:self.oauthTokenSecret];
    
    // Send the request and log response when received
    [NSURLConnection sendAsynchronousRequest:preparedRequest
                                       queue:NSOperationQueue.mainQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   self.responseTextView.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   
                                   if (error) NSLog(@"Error in API request: %@", error.localizedDescription);
                               });
                           }];
}

@end
