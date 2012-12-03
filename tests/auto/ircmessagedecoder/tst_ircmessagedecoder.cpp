/*
 * Copyright (C) 2008-2012 J-P Nurmi <jpnurmi@gmail.com>
 *
 * This test is free, and not covered by LGPL license. There is no
 * restriction applied to their modification, redistribution, using and so on.
 * You can study them, modify them, use them in your own program - either
 * completely or partially. By using it you may give me some credits in your
 * program, but you don't have to.
 */

#include "ircmessagedecoder_p.h"
#include <QtTest/QtTest>
#include <QtCore/QTextCodec>
#include <QtCore/QtPlugin>

#ifdef COMMUNI_STATIC_ICU_PLUGIN
    Q_IMPORT_PLUGIN(icuplugin)
#endif

#ifdef COMMUNI_STATIC_UCHARDET_PLUGIN
    Q_IMPORT_PLUGIN(uchardetplugin)
#endif

class tst_IrcMessageDecoder : public QObject
{
    Q_OBJECT

private slots:
    void testDefaults();
};

void tst_IrcMessageDecoder::testDefaults()
{
    IrcMessageDecoder decoder;
    QCOMPARE(decoder.encoding(), QByteArray("ISO-8859-15"));
}

QTEST_MAIN(tst_IrcMessageDecoder)

#include "tst_ircmessagedecoder.moc"
