//
//  DDFileReader.h
//  NOCVBO
//
//  Created by William Lindmeier on 12/29/13.
//  Copyright (c) Dave DeLong. 
//  http://stackoverflow.com/users/115730/dave-delong

#import <Foundation/Foundation.h>

// Copied, with slight modifications, from this SO answer:
// http://stackoverflow.com/questions/3707427/how-to-read-data-from-nsfilehandle-line-by-line#3711079

@interface NOCFileReader : NSObject
{
    NSString * _filePath;
    NSFileHandle * _fileHandle;
    unsigned long long _currentOffset;
    unsigned long long _totalFileLength;
}

@property (nonatomic, copy) NSString * lineDelimiter;
@property (nonatomic) NSUInteger chunkSize;

- (id)initWithFilePath:(NSString *)aPath;

- (NSString *)readLine;
- (NSString *)readTrimmedLine;

#if NS_BLOCKS_AVAILABLE
- (void)enumerateLinesUsingBlock:(void(^)(NSString *line, BOOL *shouldStop))block;
- (void)enumerateTrimmedLinesUsingBlock:(void(^)(NSString *line, BOOL *shouldStop))block;
#endif

@end