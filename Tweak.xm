#import <AudioToolbox/AudioServices.h>

@interface TUCallProviderManager
@end

@interface DialerController
-(void)bootHapticFeedback;
-(void)fireHaptic;
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
	}

	[impact prepare];
}

%new
-(void)fireHaptic {
	[self bootHapticFeedback];
	
	int feedbackSupportLevel = [[[UIDevice currentDevice] valueForKey:@"_feedbackSupportLevel"] integerValue];

	if (feedbackSupportLevel == 0) {
		%log(@"Haptic and Taptic not supported");
		return;
	} else if (feedbackSupportLevel == 1) {
		// iPhone 6s/6s+, Taptic Engine
		SystemSoundID peek = SystemSoundID(1519);
		AudioServicesPlaySystemSound(peek);
	} else if (feedbackSupportLevel == 2) {
		// iPhone 7+, Haptic Feedback
		[impact impactOccurred];
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
	%orig;
	[self fireHaptic];
}

-(void)phonePad:(UIView *)pad keyDown:(char)key {
	%orig;
	[self fireHaptic];
}

-(void)_callButtonPressedActionWithCallProvider:(TUCallProviderManager *)provider {
	%orig;
	[self fireHaptic];
}

%end