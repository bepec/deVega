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


@interface EditorViewController : UIViewController

@property (nonatomic, weak) id <EditorViewControllerDelegate> delegate;

-(IBAction)close:(id)sender;
-(IBAction)save:(id)sender;

@end
