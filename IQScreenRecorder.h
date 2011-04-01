//
//  IQScreenRecorder.h
//  IQWidgets
//
//  Created by Rickard Petzäll on 2011-03-25.
//  Please be aware that this class is dependent on GPL-licensed code in Contrib/
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef struct {int width; int height;} IntSize;

@interface IQScreenRecorder : NSObject {
    AVAssetWriter* assetWriter;
    CADisplayLink* displayLink;
    AVAssetWriterInput* input;
    AVAssetWriterInputPixelBufferAdaptor* inputAdaptor;
    BOOL startedWriting;
    void* screenSharing;
    UIWindow* screenMirroringWindow;
    UIImageView* screenMirroringView;
    BOOL screenMirroringEnabled;
    IntSize screenSize;
}

+ (IQScreenRecorder*) screenRecorder;

- (NSString*) startRecording;
- (void) stopRecording;

- (void) startSharingScreenWithPort:(int)port password:(NSString*)password;
- (void) stopSharingScreen;


- (void) startMirroringScreen;
- (void) stopMirroringScreen;

@end
