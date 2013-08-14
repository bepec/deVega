//
//  EditorViewController.h
//  DeVega
//
//  Created by Admin on 5/12/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Document.h"

@interface EditorViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UIButton *toggleBoldfaceButton;
@property (nonatomic, weak) IBOutlet UIButton *toggleItalicsButton;
@property (nonatomic, weak) IBOutlet UITextView *textView;

-(void)textViewDidChangeSelection:(UITextView *)textView;
-(void)openDocument:(Document*)document;

@end
