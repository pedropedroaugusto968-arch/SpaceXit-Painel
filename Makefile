TARGET := iphone:clang:latest:15.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SpaceXit

SpaceXit_FILES = Tweak.xm
SpaceXit_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
SpaceXit_FRAMEWORKS = UIKit Foundation CoreGraphics

include $(THEOS)/makefiles/tweak.mk
