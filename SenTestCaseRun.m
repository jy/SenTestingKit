/*$Id: SenTestCaseRun.m,v 1.7 2005/04/02 03:18:20 phink Exp $*/

// Copyright (c) 1997-2005, Sen:te (Sente SA).  All rights reserved.
//
// Use of this source code is governed by the following license:
// 
// Redistribution and use in source and binary forms, with or without modification, 
// are permitted provided that the following conditions are met:
// 
// (1) Redistributions of source code must retain the above copyright notice, 
// this list of conditions and the following disclaimer.
// 
// (2) Redistributions in binary form must reproduce the above copyright notice, 
// this list of conditions and the following disclaimer in the documentation 
// and/or other materials provided with the distribution.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
// IN NO EVENT SHALL Sente SA OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT 
// OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
// HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
// EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// 
// Note: this license is equivalent to the FreeBSD license.
// 
// This notice may not be removed from this file.

#import "SenTestCaseRun.h"
#import "NSException_SenTestFailure.h"
#import <Foundation/Foundation.h>
#import "SenTestingUtilities.h"

@implementation SenTestCaseRun

- (id) initWithTest:(SenTest *) aTest
{
    self = [super initWithTest:aTest];
    exceptions = [[NSMutableArray alloc] init];
    return self;
}


- (void) dealloc
{
    RELEASE (exceptions);
    [super dealloc];
}


- (id) initWithCoder:(NSCoder *) aCoder
{
    [super initWithCoder:aCoder];
    exceptions = [[aCoder decodeObject] mutableCopy];
    return self;
}


- (void) encodeWithCoder:(NSCoder *) aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:[self exceptions]];
}


- (NSArray *) exceptions
{
    return exceptions;
}


- (void) start
{
    [super start];
    [[NSNotificationCenter defaultCenter] postNotificationName:SenTestCaseDidStartNotification object:self];
}


- (void) stop
{
    [super stop];
    [[NSNotificationCenter defaultCenter] postNotificationName:SenTestCaseDidStopNotification object:self];
}


- (unsigned int) failureCount
{
    return failureCount;
}


- (unsigned int) unexpectedExceptionCount
{
    return unexpectedExceptionCount;
}


- (void) addException:(NSException *) anException
{
	
    if ([[anException name] isEqualToString:SenTestFailureException]) {
		failureCount++;
	}
	else {
		unexpectedExceptionCount++;	
	}
    [exceptions addObject:anException];
    [[NSNotificationCenter defaultCenter] postNotificationName:SenTestCaseDidFailNotification
                                                        object:self
                                                      userInfo:[NSDictionary dictionaryWithObject:anException forKey:@"exception"]];
}
@end


NSString *SenTestCaseDidStartNotification = @"SenTestCaseDidStartNotification";
NSString *SenTestCaseDidStopNotification = @"SenTestCaseDidStopNotification";
NSString *SenTestCaseDidFailNotification = @"SenTestCaseDidFailNotification";
