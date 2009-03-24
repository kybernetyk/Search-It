//
//  MainPanel.m
//  Search It
//
//  Created by jrk on 24.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "MainPanel.h"
#import "SearchWindowController.h"

@implementation MainPanel
- (void)flagsChanged:(NSEvent *)theEvent
{
	if ([theEvent type] != NSFlagsChanged)
	{
		[super flagsChanged: theEvent];
		return;
	}
	
	
	
	
	
	SearchWindowController *myController = [self windowController];
	
	int commandDown = NO;
	int controlDown = NO;
	int shiftDown = NO;
	int optionDown = NO;
	
	if ([theEvent modifierFlags] & NSCommandKeyMask)
		commandDown = 1;
	
	if ([theEvent modifierFlags] & NSControlKeyMask)
		controlDown = 1;
	
	if ([theEvent modifierFlags] & NSShiftKeyMask)
		shiftDown = 1;
	
	if ([theEvent modifierFlags] & NSAlternateKeyMask)
		optionDown = 1;

	int sum = commandDown + controlDown + shiftDown + optionDown;

	//NSLog(@"%i,%i,%i,%i = %i",commandDown,controlDown,shiftDown, optionDown, sum);

	if (sum == 0 || sum > 1)
	{
		[myController highlightModifier: 0];
		return;
	}
	
	if (commandDown)
	{
		[myController highlightModifier: 1];
		return;
	}

	if (shiftDown)
	{
		[myController highlightModifier: 2];
		return;
	}
	

	
}

@end
