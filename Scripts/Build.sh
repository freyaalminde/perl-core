#!/bin/sh

# TODO: either recover hints file from old laptop or recreate it

PERL_VERSION=5.30.3
PERL_CROSS_VERSION=1.3.7

pushd `mktemp -d`

curl -L -O http://www.cpan.org/src/5.0/perl-$PERL_VERSION.tar.gz
curl -L -O https://github.com/arsv/perl-cross/releases/download/$PERL_CROSS_VERSION/perl-cross-$PERL_CROSS_VERSION.tar.gz

tar -zxf perl-$PERL_VERSION.tar.gz
cd perl-$PERL_VERSION
tar --strip-components=1 -zxf ../perl-cross-$PERL_CROSS_VERSION.tar.gz

# TODO: patch perl-cross: replace `#!/bin/sh` with `#!/bin/bash`

# brew install gnu-sed binutils

# TODO: don’t assume cowsay is installed

# make sure `sed` is GNU sed
# FIXME: fails when multiple versions are installed
# TODO: use something smarter than `*`
export PATH=`echo /usr/local/Cellar/gnu-sed/*/libexec/gnubin`:`echo /usr/local/Cellar/binutils/*/bin`:$PATH

# TODO: patch perl:

# doio.c:

# #if defined(__SYMBIAN32__) || defined(__LIBCATAMOUNT__) || defined(__WATCH_OS_VERSION_MIN_REQUIRED) || defined(__TV_OS_VERSION_MIN_REQUIRED)
#     Perl_croak(aTHX_ "exec? I'm not *that* kind of operating system");

# #if defined(__WATCH_OS_VERSION_MIN_REQUIRED) || defined(__TV_OS_VERSION_MIN_REQUIRED)
#
# bool
# Perl_do_exec3(pTHX_ const char *incmd, int fd, int do_report)
# {
#   Perl_croak(aTHX_ "exec? I'm not *that* kind of operating system");
#   return true;
# }
#
# #else
#
# #ifdef PERL_DEFAULT_DO_EXEC3_IMPLEMENTATION

# pp_sys.c:

# #if defined(__WATCH_OS_VERSION_MIN_REQUIRED) || defined(__TV_OS_VERSION_MIN_REQUIRED)
#
# PP(pp_system)
# {
#   dSP; dMARK; dORIGMARK; dTARGET;
#   RETURN;
# }
#
# #else
#

# toke.c (XSUB.h?): replace `PerlProc_execv(ipath, EXEC_ARGV_CAST(newargv));` with `//(ipath, EXEC_ARGV_CAST(newargv));` or smth

mkdir -p include
cp *.h include

cowsay "Building for MacOSX (aarch64-apple-mac)"

HOSTCFLAGS="-Wno-compound-token-split-by-macro -Wno-incompatible-pointer-types-discards-qualifiers -Wno-string-plus-int" \
CFLAGS="-arch arm64 -arch x86_64 -fno-common -DPERL_DARWIN -mmacosx-version-min=11.0 -fno-strict-aliasing -pipe -fstack-protector-strong -I/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include -DPERL_USE_SAFE_PUTENV -std=c89 -O3 -Wall -Werror=pointer-arith -Wextra -Wc++-compat -Wwrite-strings -Werror=declaration-after-statement -Wno-compound-token-split-by-macro -Wno-unused-function -Wno-unused-parameter -Wno-unused-local-typedef -Wno-unused-variable -Wno-incompatible-pointer-types-discards-qualifiers -Wno-sign-compare -Wno-string-plus-int" \
./configure --target=aarch64-apple-mac \
--with-cc=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc \
--with-ar=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ar \
--with-nm=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/nm \
--with-ranlib=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ranlib \
--with-readelf=/usr/local/Cellar/x86_64-elf-binutils/2.38/x86_64-elf/bin/readelf \
--with-objdump=/usr/local/Cellar/x86_64-elf-binutils/2.38/x86_64-elf/bin/objdump \
--prefix=/dev/null \
--sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk \
--no-dynaloader \
--disable-mod=B,Devel/Peek,Errno

make libperl

cowsay "Building for WatchOS (aarch64-apple-ios)"

HOSTCFLAGS="-Wno-compound-token-split-by-macro -Wno-incompatible-pointer-types-discards-qualifiers -Wno-string-plus-int" \
CFLAGS="-arch armv7k -arch arm64_32 -fno-common -DPERL_DARWIN -mwatchos-version-min=7.0 -fno-strict-aliasing -pipe -fstack-protector-strong -I/Applications/Xcode.app/Contents/Developer/Platforms/WatchOS.platform/Developer/SDKs/WatchOS.sdk/usr/include -DPERL_USE_SAFE_PUTENV -std=c89 -O3 -Wall -Werror=pointer-arith -Wextra -Wc++-compat -Wwrite-strings -Werror=declaration-after-statement -Wno-compound-token-split-by-macro -Wno-unused-function -Wno-unused-parameter -Wno-unused-local-typedef -Wno-unused-variable -Wno-incompatible-pointer-types-discards-qualifiers -Wno-sign-compare -Wno-string-plus-int" \
./configure --target=aarch64-apple-ios \
--with-cc=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc \
--with-ar=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ar \
--with-nm=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/nm \
--with-ranlib=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ranlib \
--with-readelf=/usr/local/Cellar/x86_64-elf-binutils/2.38/x86_64-elf/bin/readelf \
--with-objdump=/usr/local/Cellar/x86_64-elf-binutils/2.38/x86_64-elf/bin/objdump \
--prefix=/dev/null \
--sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/WatchOS.platform/Developer/SDKs/WatchOS.sdk \
--no-dynaloader \
--disable-mod=B,Devel/Peek,Errno

cowsay "Building for AppleTVSimulator (aarch64-apple-ios)"

HOSTCFLAGS="-Wno-compound-token-split-by-macro -Wno-incompatible-pointer-types-discards-qualifiers -Wno-string-plus-int" \
CFLAGS="-fno-common -DPERL_DARWIN -mtvos-version-min=9.0 -fno-strict-aliasing -pipe -fstack-protector-strong -I/Applications/Xcode.app/Contents/Developer/Platforms/AppleTVSimulator.platform/Developer/SDKs/AppleTVSimulator.sdk/usr/include -DPERL_USE_SAFE_PUTENV -std=c89 -O3 -Wall -Werror=pointer-arith -Wextra -Wc++-compat -Wwrite-strings -Werror=declaration-after-statement -Wno-compound-token-split-by-macro -Wno-unused-function -Wno-unused-parameter -Wno-unused-local-typedef -Wno-unused-variable -Wno-incompatible-pointer-types-discards-qualifiers -Wno-sign-compare -Wno-string-plus-int" \
./configure --target=aarch64-apple-ios \
--with-cc=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc \
--with-ar=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ar \
--with-nm=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/nm \
--with-ranlib=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ranlib \
--with-readelf=/usr/local/Cellar/x86_64-elf-binutils/2.38/x86_64-elf/bin/readelf \
--with-objdump=/usr/local/Cellar/x86_64-elf-binutils/2.38/x86_64-elf/bin/objdump \
--prefix=/dev/null \
--sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/AppleTVSimulator.platform/Developer/SDKs/AppleTVSimulator.sdk \
--no-dynaloader \
--disable-mod=B,Devel/Peek,Errno

cowsay "Building for AppleTVOS (aarch64-apple-ios)"

HOSTCFLAGS="-Wno-compound-token-split-by-macro -Wno-incompatible-pointer-types-discards-qualifiers -Wno-string-plus-int" \
CFLAGS="-arch arm64 -fno-common -DPERL_DARWIN -mtvos-version-min=9.0 -fno-strict-aliasing -pipe -fstack-protector-strong -I/Applications/Xcode.app/Contents/Developer/Platforms/AppleTVOS.platform/Developer/SDKs/AppleTVOS.sdk/usr/include -DPERL_USE_SAFE_PUTENV -std=c89 -O3 -Wall -Werror=pointer-arith -Wextra -Wc++-compat -Wwrite-strings -Werror=declaration-after-statement -Wno-compound-token-split-by-macro -Wno-unused-function -Wno-unused-parameter -Wno-unused-local-typedef -Wno-unused-variable -Wno-incompatible-pointer-types-discards-qualifiers -Wno-sign-compare -Wno-string-plus-int" \
./configure --target=aarch64-apple-ios \
--with-cc=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc \
--with-ar=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ar \
--with-nm=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/nm \
--with-ranlib=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ranlib \
--with-readelf=/usr/local/Cellar/x86_64-elf-binutils/2.38/x86_64-elf/bin/readelf \
--with-objdump=/usr/local/Cellar/x86_64-elf-binutils/2.38/x86_64-elf/bin/objdump \
--prefix=/dev/null \
--sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/AppleTVOS.platform/Developer/SDKs/AppleTVOS.sdk \
--no-dynaloader \
--disable-mod=B,Devel/Peek,Errno

xcodebuild -create-xcframework \
  -library build/mac-arm64-x86_64/libperl.a \
  -headers include \
  -library build/ios-arm64/libperl.a \
  -headers include \
  -library build/ios-simulator/libperl.a \
  -headers include \
  -library build/watch-simulator/libperl.a \
  -headers include \
  -library build/watchos-armv7k-arm64_32/libperl.a \
  -headers include \
  -library build/tvos-arm64/libperl.a \
  -headers include \
  -library build/tvos-simulator/libperl.a \
  -headers include \
  -output ../libperl.xcframework

# TODO: add some kind of future Swift Package Manager support for toggling which Perl modules to statically include?
# TODO: consider adding support for Mac Catalyst
# TODO: consider PR’ing all the patches to perl-cross

