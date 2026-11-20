//
//  SaveFromCFunction.h
//  SavePanelAccessoryView
//
//  Created by Philip Schneider on 1/16/15.
//  Copyright (c) 2015-2019 Code From Above, LLC. All rights reserved.
//

#ifndef SAVEPANELACCESSORYVIEW_SAVEFROMCFUNCTION_H
#define SAVEPANELACCESSORYVIEW_SAVEFROMCFUNCTION_H

#include <string>

// Each function runs a save panel and returns the chosen file's path, or an
// empty string if the user cancels.
std::string saveFileDefault();
std::string saveFileProgrammaticVersion();
std::string saveFileNibVersion();

#endif /* SAVEPANELACCESSORYVIEW_SAVEFROMCFUNCTION_H */
