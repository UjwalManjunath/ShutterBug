//
//  FlickrPhotoTVC.m
//  ShutterBug
//
//  Created by Ujwal Manjunath on 3/3/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import "FlickrPhotoTVC.h"
#import "FlickrFetcher.h"

@interface FlickrPhotoTVC () <UISplitViewControllerDelegate>

@end

@implementation FlickrPhotoTVC

 -(void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}

#pragma mark - UISplitViewControllerDelegate

-(void)awakeFromNib
{
    self.splitViewController.delegate = self;
}

-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"Featured";
    id detailViewController = [self.splitViewController.viewControllers lastObject];
    
    if([detailViewController respondsToSelector:@selector(setsplitViewBarButtonItem:)])
    {
        [detailViewController performSelector:@selector(setsplitViewBarButtonItem:) withObject:barButtonItem];
    }
}

-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    id detailViewController = [self.splitViewController.viewControllers lastObject];
    if([detailViewController respondsToSelector:@selector(setsplitViewBarButtonItem:)])
    {
        [detailViewController performSelector:@selector(setsplitViewBarButtonItem:) withObject:Nil];
    }
}

-(id)splitViewDetailWithBarButtonItem
{
    id detail = [self.splitViewController.viewControllers lastObject];
    if(![detail respondsToSelector:@selector(setsplitViewBarButtonItem:)] ||
       ![detail respondsToSelector:@selector(splitViewBarButtonItem)])
        detail= nil;
    return detail;
}


- (void)transferSplitViewBarButtonItemToViewController:(id)destinationViewController
{
    UIBarButtonItem *splitViewBarButtonItem = [[self splitViewDetailWithBarButtonItem] performSelector:@selector(splitViewBarButtonItem)];
    [[self splitViewDetailWithBarButtonItem] performSelector:@selector(setsplitViewBarButtonItem:) withObject:nil];
    if (splitViewBarButtonItem)
        [destinationViewController performSelector:@selector(setsplitViewBarButtonItem:) withObject:splitViewBarButtonItem];
}










#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FlickrPhoto";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subTitleForRow:indexPath.row];
    
    return cell;
}

-(NSString *)titleForRow:(NSUInteger)row
{
    return [self.photos[row][FLICKR_PHOTO_TITLE] description];
}

-(NSString *)subTitleForRow:(NSUInteger)row
{
    return [self.photos[row][FLICKR_PHOTO_OWNER]description];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([sender isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if(indexPath)
        {
            if([segue.identifier isEqualToString:@"ShowImage"])
            {
                if([segue.destinationViewController respondsToSelector:@selector(setImageURL:)])
                {
                    [self transferSplitViewBarButtonItemToViewController:segue.destinationViewController];
                    NSURL *url = [FlickrFetcher urlForPhoto:self.photos[indexPath.row] format:FlickrPhotoFormatLarge];
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                }
            }
            
            
        }
    }
}


@end
