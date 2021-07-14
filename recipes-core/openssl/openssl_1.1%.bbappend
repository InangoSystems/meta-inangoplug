# GETRANDOM method used by OpenSSL for seeding can take a lot of time on system
# boot  because the level of entropy is not sufficient.
# Use DEVRANDOM instead.
# With DEVRANDOM feature OpenSSL waits for /dev/random to be in readable
# state to ensure proper seeding. This also can take a lot of time,
# use /dev/urandom instead.
# DEVRANDOM_SAFE_KERNEL sets the limit for which Linux kernel version can
# guarantee that /dev/urandom is properly seeded when /dev/random becomes
# readable.
# Override to 4.10.
EXTRA_OECONF_append_dunfell = " --with-rand-seed=devrandom"
CFLAGS_append_dunfell = " -DDEVRANDOM_SAFE_KERNEL=4,10 -DDEVRANDOM_WAIT='"/dev/urandom"'"
