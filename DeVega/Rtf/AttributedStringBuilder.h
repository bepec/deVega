//
//  AttributedStringBuilder.h
//  DeVega
//
//  Created by Admin on 8/3/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RtfSyntaxParser.h"

@interface AttributedStringBuilder : NSObject<RtfSyntaxParserDelegate>

- (id)init;
- (NSAttributedString *)feed:(NSData*)data;

// RtfDecoderDelegate methods
- (void)controlWord:(NSString*)word;
- (void)groupStart;
- (void)groupEnd;
- (void)text:(NSString*)text;
- (void)error;

@end
