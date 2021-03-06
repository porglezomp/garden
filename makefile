# Platform Specific
OS=$(shell uname -s)
ifeq ($(OS),Darwin)
	PLAT_LIBS=-framework OpenGL -framework CoreServices
else
	PLAT_LIBS=-lgl
endif


# Locate SDL2
SDL_FLAGS=$(shell sdl2-config --cflags)
SDL_LIBS=$(shell sdl2-config --libs)

# Core config
OPT=-O0 -g
LDLIBS=-ldl $(SDL_LIBS) $(PLAT_LIBS)
NODEPS=-std=c++14 -pedantic -Wall -Werror -Wextra $(OPT) $(SDL_FLAGS) $(PLAT_FLAGS) -I.
CFLAGS=$(NODEPS) -MMD

# Build target folder
ODIR=target
OSRC=$(ODIR)/src
OLIB=$(ODIR)/lib
OGAME=$(ODIR)/game

# Source, Object, and Deps locations
MAIN_SRC=$(shell find src -type f -name '*.cpp')
LIB_SRC=$(shell find lib -type f -name '*.cpp')
GAME_SRC=$(shell find game -type f -name '*.cpp')

MAIN_OBJ=$(MAIN_SRC:src/%.cpp=$(OSRC)/%.o)
LIB_OBJ=$(LIB_SRC:lib/%.cpp=$(OLIB)/%.o)
GAME_OBJ=$(GAME_SRC:game/%.cpp=$(OGAME)/%.o)

MAIN_DEP=$(MAIN_SRC:src/%.cpp=$(OSRC)/%.d)
LIB_DEP=$(LIB_SRC:lib/%.cpp=$(OLIB)/%.d)
GAME_DEP=$(GAME_SRC:game/%.cpp=$(OGAME)/%.d)

OBJS=$(wildcard assets/models/*.obj)
MODELS=$(OBJS:assets/models/%.obj=assets/models/%.model)

# Make sure all the target directories are created
DUMMY := $(shell find lib -type d | sed 's|^|target/|' | xargs mkdir -p)
DUMMY := $(shell find src -type d | sed 's|^|target/|' | xargs mkdir -p)
DUMMY := $(shell find game -type d | sed 's|^|target/|' | xargs mkdir -p)

# Target programs
APP=target/garden-game
LIBGAME=target/libgame.so
LIBSUP=target/libsupport.so


all: $(APP) $(LIBGAME) $(LIBSUP) assets

$(APP): $(MAIN_OBJ) $(LIBSUP)
	$(CXX) -o $@ $(CFLAGS) $(LDFLAGS) $(MAIN_OBJ) $(LDLIBS) -Ltarget -lsupport

$(LIBGAME): $(GAME_OBJ) $(LIBSUP)
	$(CXX) -o $@ $(CFLAGS) -shared $(LDFLAGS) $(GAME_OBJ) $(LDLIBS) -fPIC -Ltarget -lsupport
	make reload

$(LIBSUP): $(LIB_OBJ)
	$(CXX) -o $@ $(CFLAGS) -shared $(LDFLAGS) $(LIB_OBJ) $(LDLIBS) -fPIC

$(OSRC)/%.o: src/%.cpp
	$(CC) -o $@ -c $< $(CFLAGS)

$(OLIB)/%.o: lib/%.cpp
	$(CC) -o $@ -c $< $(CFLAGS)

$(OGAME)/%.o: game/%.cpp
	$(CC) -o $@ -c $< $(CFLAGS)

reload: assets
	if pgrep garden-game; then kill -s USR1 `pgrep garden-game`; fi

assets: $(MODELS)

assets/models/%.model: assets/models/%.obj
	python3 parse_obj.py $< > $@

test: $(APP) $(LIBGAME) $(LIBSUP)
	./$<

clean:
	$(RM) -rf $(ODIR)

# Use the generated dependency files
-include $(MAIN_DEP)
-include $(LIB_DEP)
-include $(GAME_DEP)
