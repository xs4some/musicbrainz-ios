//
//  Release
//  MusicBrainz
//
//  Created by bruinshe on 08-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReleaseGroup.h"

@interface Release : NSObject

@property (nonatomic, retain) NSString *releaseId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSNumber *discCount;
@property (nonatomic, retain) NSString *format;
@property (nonatomic, retain) NSNumber *trackCount;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSNumber *score;
@property (nonatomic, retain) NSArray *media;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) ReleaseGroup *releaseGroup;
@property (nonatomic, retain) NSArray *artists;

@end