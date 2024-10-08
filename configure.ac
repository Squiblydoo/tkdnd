#!/bin/bash -norc
dnl        This file is an input file used by the GNU "autoconf" program to
dnl        generate the file "configure", which is run during Tcl installation
dnl        to configure the system for the local environment.
#
# RCS: @(#) $Id: configure.in,v 1.47 2007/02/09 19:06:47 hobbs Exp $

#-----------------------------------------------------------------------
# Sample configure.in for Tcl Extensions.  The only places you should
# need to modify this file are marked by the string __CHANGE__
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# __CHANGE__
# Set your package name and version numbers here.
#
# This initializes the environment with PACKAGE_NAME and PACKAGE_VERSION
# set as provided.  These will also be added as -D defs in your Makefile
# so you can encode the package version directly into the source files.
#-----------------------------------------------------------------------

AC_INIT([tkdnd],[m4_esyscmd_s([cat VERSION])])

#--------------------------------------------------------------------
# Call TEA_INIT as the first TEA_ macro to set up initial vars.
# This will define a ${TEA_PLATFORM} variable == "unix" or "windows"
# as well as PKG_LIB_FILE and PKG_STUB_LIB_FILE.
#--------------------------------------------------------------------

TEA_INIT()

AC_CONFIG_AUX_DIR(tclconfig)

#--------------------------------------------------------------------
# Load the tclConfig.sh file
#--------------------------------------------------------------------

TEA_PATH_TCLCONFIG
TEA_LOAD_TCLCONFIG

#--------------------------------------------------------------------
# Load the tkConfig.sh file if necessary (Tk extension)
#--------------------------------------------------------------------

TEA_PATH_TKCONFIG
TEA_LOAD_TKCONFIG

#-----------------------------------------------------------------------
# Handle the --prefix=... option by defaulting to what Tcl gave.
# Must be called after TEA_LOAD_TCLCONFIG and before TEA_SETUP_COMPILER.
#-----------------------------------------------------------------------

TEA_PREFIX

#-----------------------------------------------------------------------
# Standard compiler checks.
# This sets up CC by using the CC env var, or looks for gcc otherwise.
# This also calls AC_PROG_CC, AC_PROG_INSTALL and a few others to create
# the basic setup necessary to compile executables.
#-----------------------------------------------------------------------

TEA_SETUP_COMPILER

#-----------------------------------------------------------------------
# __CHANGE__
# Specify the C source files to compile in TEA_ADD_SOURCES,
# public headers that need to be installed in TEA_ADD_HEADERS,
# stub library C source files to compile in TEA_ADD_STUB_SOURCES,
# and runtime Tcl library files in TEA_ADD_TCL_SOURCES.
# This defines PKG(_STUB)_SOURCES, PKG(_STUB)_OBJECTS, PKG_HEADERS
# and PKG_TCL_SOURCES.
#-----------------------------------------------------------------------

#TEA_ADD_SOURCES([TkDND_XDND.c])
TEA_ADD_SOURCES([generic/TkDND_Cursors.c])
TEA_ADD_HEADERS([])
TEA_ADD_INCLUDES([-I generic])
TEA_ADD_LIBS([])
TEA_ADD_CFLAGS([])
TEA_ADD_STUB_SOURCES([])
TEA_ADD_TCL_SOURCES([library/tkdnd_compat.tcl library/tkdnd.tcl library/tkdnd_generic.tcl library/tkdnd_unix.tcl library/tkdnd_windows.tcl library/tkdnd_macosx.tcl library/tkdnd_utils.tcl])

#--------------------------------------------------------------------
# __CHANGE__
# A few miscellaneous platform-specific items:
#
# Define a special symbol for Windows (BUILD_sample in this case) so
# that we create the export library with the dll.
#
# Windows creates a few extra files that need to be cleaned up.
# You can add more files to clean if your extension creates any extra
# files.
#
# TEA_ADD_* any platform specific compiler/build info here.
#--------------------------------------------------------------------

AC_CHECK_HEADERS([limits.h],,AC_MSG_ERROR([required header file missing]))

AS_CASE([${TEA_PLATFORM}], [windows|*MINGW64_*],[
#if test "${TEA_PLATFORM}" = "windows" ; then
    # Ensure no empty if clauses
    # :
    AC_PROG_CXX
    CC=$CXX
    AC_CHECK_HEADER(Strsafe.h,
        [AC_DEFINE(HAVE_STRSAFE_H, 1, [Do we have <Strsafe.h>?])],
        [AC_DEFINE(NO_STRSAFE_H,   1, [Do we have <Strsafe.h>?])])
    TEA_ADD_CFLAGS([-DUNICODE -D_UNICODE])
    TEA_ADD_SOURCES([win/TkDND_OleDND.cpp])
    TEA_ADD_LIBS(kernel32.lib user32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib)

    ## Are we using GCC?
    AS_IF([test "$GCC" = yes], [
      ## Check if the compiler accepts -static-libstdc++...
      AC_CACHE_CHECK([if the compiler understands -static-libstdc++],
          tcl_cv_cc_staticlib, [
          hold_cflags=$CFLAGS; CFLAGS="$CFLAGS -static-libstdc++"
          AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[]], [[]])],[tcl_cv_cc_staticlib=yes],[tcl_cv_cc_staticlib=no])
          CFLAGS=$hold_cflags])
      AS_IF([test "x$tcl_cv_cc_staticlib" = xyes], [
          AC_MSG_NOTICE([Adding -static-libstdc++ to SHLIB_LD_LIBS])
          # SHLIB_LD_LIBS="${SHLIB_LD_LIBS} -static-libstdc++"
          TEA_ADD_LIBS([-static-libstdc++])
      ])
    ], [
        ## We are under Windows but not using GCC. MS Visual Studio?
        CFLAGS_OPTIMIZE=""
        CFLAGS_WARNING=""
        AC_CHECK_TOOL(LINK, link.exe)
        STLIB_LD='${LINK}'
    ])

    AC_DEFINE(BUILD_tkdnd, 1, [Build windows export dll])
    CLEANFILES="pkgIndex.tcl *.lib *.dll *.exp *.ilk *.pdb vc*.pch"
    #TEA_ADD_SOURCES([win/winFile.c])
    #TEA_ADD_INCLUDES([-I\"$(${CYGPATH} ${srcdir}/win)\"])
],[
#else
    # The following block executes under non-windows
    CLEANFILES="pkgIndex.tcl"
    #TEA_ADD_SOURCES([unix/unixFile.c])
    #TEA_ADD_LIBS([-lsuperfly])
#fi
])

if test "${TEA_WINDOWINGSYSTEM}" = "x11"; then
    TEA_ADD_SOURCES([unix/TkDND_XDND.c unix/tkUnixSelect.c unix/Cursors.c])
    AC_CHECK_HEADERS([X11/Xcursor/Xcursor.h], [], [
        echo "X11/Xcursor/Xcursor.h not found!"
        echo "TkDND requires libXcursor, please install the dependency!"
        exit -1
        ])
    AC_SEARCH_LIBS([XcursorFilenameLoadCursor], [Xcursor], [
        TEA_ADD_LIBS($LIBS)
    ], [
        echo "TkDND requires libXcursor, please install the dependency!"
        exit -1
        ])
    AC_CHECK_HEADER(X11/XKBlib.h,
        [AC_DEFINE(HAVE_X11_EXTENSIONS_XKB_H, 1, [Do we have <X11/XKBlib.h>?])],
        [AC_DEFINE(NO_X11_EXTENSIONS_XKB_H,   1, [Do we have <X11/XKBlib.h>?])])

    #     echo "TkDND requires libXcursor, please install the dependency"
    #     echo
    #     exit 1
    # fi
fi

if test "${TEA_WINDOWINGSYSTEM}" = "aqua"; then
    TEA_ADD_SOURCES([macosx/macdnd.m])
    TEA_ADD_CFLAGS([-DMAC_TK_COCOA -std=gnu99 -x objective-c])
    if test "`uname -r | cut -d . -f 1`" -gt 10; then :
      TEA_ADD_CFLAGS([-fobjc-arc])
    else
      TEA_ADD_CFLAGS([-fobjc-gc])
    fi
    TEA_ADD_LIBS([-framework Cocoa -framework Carbon])
fi

AC_SUBST(CLEANFILES)

#--------------------------------------------------------------------
# __CHANGE__
# Choose which headers you need.  Extension authors should try very
# hard to only rely on the Tcl public header files.  Internal headers
# contain private data structures and are subject to change without
# notice.
# This MUST be called after TEA_LOAD_TCLCONFIG / TEA_LOAD_TKCONFIG
#--------------------------------------------------------------------

TEA_PUBLIC_TCL_HEADERS
#TEA_PRIVATE_TCL_HEADERS

TEA_PUBLIC_TK_HEADERS
TEA_PRIVATE_TK_HEADERS
#TEA_PATH_X

#--------------------------------------------------------------------
# Check whether --enable-threads or --disable-threads was given.
# This auto-enables if Tcl was compiled threaded.
#--------------------------------------------------------------------

TEA_ENABLE_THREADS

#--------------------------------------------------------------------
# The statement below defines a collection of symbols related to
# building as a shared library instead of a static library.
#--------------------------------------------------------------------

TEA_ENABLE_SHARED

#--------------------------------------------------------------------
# This macro figures out what flags to use with the compiler/linker
# when building shared/static debug/optimized objects.  This information
# can be taken from the tclConfig.sh file, but this figures it all out.
#--------------------------------------------------------------------

TEA_CONFIG_CFLAGS
TEA_PATH_X

#--------------------------------------------------------------------
# Set the default compiler switches based on the --enable-symbols option.
#--------------------------------------------------------------------

TEA_ENABLE_SYMBOLS

#--------------------------------------------------------------------
# Everyone should be linking against the Tcl stub library.  If you
# can't for some reason, remove this definition.  If you aren't using
# stubs, you also need to modify the SHLIB_LD_LIBS setting below to
# link against the non-stubbed Tcl library.  Add Tk too if necessary.
#--------------------------------------------------------------------

AC_DEFINE(USE_TCL_STUBS, 1, [Use Tcl stubs])
AC_DEFINE(USE_TK_STUBS, 1, [Use Tk stubs])

#--------------------------------------------------------------------
# This macro generates a line to use when building a library.  It
# depends on values set by the TEA_ENABLE_SHARED, TEA_ENABLE_SYMBOLS,
# and TEA_LOAD_TCLCONFIG macros above.
#--------------------------------------------------------------------

TEA_MAKE_LIB

#--------------------------------------------------------------------
# Determine the name of the tclsh and/or wish executables in the
# Tcl and Tk build directories or the location they were installed
# into. These paths are used to support running test cases only,
# the Makefile should not be making use of these paths to generate
# a pkgIndex.tcl file or anything else at extension build time.
#--------------------------------------------------------------------

TEA_PROG_TCLSH
TEA_PROG_WISH

# if test "${TEA_PLATFORM}" = "windows" ; then
#   ## If the compiler accepts -static-libstdc++, modify the compiler
#   ## and linker options...
#   if test $tcl_cv_cc_staticlib = yes; then
#       CFLAGS="$CFLAGS -static-libgcc -static-libstdc++"
#       SHLIB_LD="$SHLIB_LD -static-libgcc -static-libstdc++"
#   fi
# fi

#--------------------------------------------------------------------
# The code makes use of PTR2INT, ensure the correct definition is
# picked from Tcl/Tk internal headers...
#--------------------------------------------------------------------
AC_CHECK_TYPE([intptr_t], [
    AC_DEFINE([HAVE_INTPTR_T], 1, [Do we have the intptr_t type?])], [
    AC_CACHE_CHECK([for pointer-size signed integer type], tcl_cv_intptr_t, [
    for tcl_cv_intptr_t in "int" "long" "long long" none; do
        if test "$tcl_cv_intptr_t" != none; then
            AC_COMPILE_IFELSE([AC_LANG_BOOL_COMPILE_TRY([AC_INCLUDES_DEFAULT],
                    [[sizeof (void *) <= sizeof ($tcl_cv_intptr_t)]])],
                [tcl_ok=yes], [tcl_ok=no])
            test "$tcl_ok" = yes && break; fi
    done])
    if test "$tcl_cv_intptr_t" != none; then
        AC_DEFINE_UNQUOTED([intptr_t], [$tcl_cv_intptr_t], [Signed integer
           type wide enough to hold a pointer.])
    fi
])
AC_CHECK_TYPE([uintptr_t], [
    AC_DEFINE([HAVE_UINTPTR_T], 1, [Do we have the uintptr_t type?])], [
    AC_CACHE_CHECK([for pointer-size unsigned integer type], tcl_cv_uintptr_t, [
    for tcl_cv_uintptr_t in "unsigned int" "unsigned long" "unsigned long long" \
            none; do
        if test "$tcl_cv_uintptr_t" != none; then
            AC_COMPILE_IFELSE([AC_LANG_BOOL_COMPILE_TRY([AC_INCLUDES_DEFAULT],
                    [[sizeof (void *) <= sizeof ($tcl_cv_uintptr_t)]])],
                [tcl_ok=yes], [tcl_ok=no])
            test "$tcl_ok" = yes && break; fi
    done])
    if test "$tcl_cv_uintptr_t" != none; then
        AC_DEFINE_UNQUOTED([uintptr_t], [$tcl_cv_uintptr_t], [Unsigned integer
           type wide enough to hold a pointer.])
    fi
])


#--------------------------------------------------------------------
# Finally, substitute all of the various values into the Makefile.
# You may alternatively have a special pkgIndex.tcl.in or other files
# which require substituting th AC variables in.  Include these here.
#--------------------------------------------------------------------

AC_CONFIG_FILES([Makefile pkgIndex.tcl])
AC_OUTPUT
