//
//  EditorViewController.m
//  DeVega
//
//  Created by Admin on 5/12/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "EditorViewController.h"
#import "AttributeController.h"


@interface AttributeStateDelegateButton : NSObject<AttributeStateDelegate>
{
    UIButton *_button;
}
-(id)initWithButton:(UIButton*)button;
-(void)update:(BOOL)state;

@end


@implementation AttributeStateDelegateButton

-(id)initWithButton:(UIButton*)button
{
    self->_button = button;
    return self;
}

-(void)update:(BOOL)state
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self->_button.highlighted = state;
    }];
}

@end


@interface EditorViewController ()

//+(NSDictionary*)attributesFromTextView:(UITextView*)textView;

@end

@implementation EditorViewController{
    BoldfaceController *boldfaceController;
}

@synthesize delegate;
@synthesize textView;
@synthesize formatToolbar;
@synthesize toggleBoldfaceButton;
@synthesize toggleItalicsButton;

// TODO: extract static methods

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

+(void)applyAttributes:(NSDictionary*)attributes toTextView:(UITextView*)textView
{
    NSRange range = textView.selectedRange;
    if (range.length == 0) {
        textView.typingAttributes = attributes;
    }
    else {
        NSMutableAttributedString *modifiedString = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
        [modifiedString setAttributes:attributes range:range];
        textView.attributedText = modifiedString;
        textView.selectedRange = range;
    }
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

    [self.toggleBoldfaceButton addTarget:self action:@selector(toggleBoldface:) forControlEvents:UIControlEventTouchUpInside];

    self->boldfaceController = [BoldfaceController new];
    [self->boldfaceController setStateDelegate:[[AttributeStateDelegateButton alloc] initWithButton:toggleBoldfaceButton]];
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

    BOOL bold = !self->boldfaceController.state;
    NSDictionary *modifiedAttributes = [self->boldfaceController set:bold in:attributes];
    [EditorViewController applyAttributes:modifiedAttributes toTextView:self.textView];
}

-(void)toggleItalics:(id)sender
{
    
}

-(void)textViewDidChangeSelection:(UITextView *)sourceTextView
{
    NSDictionary *attributes = [EditorViewController attributesFromTextView:textView];
    if (attributes == nil)
        return;

    [self->boldfaceController update:attributes];
}

@end
