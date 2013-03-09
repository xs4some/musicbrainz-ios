//
//  ReleaseService
//  MusicBrainz
//
//  Created by bruinshe on 09-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//


#import "BasicService.h"
#import "Release.h"

@interface ReleaseService : BasicService

+(NSArray *)releasesWithArray:(NSArray *)array;
+(Release *)releaseWithDictionary:(NSDictionary *)dictionary;

@end