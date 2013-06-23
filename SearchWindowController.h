//
//  SearchWindowController.h
//  Search It
//
//  Created by Jaroslaw Szpilewski on 21.08.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SearchWindowController : NSWindowController 
{
	IBOutlet NSTextField *__weak searchField;
	IBOutlet NSButton *actionButton;
}

@property (weak, readonly) NSTextField *searchField;

- (IBAction) executeEnterSearch : (id) sender;
- (IBAction) executeCommandEnterSearch : (id) sender;
- (IBAction) executeShiftEnterSearch : (id) sender;
- (IBAction) openPreferences : (id) sender;

- (void) executeSearchWithEngine: (NSString *) name andLocale: (NSString *) locale;

- (void) highlightModifier: (int) modifier;

@end
