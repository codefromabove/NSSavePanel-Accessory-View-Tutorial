//
//  AccessoryViewController.h
//  SavePanelAccessoryView
//
//  Created by Philip Schneider on 1/16/15.
//  Copyright (c) 2015-2019 Code From Above, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface AccessoryViewController : NSViewController

@property (nonatomic, weak) NSSavePanel *savePanel;

// Popup item titles, in the order expected by +applyFormatAtIndex:toSavePanel:.
+ (NSArray<NSString *> *)formatTitles;

// All supported content types, for use when no single format is selected.
+ (NSArray<UTType *> *)allContentTypes;

// Sets the panel's file extension and allowed content type to match the
// format at the given popup index.
+ (void)applyFormatAtIndex:(NSInteger)index toSavePanel:(NSSavePanel *)panel;

// Applies the popup's current selection to the save panel. Call this before
// running the panel so the panel matches what the popup shows.
- (void)applySelectedFormat;

@end
