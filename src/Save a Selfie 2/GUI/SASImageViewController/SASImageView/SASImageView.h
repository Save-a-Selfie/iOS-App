//
//  SASImageView.h
//  Save a Selfie
//
//  Created by Stephen Fox on 06/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

/// A custom image view, that can be selected and will be expanded to
/// for a larger preview.
@interface SASImageView : UIImageView

// Default is YES
// When tapped will expand to a larger preview.
// To remove this functionality set this property to NO.
@property (nonatomic, assign) BOOL canShowFullSizePreview;

@end
