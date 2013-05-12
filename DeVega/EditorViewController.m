//
//  EditorViewController.m
//  DeVega
//
//  Created by Admin on 5/12/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "EditorViewController.h"

@interface EditorViewController ()

@end

@implementation EditorViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)close:(id)sender
{
    [self.delegate editorViewControllerDidClose:self];
}

-(void)save:(id)sender
{
    [self.delegate editorViewControllerDidSave:self];
}

@end
