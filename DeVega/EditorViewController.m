//
//  EditorViewController.m
//  DeVega
//
//  Created by Admin on 5/12/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "EditorViewController.h"
#import "AttributeController.h"


@interface EditorViewController ()
{
//    AttributeController *boldfaceController;
    NSSet *attributeControllers;
    id<AttributeListController> attributeListController;
}

@end

@implementation EditorViewController{
}

@synthesize delegate;
@synthesize textView;
@synthesize toggleBoldfaceButton;
@synthesize toggleItalicsButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.textView.delegate = self;
    
    self->attributeListController = (id<AttributeListController>)[[AttributeListControllerTextView alloc] initWithTextView:self.textView];
    
    AttributeController *boldfaceController = [AttributeController createBoldfaceController];
    boldfaceController.attributeListController = (id<AttributeListController>)self->attributeListController;
    boldfaceController.delegate = [AttributeControllerDelegateFactory delegateWithButton:toggleBoldfaceButton andBlock:^{ [boldfaceController setAttributeState:!boldfaceController.state]; }];

    AttributeController *italicsController = [AttributeController createItalicsController];
    italicsController.attributeListController = (id<AttributeListController>)self->attributeListController;
    italicsController.delegate = [AttributeControllerDelegateFactory delegateWithButton:toggleItalicsButton andBlock:^{ [italicsController setAttributeState:!italicsController.state]; }];
    
    self->attributeControllers = [NSSet setWithObjects:boldfaceController, italicsController, nil];
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

-(void)textViewDidChangeSelection:(UITextView *)sourceTextView
{
    [self->attributeListController notifySubscribers];
}

@end
