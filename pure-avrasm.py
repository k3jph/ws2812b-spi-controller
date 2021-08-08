Import("env")

## Get rid of the C/C++ runtime
env.Replace(LINKFLAGS = ["-nostartfiles", "-nostdlib", "-nodefaultlibs"])
