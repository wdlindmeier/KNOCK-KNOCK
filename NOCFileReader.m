//
//  NOCFileReader.m
//  NOCVBO
//
//  Created by William Lindmeier on 12/29/13.
//  Copyright (c) Dave DeLong.
//  http://stackoverflow.com/users/115730/dave-delong

#import "NOCFileReader.h"

@interface NSData (DDAdditions)

- (NSRange) rangeOfData_dd:(NSData *)dataToFind;

@end

@implementation NSData (DDAdditions)

- (NSRange) rangeOfData_dd:(NSData *)dataToFind {
    
    const void * bytes = [self bytes];
    NSUInteger length = [self length];
    
    const void * searchBytes = [dataToFind bytes];
    NSUInteger searchLength = [dataToFind length];
    NSUInteger searchIndex = 0;
    
    NSRange foundRange = {NSNotFound, searchLength};
    for (NSUInteger index = 0; index < length; index++) {
        if (((char *)bytes)[index] == ((char *)searchBytes)[searchIndex]) {
            //the current character matches
            if (foundRange.location == NSNotFound) {
                foundRange.location = index;
            }
            searchIndex++;
            if (searchIndex >= searchLength) { return foundRange; }
        } else {
            searchIndex = 0;
            foundRange.location = NSNotFound;
        }
    }
    return foundRange;
}

@end

@implementation NOCFileReader

- (id)initWithFilePath:(NSString *)aPath
{
    if (self = [super init])
    {
        _fileHandle = [NSFileHandle fileHandleForReadingAtPath:aPath];
        if ( _fileHandle == nil )
        {
            self = nil;
            return nil;
        }
        
        self.lineDelimiter = @"\n";
        _filePath = aPath;
        _currentOffset = 0ULL;
        self.chunkSize = 10;
        [_fileHandle seekToEndOfFile];
        _totalFileLength = [_fileHandle offsetInFile];
        //we don't need to seek back, since readLine will do that.
    }
    return self;
}

- (void) dealloc
{
    [_fileHandle closeFile];
}

- (NSString *)readLine
{
    if (_currentOffset >= _totalFileLength)
    {
        return nil;
    }
    
    NSData * newLineData = [self.lineDelimiter dataUsingEncoding:NSUTF8StringEncoding];
    [_fileHandle seekToFileOffset:_currentOffset];
    NSMutableData * currentData = [[NSMutableData alloc] init];
    BOOL shouldReadMore = YES;
    
    while (shouldReadMore)
    {
        if (_currentOffset >= _totalFileLength)
        {
            break;
        }
        NSData * chunk = [_fileHandle readDataOfLength:_chunkSize];
        NSRange newLineRange = [chunk rangeOfData_dd:newLineData];
        if (newLineRange.location != NSNotFound)
        {
            //include the length so we can include the delimiter in the string
            chunk = [chunk subdataWithRange:NSMakeRange(0, newLineRange.location+[newLineData length])];
            shouldReadMore = NO;
        }
        [currentData appendData:chunk];
        _currentOffset += [chunk length];
    }
    
    NSString * line = [[NSString alloc] initWithData:currentData encoding:NSUTF8StringEncoding];
    return line;
}

- (NSString *)readTrimmedLine
{
    return [[self readLine] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#if NS_BLOCKS_AVAILABLE

- (void)enumerateLinesUsingBlock:(void(^)(NSString *line, BOOL *shouldStop))block
{
    NSString * line = nil;
    BOOL stop = NO;
    while( stop == NO && (line = [self readLine]) )
    {
        block(line, &stop);
    }
}

- (void)enumerateTrimmedLinesUsingBlock:(void(^)(NSString *line, BOOL *shouldStop))block
{
    NSString * line = nil;
    BOOL stop = NO;
    while( stop == NO && (line = [self readTrimmedLine]) )
    {
        block(line, &stop);
    }
}
#endif

@end
