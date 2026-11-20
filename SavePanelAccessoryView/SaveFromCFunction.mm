//
//  SaveFromCFunction.mm
//  SavePanelAccessoryView
//
//  Created by Philip Schneider on 1/16/15.
//  Copyright (c) 2015-2019 Code From Above, LLC. All rights reserved.
//

#include "SaveFromCFunction.h"

#import <AppKit/AppKit.h>

#import "AccessoryViewController.h"

// A plain C++ function can't be a control's target, so this object receives
// the popup's action on its behalf.
@interface PopUpButtonHandler : NSObject

@property (nonatomic, weak) NSSavePanel *savePanel;

- (instancetype)initWithPanel:(NSSavePanel *)panel;
- (IBAction)selectFormat:(id)sender;

@end

@implementation PopUpButtonHandler

- (instancetype)initWithPanel:(NSSavePanel *)panel
{
    self = [super init];
    if (self)
    {
        _savePanel = panel;
    }

    return self;
}

- (IBAction)selectFormat:(id)sender
{
    [AccessoryViewController applyFormatAtIndex:[(NSPopUpButton *)sender indexOfSelectedItem]
                                    toSavePanel:[self savePanel]];
}

@end

static NSSavePanel             *savePanel;
static PopUpButtonHandler      *popUpButtonHandler;
static AccessoryViewController *accessoryVC;

// Creates the shared panel on first use and resets the settings common to
// every variant. The panel is reused, so any accessory view left over from a
// previous variant is removed here.
static NSSavePanel *preparedSavePanel()
{
    if (!savePanel)
        savePanel = [NSSavePanel savePanel];

    [savePanel setAllowedContentTypes:[AccessoryViewController allContentTypes]];
    [savePanel setTitle:@"Save Image"];
    [savePanel setAccessoryView:nil];
    [savePanel setAllowsOtherFileTypes:NO];

    return savePanel;
}

static std::string runSavePanel(NSSavePanel *panel)
{
    if ([panel runModal] == NSModalResponseOK)
    {
        const char *path = [[panel URL] fileSystemRepresentation];
        if (path)
            return std::string(path);
    }

    return std::string();
}

std::string saveFileDefault()
{
    return runSavePanel(preparedSavePanel());
}

std::string saveFileProgrammaticVersion()
{
    NSSavePanel *panel = preparedSavePanel();

    if (!popUpButtonHandler)
        popUpButtonHandler = [[PopUpButtonHandler alloc] initWithPanel:panel];

    NSTextField *label = [NSTextField labelWithString:@"Format:"];

    NSPopUpButton *popupButton = [[NSPopUpButton alloc] initWithFrame:NSZeroRect pullsDown:NO];
    [popupButton addItemsWithTitles:[AccessoryViewController formatTitles]];
    [popupButton setTarget:popUpButtonHandler];
    [popupButton setAction:@selector(selectFormat:)];

    NSStackView *accessoryView = [NSStackView stackViewWithViews:@[label, popupButton]];
    [accessoryView setEdgeInsets:NSEdgeInsetsMake(8.0, 20.0, 8.0, 20.0)];
    [accessoryView setFrameSize:[accessoryView fittingSize]];

    [panel setAccessoryView:accessoryView];

    // Make the panel match the popup's initial selection.
    [popUpButtonHandler selectFormat:popupButton];

    return runSavePanel(panel);
}

std::string saveFileNibVersion()
{
    NSSavePanel *panel = preparedSavePanel();

    if (!accessoryVC)
    {
        accessoryVC = [[AccessoryViewController alloc] initWithNibName:@"AccessoryViewController"
                                                                bundle:[NSBundle mainBundle]];
        [accessoryVC setSavePanel:panel];
    }

    [panel setAccessoryView:[accessoryVC view]];

    // The view controller is reused, so its popup may still show the format
    // chosen last time. Make the panel match it.
    [accessoryVC applySelectedFormat];

    return runSavePanel(panel);
}
