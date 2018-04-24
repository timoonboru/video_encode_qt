###############################################################################
#
# Copyright (c) 2016, NVIDIA CORPORATION. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#  * Neither the name of NVIDIA CORPORATION nor the names of its
#    contributors may be used to endorse or promote products derived
#    from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
# OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
###############################################################################

include ../Rules.mk

QTROOT=/usr/include/aarch64-linux-gnu/qt5

APP := video_encode

CLASS_DIR := ../common/classes

SRCS := \
	video_encode_csvparser.cpp \
	video_encode_main.cpp \
	$(wildcard $(CLASS_DIR)/*.cpp)

OBJS := $(SRCS:.cpp=.o)

LDFLAGS += \
	-lpthread \
	-lv4l2 -lEGL -lGLESv2 -lX11 \
	-lnvbuf_utils -lnvjpeg

INC_PATH = -I. -I$(QTROOT) -I$(QTROOT)/QtCore -I$(QTROOT)/QtGui -I$(QTROOT)/QtNetwork -I$(QTROOT)/QtWidgets -I/usr/include/opencv -I/usr/include/opencv2

LCLLIBS=  -L$(ARCHLIBDIR) -lpthread -lXext -lX11 -L/usr/local/lib -L/usr/lib -lGevApi -lCorW32 -lopencv_tegra -lopencv_gpu -lopencv_core -lopencv_imgproc -lopencv_highgui -lopencv_ml -L/usr/lib/aarch64-linux-gnu -lQt5Core -lQt5Gui -lQt5Network -lQt5Widgets 

all: $(APP)

$(CLASS_DIR)/%.o: $(CLASS_DIR)/%.cpp
	$(MAKE) -C $(CLASS_DIR)

%.o: %.cpp
	$(CPP) -I. $(INC_PATH) $(CPPFLAGS) -c $<

$(APP): $(OBJS)
	$(CPP) -o $@ $(OBJS) $(CPPFLAGS) $(LCLLIBS) $(LDFLAGS)

clean:
	$(MAKE) -C $(CLASS_DIR) clean
	rm -rf *.o $(APP)
