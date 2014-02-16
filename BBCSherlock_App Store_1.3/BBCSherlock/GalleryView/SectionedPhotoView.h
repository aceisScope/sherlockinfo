//
//  SectionedPhotoView.h
//  JinglingFilm
//
//  Created by 行之 程 on 12/5/11.
//  Copyright (c) 2011 NUS. All rights reserved.
//

@class SectionedPhotoView;

@protocol SectionedPhotoViewDataSource <NSObject>
@required
- (NSInteger)numberOfSectionsInSectionedPhotoView:(SectionedPhotoView*)photoView;
- (NSInteger)sectionedPhotoView:(SectionedPhotoView *)photoView numberOfPhotosInSection:(NSInteger)section;
- (NSString *)sectionedPhotoView:(SectionedPhotoView *)photoView photoURLAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (NSString *)sectionedPhotoView:(SectionedPhotoView *)photoView titleForHeaderInSection:(NSInteger)section;
@end

@protocol SectionedPhotoViewDelegate <NSObject>
@optional
- (void)sectionedPhotoView:(SectionedPhotoView *)photoView didSelectPhotoAtIndexPath:(NSIndexPath *)indexPath;
- (UIView *)sectionedPhotoView:(SectionedPhotoView *)photoView viewForHeaderInSection:(NSInteger)section;
- (CGFloat)sectionedPhotoView:(SectionedPhotoView *)photoView heightForHeaderInSection:(NSInteger)section;
@end

@interface SectionedPhotoView : UITableView <UITableViewDelegate, UITableViewDataSource> {

}

@property(nonatomic, readwrite) int numberofPhotosPerRow;
@property(nonatomic, readwrite) CGFloat photoRowHeight;
@property(nonatomic, readwrite) CGFloat padding;

@property(nonatomic, assign) id <SectionedPhotoViewDelegate> photoDelegate;
@property(nonatomic, assign) id <SectionedPhotoViewDataSource> photoDataSource;

- (UIView*) imageViewForPhotoAtIndex:(NSIndexPath*)indexPath;
@end
