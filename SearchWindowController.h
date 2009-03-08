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
	IBOutlet NSTextField *searchField;
}

@property (readonly) NSTextField *searchField;

- (IBAction) executeEnterSearch : (id) sender;
- (IBAction) executeCommandEnterSearch : (id) sender;
- (IBAction) executeShiftEnterSearch : (id) sender;


- (void) executeSearchWithEngine: (NSString *) name andLocale: (NSString *) locale;

@end
