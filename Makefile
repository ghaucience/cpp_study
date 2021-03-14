ROOTDIR=$(shell pwd)
WORKDIR=$(ROOTDIR)/build

#ARCH								:= MT7620

ifeq ($(ARCH),MT7620)
#CROSSTOOLDIR 				:= /home/au/all/gwork/openwrt
#CROSSTOOLDIR 				:= /home/au/openwrt-3.10.14
CROSSTOOLDIR				:= /home/luyong/au/azure/azure-iot-sdk-c/build_all/linux/mt7620tools
CROSS   						:= mipsel-openwrt-linux-
export  STAGING_DIR	:= $(CROSSTOOLDIR)/staging_dir
export  PATH				:= $(PATH):$(STAGING_DIR)/toolchain-mipsel_24kec+dsp_gcc-4.8-linaro_uClibc-0.9.33.2/bin

CROSS_CFLAGS				:= -I$(CROSSTOOLDIR)/staging_dir/toolchain-mipsel_24kec+dsp_gcc-4.8-linaro_uClibc-0.9.33.2/usr/include
CROSS_CFLAGS				+= -I$(CROSSTOOLDIR)/staging_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/usr/include
CROSS_LDFLAGS				:= -L$(CROSSTOOLDIR)/staging_dir/toolchain-mipsel_24kec+dsp_gcc-4.8-linaro_uClibc-0.9.33.2/usr/lib
CROSS_LDFLAGS				+= -L$(CROSSTOOLDIR)/staging_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/usr/lib/ 
endif

GCC 		:= $(CROSS)gcc
CXX			:= $(CROSS)g++
AR			:= $(CROSS)ar
AS			:= $(CROSS)gcc
RANLIB	:= $(CROSS)ranlib
STRIP 	:= $(CROSS)strip
OBJCOPY	:= $(CROSS)objcopy
OBJDUMP := $(CROSS)objdump
SIZE		:= $(CROSS)size
LD			:= $(CROSS)ld
MKDIR		:= mkdir -p


TARGET_CFLAGS							:= -Wall -g -O2  
TARGET_CFLAGS							+= -fPIC
TARGET_CFLAGS							+= $(CROSS_CFLAGS) 

TARGET_CXXFLAGS						:= -std=c++0x 
TARGET_CXXFLAGS						+= $(TARGET_CFLAGS)


TARGET_LDFLAGS						:= -lm -lrt -ldl -lpthread
TARGET_LDFLAGS						+= -lstdc++
TARGET_LDFLAGS						+= $(CROSS_LDFLAGS)


srcs			+= $(ROOTDIR)/main.c
srcs			:= $(subst .cpp,.c,$(srcs))
objs			:= $(subst $(ROOTDIR),$(WORKDIR), $(subst .c,.o,$(srcs)))

templatesrcs  := $(ROOTDIR)/template_main.cpp
templatesrcs	:= $(subst .cpp,.c,$(templatesrcs))
templateobjs  := $(subst $(ROOTDIR),$(WORKDIR), $(subst .c,.o,$(templatesrcs)))

$(warning $(templateobjs))
all : template

template :  $(templateobjs)
	$(GCC) $^ $(TARGET_LDFLAGS) -o $(ROOTDIR)/build/$@

$(ROOTDIR)/build/%.o : $(ROOTDIR)/%.c
	@$(MKDIR) $(dir $@)
	$(GCC) -c $< $(TARGET_CFLAGS) -MMD -MP -MF"$(@:%.o=%.d)" -o $@

$(ROOTDIR)/build/%.o : $(ROOTDIR)/%.cpp
	@$(MKDIR) $(dir $@)
	$(CXX) -c $< $(TARGET_CXXFLAGS) -MMD -MP -MF"$(@:%.o=%.d)" -o $@

clean:
	rm -rf $(ROOTDIR)/build

scp:
	scp -P2200 $(ROOTDIR)/build/sm433 root@192.168.0.230:/root
