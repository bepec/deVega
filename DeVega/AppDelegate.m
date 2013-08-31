//
//  AppDelegate.m
//  DeVega
//
//  Created by Admin on 21/04/2013.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "AppDelegate.h"
#import "Document.h"
#import "DocumentViewController.h"

@implementation AppDelegate {
    NSMutableArray *documents;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *documentDirectories = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    
    documents = [NSMutableArray arrayWithCapacity: 20];

    for (NSURL *directory in documentDirectories) {
        NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtURL:directory
                                              includingPropertiesForKeys:@[NSURLIsDirectoryKey, NSURLNameKey, NSURLContentModificationDateKey]
                                                                 options:NSDirectoryEnumerationSkipsHiddenFiles
                                                            errorHandler:nil];
        for (NSURL *url in enumerator) {
            if ([[url pathExtension] isEqualToString:@"rtf"])
                [documents addObject:[Document documentWithURL:url]];
        }
    }
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    DocumentViewController *documentController = (DocumentViewController *)navigationController.topViewController;
    documentController.documents = documents;
    
    return YES;
}

@end
