/*
 * Copyright 2019 Omnissa, LLC.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//  This class allows building a custom stack trace to send to Crittercism
//  as a crash or a handled exception.

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CRCustomStackFrame) {
    crFunctionA,
    crFunctionB,
    crFunctionC,
    crFunctionD
};

@interface CRCustomError : NSObject
- (void)addFrame:(CRCustomStackFrame)frame;
- (NSUInteger)numberOfFrames;
- (NSString *)frameAtIndex:(NSUInteger)index;
- (void)clear;
- (void)crash;
- (void)raiseException;
@end
