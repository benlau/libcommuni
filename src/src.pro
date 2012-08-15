######################################################################
# Communi
######################################################################

TEMPLATE = lib
TARGET = $$qtLibraryTarget(Communi)
DEFINES += BUILD_COMMUNI
QT = core network
!verbose:!symbian:CONFIG += silent
win32|mac:!wince*:!win32-msvc:!macx-xcode:CONFIG += debug_and_release build_all

include(../version.pri)
!win32:VERSION = $$COMMUNI_VERSION

DESTDIR = ../lib
DLLDESTDIR = ../bin
DEPENDPATH += . ../include
INCLUDEPATH += . ../include
!symbian {
    CONFIG(debug, debug|release) {
        OBJECTS_DIR = debug
        MOC_DIR = debug
    } else {
        OBJECTS_DIR = release
        MOC_DIR = release
    }
}

CONV_HEADERS += ../include/Irc
CONV_HEADERS += ../include/IrcCommand
CONV_HEADERS += ../include/IrcCodecPlugin
CONV_HEADERS += ../include/IrcGlobal
CONV_HEADERS += ../include/IrcMessage
CONV_HEADERS += ../include/IrcSender
CONV_HEADERS += ../include/IrcSession
CONV_HEADERS += ../include/IrcUtil

PUB_HEADERS += ../include/irc.h
PUB_HEADERS += ../include/irccommand.h
PUB_HEADERS += ../include/irccodecplugin.h
PUB_HEADERS += ../include/ircglobal.h
PUB_HEADERS += ../include/ircmessage.h
PUB_HEADERS += ../include/ircsender.h
PUB_HEADERS += ../include/ircsession.h
PUB_HEADERS += ../include/ircutil.h

PRIV_HEADERS += ../include/ircdecoder_p.h
PRIV_HEADERS += ../include/ircparser_p.h
PRIV_HEADERS += ../include/ircsession_p.h

HEADERS += $$PUB_HEADERS
HEADERS += $$PRIV_HEADERS

SOURCES += irc.cpp
SOURCES += irccommand.cpp
SOURCES += ircdecoder.cpp
SOURCES += irccodecplugin.cpp
SOURCES += ircmessage.cpp
SOURCES += ircparser.cpp
SOURCES += ircsender.cpp
SOURCES += ircsession.cpp
SOURCES += ircutil.cpp

contains(MEEGO_EDITION,harmattan) {
    COMMUNI_INSTALL_LIBS = /opt/communi/lib
    COMMUNI_INSTALL_BINS = /opt/communi/bin
} else {
    COMMUNI_INSTALL_LIBS = $$[QT_INSTALL_LIBS]
    COMMUNI_INSTALL_BINS = $$[QT_INSTALL_BINS]
}

target.path = $$COMMUNI_INSTALL_LIBS
INSTALLS += target

dlltarget.path = $$COMMUNI_INSTALL_BINS
INSTALLS += dlltarget

macx:CONFIG(qt_framework, qt_framework|qt_no_framework) {
    CONFIG += lib_bundle debug_and_release
    CONFIG(debug, debug|release) {
        !build_pass:CONFIG += build_all
    } else { #release
        !debug_and_release|build_pass {
            FRAMEWORK_HEADERS.version = Versions
            FRAMEWORK_HEADERS.files = $$PUB_HEADERS $$CONV_HEADERS
            FRAMEWORK_HEADERS.path = Headers
        }
        QMAKE_BUNDLE_DATA += FRAMEWORK_HEADERS
    }
    QMAKE_LFLAGS_SONAME = -Wl,-install_name,$$COMMUNI_INSTALL_LIBS/
} else:!contains(MEEGO_EDITION,harmattan) {
    headers.files = $$PUB_HEADERS $$CONV_HEADERS
    headers.path = $$[QT_INSTALL_HEADERS]/Communi
    INSTALLS += headers
}

symbian {
    TARGET.EPOCALLOWDLLDATA = 1
    TARGET.CAPABILITY = NetworkServices
    # TODO: TARGET.UID3 = 0xFFFFFFFF
    MMP_RULES += EXPORTUNFROZEN

    load(data_caging_paths)

    for(header, headers.files) {
        BLD_INF_RULES.prj_exports += "$$header $$MW_LAYER_PUBLIC_EXPORT_PATH($$basename(header))"
    }

    vendor.pkg_prerules += \
        "%{\"J-P Nurmi\"}" \
        ":\"J-P Nurmi\""
    DEPLOYMENT += vendor

    library.sources = $${TARGET}.dll
    library.path = $$SHARED_LIB_DIR
    DEPLOYMENT += library
}
