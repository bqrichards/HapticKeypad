include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HapticKeypad
HapticKeypad_FILES = Tweak.xm
HapticKeypad_FRAMEWORKS = AudioToolbox

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
