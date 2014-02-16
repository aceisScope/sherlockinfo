// From cscade on iphonedevbook.com forums
// And Bjorn Sallarp on blog.sallarp.com

@interface UIImage (Extras)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage*)imageScalingToHalfFromSide:(int)left;   //0 - left; 1 - right;

@end
