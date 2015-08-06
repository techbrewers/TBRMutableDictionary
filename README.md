#TBRMutableDictionary

[![Build Status](https://travis-ci.org/techbrewers/TBRMutableDictionary.png)](https://travis-ci.org/techbrewers/TBRMutableDictionary)

Thread safe mutable dictionary, it uses a NSMutableDictionary internally for storage and forwards some methods through a synchornous queue 

##Installation

* Add the class the `TBRMutableDictionary` to your project

##Example

```objc
TBRMutableDictionary *dictionary = [TBRMutableDictionary new];
dictionary[@"key"] = @"value";
id value = dictionary[@"key"];
NSUInteger count = [dictionary count];
[dictionary removeAllObjects];
```

## Supported methods

Currently only these methods are supported and tested:

```objc
- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;
- (void)removeAllObjects;
- (NSUInteger)count;
```

## Adding suppport for other methods

Adding support for other methods is simple with convenience macros, for example:

```objc
@interface TBRMutableDictionary
- (void)removeObjectsForKeys:(NSArray *)keyArray;
@end

@implementation TBRMutableDictionary

- (void)removeObjectsForKeys:(NSArray *)keyArray
{
  SYNC([self.mutableDictionary removeObjectsForKeys:keyArray]);
}
@end
```

##License

The MIT License (MIT)

Copyright (c) 2015 TechBrewers LTD.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.