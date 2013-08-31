//
//  DocumentViewController.m
//  DeVega
//
//  Created by Admin on 10/05/2013.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "DocumentViewController.h"
#import "Document.h"
#import "DocumentCell.h"

@interface DocumentViewController()
{
    EditorViewController *_editorViewController;
}
@end


@implementation DocumentViewController

@synthesize documents;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Open"]) {
        _editorViewController = segue.destinationViewController;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return documents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DocumentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DocumentCell"];
    Document *document = [documents objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = document.title;
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    
    cell.modifiedDateLabel.text = [dateFormatter stringFromDate:document.modified];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    assert(_editorViewController != nil);
    [_editorViewController openDocument:[documents objectAtIndex:indexPath.row]];
}

@end
