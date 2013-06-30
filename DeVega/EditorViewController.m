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

+(NSDictionary*)attributesFromTextView:(UITextView*)textView;
+(void)highlightButton:(UIButton*)button withValue:(BOOL)highlighted;

@end

@implementation EditorViewController{
    BoldfaceController *boldfaceController;
}

@synthesize delegate;
@synthesize textView;
@synthesize formatToolbar;
@synthesize toggleBoldfaceButton;
@synthesize toggleItalicsButton;

+(NSDictionary*)attributesFromTextView:(UITextView*)textView
{
    NSRange range = textView.selectedRange;
    if (range.location == NSNotFound) {
        return nil;
    }
    else if (range.length == 0) {
        return textView.typingAttributes;
    }
    else {
        return [textView.attributedText attributesAtIndex:range.location
                                           effectiveRange:nil];
    }
}

+(void)highlightButton:(UIButton*)button withValue:(BOOL)highlighted
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        button.highlighted = highlighted;
    }];
}

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
    NSDictionary *attributes = [EditorViewController attributesFromTextView:textView];
    if (attributes == nil)
        return;

    NSRange range = textView.selectedRange;
    BOOL bold = !self.toggleBoldfaceButton.selected;
    self.toggleBoldfaceButton.selected = bold;
    [EditorViewController highlightButton:toggleBoldfaceButton withValue:bold];

    NSDictionary *modifiedAttributes = [self->boldfaceController set:bold in:attributes];

    if (range.length == 0) {
        self.textView.typingAttributes = modifiedAttributes;
    }
    else {
        NSMutableAttributedString *modifiedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
        [modifiedString setAttributes:modifiedAttributes range:range];
        self.textView.attributedText = modifiedString;
        self.textView.selectedRange = range;
    }
}

-(void)toggleItalics:(id)sender
{
    
}

-(void)textViewDidChangeSelection:(UITextView *)sourceTextView
{
    NSDictionary *attributes = [EditorViewController attributesFromTextView:textView];
    if (attributes == nil)
        return;

    [self->boldfaceController update:attributes callback:^(BoldfaceController *sender) {
        toggleBoldfaceButton.selected = sender.state;
        [EditorViewController highlightButton:toggleBoldfaceButton withValue:sender.state];
    }];
}

@end
