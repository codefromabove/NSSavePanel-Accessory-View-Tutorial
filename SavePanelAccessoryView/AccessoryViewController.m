//
//  AccessoryViewController.m
//  SavePanelAccessoryView
//
//  Created by Philip Schneider on 1/16/15.
//  Copyright (c) 2015-2019 Code From Above, LLC. All rights reserved.
//

#import "AccessoryViewController.h"

@interface AccessoryViewController ()

@property (nonatomic, weak) IBOutlet NSPopUpButton *formatPopUp;

@end

@implementation AccessoryViewController

// The three arrays below are parallel: entry N of each describes one format.

+ (NSArray<NSString *> *)formatTitles
{
    return @[@"JPEG (*.jpg)", @"GIF (*.gif)", @"PNG (*.png)"];
}

+ (NSArray<NSString *> *)formatExtensions
{
    return @[@"jpg", @"gif", @"png"];
}

+ (NSArray<UTType *> *)allContentTypes
{
    return @[UTTypeJPEG, UTTypeGIF, UTTypePNG];
}

+ (void)applyFormatAtIndex:(NSInteger)index toSavePanel:(NSSavePanel *)panel
{
    NSArray<NSString *> *extensions = [self formatExtensions];
    if (index < 0 || index >= (NSInteger)[extensions count])
        return;

    NSString *extension   = extensions[index];
    UTType   *contentType = [self allContentTypes][index];

    // Don't turn an empty name field into a bare ".ext" name.
    NSString *trimmedName = [[panel nameFieldStringValue] stringByDeletingPathExtension];
    if ([trimmedName length] > 0)
        [panel setNameFieldStringValue:[trimmedName stringByAppendingPathExtension:extension]];

    // If the Finder Preference "Show all filename extensions" is false or the
    // panel's extensionHidden property is YES (the default), then the
    // nameFieldStringValue will not include the extension we just changed/added.
    // So, in order to ensure that the panel's URL has the extension we've just
    // specified, the workaround is to restrict the allowed file types to only
    // the specified one.
    [panel setAllowedContentTypes:@[contentType]];

    // Without this, a user who types a different extension (e.g. "Frog.png"
    // while GIF is selected) silently gets "Frog.png.gif". With it, the panel
    // asks which extension to use instead.
    [panel setAllowsOtherFileTypes:YES];
}

- (void)applySelectedFormat
{
    [[self class] applyFormatAtIndex:[[self formatPopUp] indexOfSelectedItem]
                         toSavePanel:[self savePanel]];
}

- (IBAction)selectFormat:(id)sender
{
    [[self class] applyFormatAtIndex:[(NSPopUpButton *)sender indexOfSelectedItem]
                         toSavePanel:[self savePanel]];
}

@end
