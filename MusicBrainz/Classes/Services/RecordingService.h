//
//  RecordingService
//  MusicBrainz
//
//  Created by bruinshe on 09-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import "BasicService.h"
#import "Recording.h"

@interface RecordingService : NSObject

-(id)initServiceWithRecordingId:(NSString *)recordingId andParams:(NSMutableDictionary *)params;
+(NSArray *)recordingsWithArray:(NSArray *)array;
+(Recording *)recordingWithDictionary:(NSDictionary *)dictionary;

@end