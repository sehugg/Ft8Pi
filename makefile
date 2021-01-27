prefix=/usr/local

CFLAGS += -Wall
CXXFLAGS += -D_GLIBCXX_DEBUG -std=c++11 -Wall -Werror -fmax-errors=5
LDLIBS += -lm

ifeq ($(findstring armv6,$(shell uname -m)),armv6)
# Broadcom BCM2835 SoC with 700 MHz 32-bit ARM 1176JZF-S (ARMv6 arch)
PI_VERSION = -DRPI1
else
# Broadcom BCM2836 SoC with 900 MHz 32-bit quad-core ARM Cortex-A7  (ARMv7 arch)
# Broadcom BCM2837 SoC with 1.2 GHz 64-bit quad-core ARM Cortex-A53 (ARMv8 arch)
PI_VERSION = -DRPI23
endif

all: ft8 gpioclk

mailbox.o: mailbox.c mailbox.h
	$(CC) $(CFLAGS) -c mailbox.c

ft8: mailbox.o ft8.cpp mailbox.h
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $(LDLIBS) $(PI_VERSION) mailbox.o ft8.cpp -oft8

gpioclk: gpioclk.cpp
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $(LDLIBS) $(PI_VERSION) gpioclk.cpp -ogpioclk

clean:
	$(RM) *.o gpioclk ft8

.PHONY: install
install: ft8
	install -m 0755 ft8 $(prefix)/bin
	install -m 0755 gpioclk $(prefix)/bin

.PHONY: uninstall
uninstall:
	$(RM) $(prefix)/bin/ft8 $(prefix)/bin/gpioclk

