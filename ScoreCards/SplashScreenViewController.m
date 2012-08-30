//
//  SplashScreenViewController.m
//  ScoreCards
//
//  Created by Ryan Zulkoski on 8/30/12.
//  Copyright (c) 2012 RZGamer. All rights reserved.
//

#import "SplashScreenViewController.h"

@interface SplashScreenViewController ()

@property (strong, nonatomic) IBOutlet UIButton *splashScreenButton;

@end

@implementation SplashScreenViewController
@synthesize splashScreenButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)enterAppView {
    [self performSegueWithIdentifier:@"enterApp" sender:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[UIScreen mainScreen] scale] == 1.0) [splashScreenButton setImage:[UIImage imageNamed:@"Default.png"] forState:UIControlStateNormal];
    [self performSelector:@selector(enterAppView) withObject:nil afterDelay:2];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setSplashScreenButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
