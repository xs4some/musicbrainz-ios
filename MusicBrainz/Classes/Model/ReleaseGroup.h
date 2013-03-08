//
//  ReleaseGroup
//  MusicBrainz
//
//  Created by bruinshe on 08-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReleaseGroup : NSObject

@property (nonatomic, retain) NSString *releaseGroupId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSArray *artists;
@property (nonatomic, retain) NSArray *releases;
@property (nonatomic, retain) NSString *primaryType;
@property (nonatomic, retain) NSNumber *count;
@property (nonatomic, retain) NSNumber *score;

@end