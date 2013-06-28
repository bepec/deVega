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
@end

@implementation EditorViewController{
    BoldfaceController *boldfaceController;
}

@synthesize delegate;
@synthesize textView;
@synthesize formatToolbar;
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
    self->boldfaceController = [BoldfaceController new];
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

-(void)toggleBoldface:(id)sender
{
    BOOL bold = self.toggleBoldfaceButton.highlighted;
    bold = !bold;
    self.toggleBoldfaceButton.highlighted = bold;
    BOOL newState = self.toggleBoldfaceButton.highlighted;
    NSRange range = textView.selectedRange;
    
    NSDictionary *attributes = nil;
    if (range.length == 0) {
        attributes = self.textView.typingAttributes;
    }
    else {
        attributes = [self.textView.attributedText attributesAtIndex:range.location
                                                      effectiveRange:nil];
    }
    
    NSDictionary *modifiedAttributes = [boldfaceController set:bold in:attributes];

    if (range.length == 0) {
        self.textView.typingAttributes = modifiedAttributes;
    }
    else {
        NSMutableAttributedString *modifiedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
        [modifiedString setAttributes:modifiedAttributes range:range];
        self.textView.attributedText = modifiedString;
    }
}

-(void)toggleItalics:(id)sender
{
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{

}

@end
