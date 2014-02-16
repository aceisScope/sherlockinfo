//
//  SectionedPhotoView.m
//  JinglingFilm
//
//  Created by 行之 程 on 12/5/11.
//  Copyright (c) 2011 NUS. All rights reserved.
//

#import "SectionedPhotoView.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageExtras.h"

@class PhotoRowCell;
@protocol PhotoRowCellDelegate <NSObject>
@optional
- (void) photoRowCell:(PhotoRowCell*)cell didSelectPhotoAtIndex:(int)index;
@end

@interface PhotoRowCell : UITableViewCell {
}
@property(nonatomic, retain) NSMutableArray * photoViews;
@property(nonatomic, retain) NSIndexPath * indexPath;
@property(nonatomic, readwrite) CGFloat padding;
@property(nonatomic, assign) id<PhotoRowCellDelegate> delegate;
//@property(nonatomic, readwrite) int tapped_index;

- (void) showPhotos:(NSArray*)photoArray;
@end

@implementation PhotoRowCell
@synthesize photoViews;
@synthesize indexPath;
@synthesize padding;
@synthesize delegate;

- (void) dealloc {
    self.indexPath = nil;
    self.photoViews = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        self.photoViews = [NSMutableArray array];
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        self.padding = 2.f;
 
        UITapGestureRecognizer * tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)] autorelease];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) layoutSubviews {
    CGFloat half_padding = self.padding/2;
    CGFloat w = self.frame.size.width/[self.photoViews count] - self.padding;
    CGFloat h = self.frame.size.height - self.padding;
    
    for (int i = 0; i < [self.photoViews count]; ++i) {
        UIView * view = [self.photoViews objectAtIndex:i];
        view.frame = CGRectMake(half_padding+i*(w + self.padding), half_padding, w, h);
    }
}

- (void) showPhotos:(NSArray *)photoArray 
{
    while ([self.photoViews count] < [photoArray count]) 
    {
        AsyncImageView * imageView = [[[AsyncImageView alloc] initWithFrame:CGRectZero] autorelease];
        imageView.layer.borderColor = [UIColor grayColor].CGColor;
        imageView.layer.borderWidth = 1.;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.photoViews addObject:imageView];
        [self addSubview:imageView];
    }
    while ([self.photoViews count] > [photoArray count]) 
    {
        [[self.photoViews lastObject] removeFromSuperview];
        [self.photoViews removeLastObject];
    }
    for (int i = 0; i < [self.photoViews count]; ++i) 
    {
        AsyncImageView * view = [self.photoViews objectAtIndex:i];
//        [view loadImage:[photoArray objectAtIndex:i]];
        view.image = [UIImage imageNamed:[photoArray objectAtIndex:i]];
        view.hidden = ([[photoArray objectAtIndex:i] length] == 0);
    }
}

- (void) tapped:(UITapGestureRecognizer*)tapRecognizer {
    if ([self.delegate respondsToSelector:@selector(photoRowCell:didSelectPhotoAtIndex:)]) {
        CGPoint point = [tapRecognizer locationInView:tapRecognizer.view];
        CGFloat w = tapRecognizer.view.frame.size.width / [self.photoViews count];
        int tapindex = (int) (point.x/w);
        UIView * view = [self.photoViews objectAtIndex:tapindex];
        if (!(view.hidden))
            [self.delegate photoRowCell:self didSelectPhotoAtIndex:tapindex];
    }
}

    //劫持 tap event
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView * v = [super hitTest:point withEvent:event];
    if (v != nil) return  self;
    return v;
}

@end

@interface SectionedPhotoView() <PhotoRowCellDelegate>

@end

@implementation SectionedPhotoView
@synthesize photoDelegate = _photoDelegate;
@synthesize photoDataSource = photoDataSource;

@synthesize numberofPhotosPerRow = _numberofPhotosPerRow;
@synthesize photoRowHeight = _photoHeight;
@synthesize padding = _padding;

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self != nil) {
        [super setDataSource:self];
        [super setDelegate:self];
        
        _numberofPhotosPerRow = 2;
        _padding = 2.0;
        _photoHeight = frame.size.width/_numberofPhotosPerRow - _padding;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delaysContentTouches = NO;
    }
    return self;
}

/*
- (void) reloadData {
    [super reloadData];
}
*/
- (void) setPadding:(CGFloat)padding {
    _padding = padding;
    [super reloadData];
}

- (void) setPhotoRowHeight:(CGFloat)photoRowHeight {
    _photoHeight = photoRowHeight;
    [super reloadData];
}

- (void) setnumberofPhotosPerRow:(int)numberofPhotosPerRow {
    _numberofPhotosPerRow = numberofPhotosPerRow;
    [super reloadData];
}

- (UIView*) imageViewForPhotoAtIndex:(NSIndexPath*)indexPath 
{
    int row = indexPath.row / self.numberofPhotosPerRow;// + (indexPath.row % self.numberofPhotosPerRow > 0 ? 1 : 0);
    int position = indexPath.row % self.numberofPhotosPerRow;
    PhotoRowCell * cell = (PhotoRowCell*) [super cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:indexPath.section]];
    return [cell.photoViews objectAtIndex:position];
}

#pragma mark -
#pragma mark uitableview delegate, datasources

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.photoDataSource numberOfSectionsInSectionedPhotoView:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int numberOfPhotos = [self.photoDataSource sectionedPhotoView:self numberOfPhotosInSection:section];
    return (numberOfPhotos / _numberofPhotosPerRow) + (numberOfPhotos%_numberofPhotosPerRow > 0 ? 1 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PhotoCell";
    PhotoRowCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[PhotoRowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.padding = self.padding;
        cell.delegate = self;
    }
    cell.indexPath = indexPath;

    int numberOfPhotos = [self.photoDataSource sectionedPhotoView:self numberOfPhotosInSection:indexPath.section];
    int photosInRow = MIN(self.numberofPhotosPerRow, numberOfPhotos - self.numberofPhotosPerRow * indexPath.row);
    
//    NSLog(@"number of photos %d, indexPath %@, photosInRow %d", numberOfPhotos, indexPath, photosInRow);
    
    NSMutableArray * photoURLs = [NSMutableArray array];
    for (int i = 0; i < self.numberofPhotosPerRow; ++i) {
        if (i < photosInRow) 
        {
            NSIndexPath * newIndex = [NSIndexPath indexPathForRow:self.numberofPhotosPerRow*indexPath.row+i inSection:indexPath.section];
            NSString * url = [self.photoDataSource sectionedPhotoView:self photoURLAtIndexPath:newIndex];
            [photoURLs addObject:url];
        }
        else 
        {
            [photoURLs addObject:@""];
        }
    }
    [cell showPhotos:photoURLs];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _photoHeight;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self.photoDataSource respondsToSelector:@selector(sectionedPhotoView:titleForHeaderInSection:)])
        return [self.photoDataSource sectionedPhotoView:self titleForHeaderInSection:section];
    return nil;
}
/*
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([self.photoDelegate respondsToSelector:@selector(sectionedPhotoView:didSelectPhotoAtIndexPath:)])
//        [self.photoDelegate sectionedPhotoView:self didSelectPhotoAtIndexPath:indexPath];
    NSLog(@"select row at index %@", indexPath);
}
*/
- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.photoDelegate respondsToSelector:@selector(sectionedPhotoView:viewForHeaderInSection:)]) {
        return [self.photoDelegate sectionedPhotoView:self viewForHeaderInSection:section];
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.photoDelegate respondsToSelector:@selector(sectionedPhotoView:heightForHeaderInSection:)]) {
        return [self.photoDelegate sectionedPhotoView:self heightForHeaderInSection:section];
    }
    return 30;
}

- (void) photoRowCell:(PhotoRowCell*)cell didSelectPhotoAtIndex:(int)index {
//    NSLog(@"tapped on cell %@, on index %d", cell.indexPath, index);
    if ([self.photoDelegate respondsToSelector:@selector(sectionedPhotoView:didSelectPhotoAtIndexPath:)]) {
        NSIndexPath * newIndex = [NSIndexPath indexPathForRow:self.numberofPhotosPerRow*cell.indexPath.row+index inSection:cell.indexPath.section];
        [self.photoDelegate sectionedPhotoView:self didSelectPhotoAtIndexPath:newIndex];
    }
}

@end
