//
//  EditorViewController.m
//  DeVega
//
//  Created by Admin on 5/12/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "EditorViewController.h"
#import "AttributeController.h"
#import "AttributeControllerDelegate.h"
#import "AttributeListController.h"
#import "AttributedStringBuilder.h"


@interface EditorViewController ()
{
    NSSet *_attributeControllers;
    id<AttributeListController> _attributeListController;
}

@end

@implementation EditorViewController

@synthesize textView;
@synthesize toggleBoldfaceButton;
@synthesize toggleItalicsButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    textView.delegate = self;
    
    _attributeListController = (id<AttributeListController>)[[AttributeListControllerTextView alloc] initWithTextView:textView];
    
    AttributeController *boldfaceController = [AttributeController createBoldfaceController];
    boldfaceController.attributeListController = (id<AttributeListController>)_attributeListController;
    boldfaceController.delegate = [AttributeControllerDelegateFactory delegateWithButton:toggleBoldfaceButton andBlock:^{ [boldfaceController setAttributeState:!boldfaceController.state]; }];

    AttributeController *italicsController = [AttributeController createItalicsController];
    italicsController.attributeListController = (id<AttributeListController>)_attributeListController;
    italicsController.delegate = [AttributeControllerDelegateFactory delegateWithButton:toggleItalicsButton andBlock:^{ [italicsController setAttributeState:!italicsController.state]; }];
    
    _attributeControllers = [NSSet setWithObjects:boldfaceController, italicsController, nil];
}

- (void)openDocument:(Document*)document
{
    RtfSyntaxParser *parser = [RtfSyntaxParser new];
    NSDictionary *attributes = [textView.attributedText attributesAtIndex:0 effectiveRange:nil];
    AttributedStringBuilder *builder = [[AttributedStringBuilder alloc] initWithParser:parser andAttributes:attributes];
    parser.inputStream = [NSInputStream inputStreamWithURL:document.url];
    textView.attributedText = builder.output;
}

- (void)textViewDidChangeSelection:(UITextView *)sourceTextView
{
    [_attributeListController notifySubscribers];
}

@end
