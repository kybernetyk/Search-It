//
//  KeyWellButton.m
//  KeyControl
//
//  Created by Jaroslaw Szpilewski on 22.08.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "KeyWellButton.h"
#import "AppDelegate.h"


@implementation KeyWellButton

@synthesize keyCode, modifiers;


- (BOOL)performKeyEquivalent:(NSEvent *)anEvent
{
//		NSLog(@"dein gsicht!");
	if ([self state] == NSOnState)
	{
		//NSLog(@"om: %i, %i",([anEvent keyCode] && [anEvent modifierFlags]),([anEvent modifierFlags] & NSCommandKeyMask));
		//[self setTitle:[NSString stringWithFormat:@"%i,%i",[anEvent keyCode], [anEvent modifierFlags]]];
		
		NSString *modifierString = [NSString string];
		#ifdef DEBUG
		NSLog(@"dein gsicht!");
		#endif
/*
		NSAlphaShiftKeyMask = 1 << 16,
		NSShiftKeyMask      = 1 << 17,
		NSControlKeyMask    = 1 << 18,
		NSAlternateKeyMask  = 1 << 19,
		NSCommandKeyMask    = 1 << 20,
		NSNumericPadKeyMask = 1 << 21,
		NSHelpKeyMask       = 1 << 22,
		NSFunctionKeyMask   = 1 << 23,
*/
		
		
		/*enum {
			activeFlag = 1 << activeFlagBit,
			btnState = 1 << btnStateBit,
			cmdKey = 1 << cmdKeyBit,
			shiftKey = 1 << shiftKeyBit,
			alphaLock = 1 << alphaLockBit,
			optionKey = 1 << optionKeyBit,
			controlKey = 1 << controlKeyBit,
			rightShiftKey = 1 << rightShiftKeyBit,
			rightOptionKey = 1 << rightOptionKeyBit,
			rightControlKey = 1 << rightControlKeyBit
		};*/

		
		BOOL commandDown = NO;
		BOOL controlDown = NO;
		BOOL shiftDown = NO;
		BOOL optionDown = NO;
		int mod = 0;		
		
		if ([anEvent modifierFlags] & NSCommandKeyMask)
			commandDown = YES;
		
		if ([anEvent modifierFlags] & NSControlKeyMask)
			controlDown = YES;
		
		if ([anEvent modifierFlags] & NSShiftKeyMask)
			shiftDown = YES;
		
		if ([anEvent modifierFlags] & NSAlternateKeyMask)
			optionDown = YES;
		
		if (commandDown)
		{
			modifierString = [NSString stringWithFormat:@"command %@",modifierString];
			mod += cmdKey;
		}
		
		if (controlDown)
		{
			modifierString = [NSString stringWithFormat:@"control %@",modifierString];
			mod += controlKey;
		}
		
		if (shiftDown)
		{
			modifierString = [NSString stringWithFormat:@"shift %@",modifierString];
			mod += shiftKey;
		}
		
		if (optionDown)
		{
			modifierString = [NSString stringWithFormat:@"option %@",modifierString];
			mod += optionKey;
		}
		
		
		NSString *keyName = [[anEvent charactersIgnoringModifiers] uppercaseString];

		switch ([anEvent keyCode])
		{
			case 36: //enter
				keyName = @"enter";
				break;
			case 48: //tab
				keyName = @"tab";
				break;
			case 49:
				keyName = @"space";
				break;
			case 51: //backspace
				keyName = @"del";
				break;
			case 53: //escape
				keyName = @"esc";
				break;
		}
		
		NSString *titleString = [NSString stringWithFormat:@"%@%@",modifierString,keyName];

		
		[self setTitle: titleString];
		
		[self setKeyCode: [anEvent keyCode]];
		[self setModifiers:mod];
		
		[self setState: NSOffState];
		
		AppDelegate *appDelegate = (AppDelegate*)[NSApp delegate];
		[appDelegate unregisterHotkey];
		[appDelegate enregisterHotkeyWithKeyCode:[self keyCode] andModifiers:[self modifiers]];
		
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		[userDefaults setObject:titleString forKey:@"hotKeyTitle"];
		[userDefaults setObject:[NSString stringWithFormat:@"%i",[self keyCode]] forKey:@"hotKeyCode"];
		[userDefaults setObject:[NSString stringWithFormat:@"%i",[self modifiers]] forKey:@"hotKeyModifier"];

#ifdef DEBUG
		NSLog(@"saving prefs: %@,%@,%@",titleString, [NSString stringWithFormat:@"%i",[self keyCode]], [NSString stringWithFormat:@"%i",[self modifiers]]);
#endif
		
		
		return YES;
	}
	return NO;
}

- (IBAction) clearKeys: (id) sender
{
#ifdef DEBUG
	NSLog (@"clear keys!");
#endif
	[self setKeyCode: -1];
	[self setModifiers: 0];
	[self setTitle:[NSString string]];

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

	AppDelegate *appDelegate = (AppDelegate*)[NSApp delegate];
	[appDelegate unregisterHotkey];
	
	 [userDefaults setObject:[NSString string] forKey:@"hotKeyTitle"];
	 [userDefaults setObject:[NSString stringWithFormat:@"-1",[self keyCode]] forKey:@"hotKeyCode"];
	 [userDefaults setObject:[NSString stringWithFormat:@"-1",[self modifiers]] forKey:@"hotKeyModifier"];
	 
}

@end
