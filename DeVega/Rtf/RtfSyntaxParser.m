//
//  RtfSyntaxParser.m
//  DeVega
//
//  Created by Admin on 8/3/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "RtfSyntaxParser.h"

@interface RtfSyntaxParser ()
{
    id<RtfSyntaxParserDelegate> delegate;
    NSMutableData* buffer;
    //    struct {
    //        BOOL document;
    //    } state;
    //    enum {
    //        RtfDecoderElementGroupBegin,
    //        RtfDecoderElementGroupEnd
    //    };
}
- (void)parseBuffer;
@end

@implementation RtfSyntaxParser

- (id)init
{
    self = [super init];
    buffer = [NSMutableData new];
    return self;
}

- (void)setDelegate:(id<RtfSyntaxParserDelegate>)theDelegate
{
    delegate = theDelegate;
}

- (void)setInputStream:(NSInputStream*)stream
{
    stream.delegate = self;
    [stream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [stream open];
    [self stream:stream handleEvent:NSStreamEventHasBytesAvailable];
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
    if (streamEvent == NSStreamEventHasBytesAvailable)
    {
        enum { byteArrayLength = 1024 };
        uint8_t byteArray[byteArrayLength];
        NSInteger bytesRead = 0;
        while ((bytesRead = [(NSInputStream *)theStream read:byteArray maxLength:byteArrayLength]) > 0) {
            [buffer appendBytes:byteArray length:bytesRead];
        }
        [self parseBuffer];
    }
}

BOOL isControlSymbol(char symbol)
{
    return (symbol == '\\' || symbol == '{' || symbol == '}');
}

- (void)parseBuffer
{
    if (buffer.length == 0)
        return;
    
    char *array = (char*)[buffer bytes];
    
    typedef enum { StateReset, StateControl, StateText, StateEscape } StateType;
    StateType state = StateReset;
    size_t stateStartPosition = 0;
    
    for (size_t i = 0; i < buffer.length; i++) {
        const unichar currentSymbol = array[i];
        
        if (state == StateReset) {
            state = StateText;
            stateStartPosition = i;
        }
        
        if (state == StateEscape) {
            if (isControlSymbol(currentSymbol)) {
                [delegate text:[NSString stringWithCharacters:&currentSymbol length:1]];
                state = StateReset;
            }
            else if ([[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:currentSymbol]) {
                state = StateControl;
                stateStartPosition = i;
            }
            else {
                // special cases - \* \~ and so on
                state = StateReset;
            }
        }
        
        else if (state == StateControl) {
            if (isControlSymbol(currentSymbol)) {
                if (i > stateStartPosition) {
                    NSRange textRange = { stateStartPosition, i - stateStartPosition };
                    NSData * data = [buffer subdataWithRange:textRange];
                    NSString* controlWord = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                    [delegate controlWord:controlWord];
                }
                
                if (currentSymbol == '\\') {
                    state = StateEscape;
                    stateStartPosition = i;
                }
                else if (currentSymbol == '{') {
                    [delegate groupStart];
                    state = StateReset;
                }
                else if (currentSymbol == '}') {
                    [delegate groupEnd];
                    state = StateReset;
                }
            }
            else if (currentSymbol == ' ') {
                NSRange controlWordRange = { stateStartPosition, i - stateStartPosition };
                NSData * data = [buffer subdataWithRange:controlWordRange];
                NSString* controlWord = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                [delegate controlWord:controlWord];
                
                state = StateReset;
            }
            else if ([[NSCharacterSet alphanumericCharacterSet] characterIsMember:currentSymbol]) {
                // part of a control word
            }
            else {
                // error
            }
        }
        
        else if (state == StateText) {
            if (isControlSymbol(currentSymbol)) {
                if (i > stateStartPosition) {
                    NSRange textRange = { stateStartPosition, i - stateStartPosition};
                    NSData * data = [buffer subdataWithRange:textRange];
                    NSString* text = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                    [delegate text:text];
                }
                stateStartPosition = i;
                state = StateReset;
                
                if (currentSymbol == '\\') {
                    state = StateEscape;
                }
                else if (currentSymbol == '{') {
                    [delegate groupStart];
                }
                else if (currentSymbol == '}') {
                    [delegate groupEnd];
                }
                else {
                    // no more control symbols
                }
            }
        }
        
        else {
            assert(0);
            // no more types
        }
    }
    
    if (state == StateText && stateStartPosition < buffer.length) {
        NSRange textRange = { stateStartPosition, buffer.length - stateStartPosition};
        NSData * data = [buffer subdataWithRange:textRange];
        NSString* text = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        [delegate text:text];
    }
    
}

@end
