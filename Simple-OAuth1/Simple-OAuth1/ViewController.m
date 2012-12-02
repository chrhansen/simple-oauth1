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
                     completion:
     ^{
         self.oauth1Controller = [[OAuth1Controller alloc] init];
         [self.oauth1Controller loginWithWebView:loginWebViewController.webView completion:^(NSDictionary *oauthTokens, NSError *error)
          {
              if (!error)
              {
                  NSLog(@"Authentication success: %@", oauthTokens);
                  // Store your tokens for later authenticating your later requests
                  // Consider storing the tokens in the Keychain
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



- (IBAction)testRequest
{
    // TODO: set correct path
    NSString *path = @"people/~";
    NSDictionary *parameters = @{@"format" : @"json"};
    
    // Build authorized request based on path, parameters, tokens, timestamp etc.
    NSMutableURLRequest *preparedRequest = [OAuth1Controller preparedRequestForPath:path
                                                                         parameters:parameters
                                                                         HTTPmethod:@"GET"
                                                                         oauthToken:self.oauthToken
                                                                        oauthSecret:self.oauthTokenSecret];
    
    // Send the request and log response when received
    [NSURLConnection sendAsynchronousRequest:preparedRequest
                                       queue:NSOperationQueue.mainQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             self.responseTextView.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             if (error) {
                 NSLog(@"Error in API request: %@", error.localizedDescription);
             }
         });
     }];
}

@end
