//
//  DefaultNetworkWorker.h
//  Save a Selfie
//
//  Created by Stephen Fox on 29/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadWorker.h"

/**
 ** PLEASE READ BEFORE USE **
 This class deals with the retrieval of objects from
 the default server that was implemented with the application
 as of the 29/01/2016. Before using this class, it is advised
 to check with the author/ server admins that the implementation
 of this class is still functional.
 
 Due to ongoing decisions over the backend,
 this may be swapped out for another implementation
 and thus render it useless.
 */

@interface DefaultDownloadWorker : NSObject <DownloadWorker>




@end
