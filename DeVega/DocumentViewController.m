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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Open"]) {
        _editorViewController = segue.destinationViewController;
        _editorViewController.delegate = self;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.documents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DocumentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DocumentCell"];
    Document *document = [documents objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = document.title;
    cell.descriptionLabel.text = document.description;
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    
    cell.modifiedDateLabel.text = [dateFormatter stringFromDate:document.modified];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    assert(_editorViewController != nil);
    [_editorViewController openDocument:[documents objectAtIndex:indexPath.row]];
}

#pragma mark - Editor view controller delegate

- (void)editorViewControllerDidClose:(EditorViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[[UIAlertView alloc] initWithTitle:@"deVega" message:@"Close" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (NSString *)getNewFilename
{
    NSString *filename;
    
    return filename;
}

- (void)editorViewControllerDidSave:(EditorViewController *)controller
{
// paste code to save a document
}

@end
