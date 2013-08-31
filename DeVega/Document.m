//
//  Document.m
//  DeVega
//
//  Created by Admin on 10/05/2013.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "Document.h"

@implementation Document

@synthesize title;
@synthesize modified;
@synthesize url;

+ (Document*)documentWithURL:(NSURL*)url
{
    Document *document = [Document new];
    document.url = url;
    document.title = [url lastPathComponent];
    NSDate *modified = [NSDate new];
    [url getResourceValue:&modified forKey:NSURLContentModificationDateKey error:nil];
    document.modified = modified;
    return document;
}

@end
