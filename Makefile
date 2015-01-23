# Makefile for vips plugin 

# Object files
OBJS = openslide2vips.o openslideload.o

# Source files
SRC = $(BASEOBJS:.o=.c) 

# Headers
HEADERS = openslide2vips.h

# All
TAGS = $(SRC) $(HEADERS)

#linux
CFLAGS += -shared -fPIC -Wall -g
#solaris
#CFLAGS += -Xa -Kpic 
CPPFLAGS += `pkg-config vips openslide --cflags`
LDFLAGS += `pkg-config vips openslide --libs`
OUT = vips-openslide.plg

all: $(OUT)
debug: $(OUT)

$(OUT): $(OBJS)
#linux 
	$(CC) -o $(OUT) -shared $(OBJS)
#solaris
#	ld -o $(OUT) -G $(OBJS)
#	vips -plugin ./$(OUT) resample in.v in2.v out.v 0.1 20 1 1 0
#	vips -plugin ./$(OUT) scale_par matrix.mat out.mat 2.0

clean: 
	$(RM) $(OBJS) 

tags: $(TAGS)
	ctags $(TAGS)

# version as MAJOR.MINOR
VIPS_VERSION = $(shell pkg-config vips --modversion | \
	         awk '{split($$1,a,"."); print a[1]"."a[2]}')
PLUGIN_DIR = $(VIPSHOME)/lib/vips-plugins-$(VIPS_VERSION)

install: $(OUT)
	-mkdir -p $(PLUGIN_DIR)
	-cp $(OUT) $(PLUGIN_DIR)

