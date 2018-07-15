@interface TUCallProviderManager
@end

@interface DialerController
-(void)bootHapticFeedback;
-(void)viewWillAppear:(bool)arg1;
-(void)viewWillDisappear:(bool)arg1;
-(void)phonePad:(UIView*)pad keyDown:(char)key;
-(void)phonePadDeleteLastDigit:(int)digit;
-(void)_callButtonPressedActionWithCallProvider:(TUCallProviderManager *)provider;
@end

%hook DialerController

UIImpactFeedbackGenerator *impact;

%new
-(void)bootHapticFeedback {
	// Allocate impact generator
	if (impact == nil) {
		impact = [[UIImpactFeedbackGenerator alloc] init];
		[impact prepare];
	}
}

-(void)viewWillAppear:(bool)arg1 {
	[self bootHapticFeedback];
	%orig;
}

-(void)viewWillDisappear:(bool)arg1 {
	// Release impact generator
	impact = nil;

	%orig;
}

-(void)phonePadDeleteLastDigit:(int)digit {
	[self bootHapticFeedback];

	[impact impactOccurred];
	[impact prepare];

	%orig;
}

-(void)phonePad:(UIView *)pad keyDown:(char)key {
	[self bootHapticFeedback];

	[impact impactOccurred];
	[impact prepare];

	%orig;
}

-(void)_callButtonPressedActionWithCallProvider:(TUCallProviderManager *)provider {
	[self bootHapticFeedback];

	[impact impactOccurred];
	[impact prepare];

	%orig;
}

%end