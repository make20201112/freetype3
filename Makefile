# ============================================================================
# Freetype GL - A C OpenGL Freetype engine
# Platform:    Any
# API version: 1.0
# WWW:         http://code.google.com/p/freetype-gl/
# ----------------------------------------------------------------------------
# Copyright (c) 2011 Nicolas P. Rougier <Nicolas.Rougier@inria.fr>
# 
# This  program is free  software: you  can redistribute  it and/or  modify it
# under the terms  of the GNU General Public License as  published by the Free
# Software Foundation,  either version 3 of  the License, or  (at your option)
# any later version.
#
# This program is distributed in the  hope that it will be useful, but WITHOUT
# ANY  WARRANTY;  without even  the  implied  warranty  of MERCHANTABILITY  or
# FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU General  Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# this program. If not, see <http://www.gnu.org/licenses/>.
# ============================================================================
PLATFORM		= $(shell uname)
CC				= gcc
CFLAGS			= -Wall `freetype-config --cflags` -I/usr/X11/include
LIBS			= -lGL -lglut -lGLU -lglew \
	              `freetype-config --libs` -lfontconfig
ifeq ($(PLATFORM), Darwin)
	LIBS		= -framework OpenGL -framework GLUT -lglew \
	               `freetype-config --libs` -L /usr/X11/lib -lfontconfig
endif

DEMOS  := $(patsubst %.c,%,$(wildcard demo-*.c))
HEADERS:= $(wildcard *.h)
SOURCES:= $(filter-out $(wildcard demo-*.c), $(wildcard *.c))
OBJECTS:= $(SOURCES:.c=.o)

.PHONY: all $(DEMOS)
all: $(DEMOS)

define DEMO_template
$(1): $(1).o $(OBJECTS) $(HEADERS)
	@echo "Building $$@... "
	@$(CC) $(OBJECTS) $(1).o $(LIBS) -o $$@
endef
$(foreach demo,$(DEMOS),$(eval $(call DEMO_template,$(demo))))

%.o : %.c
	@echo "Building $@... "
	@$(CC) -c $(CFLAGS) $< -o $@ 


clean:
	@-rm -f $(DEMOS) *.o

distclean: clean
	@-rm -f *~
