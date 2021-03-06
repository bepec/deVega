//
//  AttributedStringBuilder.h
//  DeVega
//
//  Created by Admin on 8/3/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RtfSyntaxParser.h"
#import "AttributeController.h"

@interface AttributedStringBuilder : NSObject<RtfSyntaxParserDelegate, AttributeListController>

- (id)init;
- (id)initWithParser:(RtfSyntaxParser*)parser andAttributes:(NSDictionary*)defaultAttributes;
- (NSAttributedString *)feed:(NSData*)data;
- (NSAttributedString *)output;

// RtfDecoderDelegate methods
- (void)controlWord:(NSString*)word;
- (void)groupStart;
- (void)groupEnd;
- (void)text:(NSString*)text;

// AttributeListController methods
- (void)notifySubscribers;
- (void)subscribe:(id<AttributeListSubscriber>)subscriber;
- (void)setAttributes:(NSDictionary*)attributes;
- (NSDictionary*)attributes;


@end
