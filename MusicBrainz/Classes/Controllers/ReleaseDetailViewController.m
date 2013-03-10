//
//  ReleaseDetailViewController.m
//  MusicBrainz
//
//  Created by Hendrik Bruinsma on 03/10/13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import "ReleaseDetailViewController.h"
#import "ReleaseService.h"
#import "Release.h"
#import "Track.h"
#import "Medium.h"

@interface ReleaseDetailViewController ()

@end

@implementation ReleaseDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = UIColorFromRGB(0xFFBA58);

    ReleaseService *releaseService = [[ReleaseService alloc] initServiceWithReleaseId:self.release_.releaseId andParams:nil];

    [releaseService getReleaseOnCompletion:^(Release *release_)
    {
        self.release_ = release_;
        [self.tableView reloadData];
    } onError:^(NSError *error)
    {

    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.release_.media)
    {
        return [self.release_.media count] + 1;
    }

    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"";
    }

    Medium *medium = [self.release_.media objectAtIndex:section - 1];

    NSString *format = medium.format;
    NSString *title = medium.title;

    if (format == nil)
    {
        format = @"disc";
    }

    if (title == nil)
    {
        title = @"";
    }

    return [NSString stringWithFormat:@"%@%d - %@", format, section, title];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 4;
    } else
    {
        Medium *medium = [self.release_.media objectAtIndex:section - 1];
        return [medium.tracks count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            static NSString *CellIdentifier = @"MediumMetaCell";

            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
            }

            switch (indexPath.row)
            {
                case 0:
                    cell.textLabel.text = @"Date";
//                    cell.detailTextLabel = self.release_.date;
                    break;

                case 1:
                    cell.textLabel.text = @"Released in";
                    cell.detailTextLabel.text = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:self.release_.country];
                    break;

                case 2:
                    cell.textLabel.text = @"Packaging";
                    cell.detailTextLabel.text = self.release_.packaging;
                    break;

                case 3:
                    cell.textLabel.text = @"Quality";
                    cell.detailTextLabel.text = self.release_.quality;
            }


            return cell;
        }
            break;

        default:
        {
            static NSString *CellIdentifier = @"TrackCell";

            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }

            Medium *medium = [self.release_.media objectAtIndex:indexPath.section - 1];

            Track *track = [medium.tracks objectAtIndex:indexPath.row];

            cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", track.number, track.title];

            double trackLength = [track.length doubleValue] / 100;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:trackLength];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm:ss"];

            cell.detailTextLabel.text = [formatter stringFromDate:date];

            return cell;
        }
    }

}

@end
