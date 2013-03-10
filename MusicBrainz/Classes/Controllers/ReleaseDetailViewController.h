//
//  ReleaseDetailViewController.h
//  MusicBrainz
//
//  Created by Hendrik Bruinsma on 03/10/13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

@class Release;

@interface ReleaseDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) Release *release_;

@end
