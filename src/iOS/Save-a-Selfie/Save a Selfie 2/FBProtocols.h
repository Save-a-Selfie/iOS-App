#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

// Wraps an Open Graph object (of type "smappr_post:photo", where 'photo' is an object) that has just two properties, an ID and a URL. The FBGraphObject allows us to create an FBGraphObject instance and treat it as an FBEvent with typed property accessors.
@protocol FBPhoto<FBGraphObject>

@property (retain, nonatomic) NSString *id;
@property (retain, nonatomic) NSString *url;

@end

// FBSample logic
// Wraps an Open Graph object (of type "smappr_posting:take") with a relationship to a photo,
// as well as properties inherited from FBOpenGraphAction such as "place" and "tags".
@protocol FBPhotoAction<FBOpenGraphAction>

@property (retain, nonatomic) id<FBPhoto> photo;

@end


