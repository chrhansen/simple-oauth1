//
//  ViewController.h
//  Simple-OAuth1
//
//  Created by Christian Hansen on 02/12/12.
//  Copyright (c) 2012 Christian-Hansen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *accessTokenLabel;
@property (weak, nonatomic) IBOutlet UILabel *accessTokenSecretLabel;
@property (weak, nonatomic) IBOutlet UITextView *responseTextView;

@end
