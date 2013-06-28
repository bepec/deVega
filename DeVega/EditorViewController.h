//
//  EditorViewController.h
//  DeVega
//
//  Created by Admin on 5/12/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditorViewController;


@protocol EditorViewControllerDelegate <NSObject>

-(void)editorViewControllerDidClose:(EditorViewController *)controller;
-(void)editorViewControllerDidSave:(EditorViewController *)controller;

@end

@interface EditorViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, weak) id <EditorViewControllerDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIButton *toggleBoldfaceButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *toggleItalicsButton;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIToolbar *formatToolbar;

-(IBAction)close:(id)sender;
-(IBAction)save:(id)sender;

-(IBAction)toggleBoldface:(id)sender;
-(IBAction)toggleItalics:(id)sender;

-(void)textViewDidBeginEditing:(UITextView *)textView;

@end
