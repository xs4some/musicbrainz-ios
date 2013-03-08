//
//  Label
//  MusicBrainz
//
//  Created by bruinshe on 08-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface Label : NSObject

@property (nonatomic, retain) NSString *labelId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *sortName;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, assign) NSString *labelType;
@property (nonatomic, assign) NSNumber *score;
@property (nonatomic, retain) NSDate *lifeSpanBegin;
@property (nonatomic, retain) NSDate *lifeSpanEnd;
@property (nonatomic, assign) BOOL lifeSpanEnded;;

@end