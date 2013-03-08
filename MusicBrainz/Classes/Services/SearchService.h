//
//  SearchService.h
//  MusicBrainz
//
//  Created by Hendrik Bruinsma on 05-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import "BasicService.h"

typedef enum
{
    SearchTypeArtist = 1,
    SearchTypeLabel,
    SearchTypeRecording,
    SearchTypeRelease,
    SearchTypeReleaseGroup,
    SearchTypeWork
} SearchType;

@interface SearchService : BasicService

-(id)initServiceWithQuery:(NSDictionary *)query;
-(void)getResultsOnCompletion:(void(^)(NSArray *results))completionBlock onError:(MKNKErrorBlock)errorBlock;

@end
