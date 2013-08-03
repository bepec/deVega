//
//  RtfSyntaxParser.h
//  DeVega
//
//  Created by Admin on 8/3/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RtfSyntaxParserDelegate

- (void)controlWord:(NSString*)word;
- (void)groupStart;
- (void)groupEnd;
- (void)text:(NSString*)text;

@optional
- (void)error;

@end


@interface RtfSyntaxParser : NSObject<NSStreamDelegate>

- (void)setInputStream:(NSInputStream*)stream;
- (void)setDelegate:(id<RtfSyntaxParserDelegate>)theDelegate;
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent;

@end