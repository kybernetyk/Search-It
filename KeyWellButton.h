//
//  KeyWellButton.h
//  KeyControl
//
//  Created by Jaroslaw Szpilewski on 22.08.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface KeyWellButton : NSButton 
{
	NSInteger keyCode;
	NSInteger modifiers;
}

- (IBAction) clearKeys: (id) sender;

@property (readwrite, assign) NSInteger keyCode;
@property (readwrite, assign) NSInteger modifiers;

@end
