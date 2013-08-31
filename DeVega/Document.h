//
//  Document.h
//  DeVega
//
//  Created by Admin on 10/05/2013.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Document : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSDate *modified;
@property (nonatomic, copy) NSURL *url;

+ (Document*)documentWithURL:(NSURL*)url;

@end
