
!ifndef STLSOFT
!error Environment variable STLSOFT is not defined
!endif # STLSOFT

CC=cl.exe
LINK=link.exe

CFLAGS=/EHsc /Zi /nologo /std:c++17 /Zc:__cplusplus /I "$(STLSOFT)/include"

LDFLAGS=/NOLOGO

SRCS=main.cpp

OBJS=$(SRCS:.cpp=.obj)

all: build

build: ReadDebugString.exe

ReadDebugString.exe: main.obj
	$(LINK) $(LDFLAGS) /OUT:$@ $(OBJS)

.cpp.obj:
	$(CC) $(CFLAGS) /c $<

clean:
	@del /Q *.obj *.exe

