# -*- Mode: makefile-gmake; tab-width: 4; indent-tabs-mode: t -*-
#
# This file is part of the LibreOffice project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

$(eval $(call gb_AllLangHelp_AllLangHelp,sdatabase))

$(eval $(call gb_AllLangHelp_set_treefile,sdatabase,helpcontent2/source/auxiliary/sdatabase))

$(eval $(call gb_AllLangHelp_use_linked_modules,sdatabase,\
	shared \
))

$(eval $(call gb_AllLangHelp_add_helpfiles,sdatabase,\
    helpcontent2/source/text/sdatabase/main \
    helpcontent2/source/text/sdatabase/02000000 \
    helpcontent2/source/text/sdatabase/02000002 \
    helpcontent2/source/text/sdatabase/02010100 \
    helpcontent2/source/text/sdatabase/02010101 \
    helpcontent2/source/text/sdatabase/04000000 \
    helpcontent2/source/text/sdatabase/04030000 \
    helpcontent2/source/text/sdatabase/05000000 \
    helpcontent2/source/text/sdatabase/05000001 \
    helpcontent2/source/text/sdatabase/05000003 \
    helpcontent2/source/text/sdatabase/05010000 \
    helpcontent2/source/text/sdatabase/05010100 \
    helpcontent2/source/text/sdatabase/05020000 \
    helpcontent2/source/text/sdatabase/05020100 \
    helpcontent2/source/text/sdatabase/05030000 \
    helpcontent2/source/text/sdatabase/05030100 \
    helpcontent2/source/text/sdatabase/05030200 \
    helpcontent2/source/text/sdatabase/05030300 \
    helpcontent2/source/text/sdatabase/05030400 \
    helpcontent2/source/text/sdatabase/05040000 \
    helpcontent2/source/text/sdatabase/05040100 \
    helpcontent2/source/text/sdatabase/05040200 \
    helpcontent2/source/text/sdatabase/toolbars \
    helpcontent2/source/text/sdatabase/11000002 \
    helpcontent2/source/text/sdatabase/11020000 \
    helpcontent2/source/text/sdatabase/11030000 \
    helpcontent2/source/text/sdatabase/11030100 \
    helpcontent2/source/text/sdatabase/11080000 \
    helpcontent2/source/text/sdatabase/11090000 \
    helpcontent2/source/text/sdatabase/dabaadvpropdat \
    helpcontent2/source/text/sdatabase/dabaadvpropgen \
    helpcontent2/source/text/sdatabase/dabaadvprop \
    helpcontent2/source/text/sdatabase/dabadoc \
    helpcontent2/source/text/sdatabase/dabaprop \
    helpcontent2/source/text/sdatabase/dabapropadd \
    helpcontent2/source/text/sdatabase/dabapropcon \
    helpcontent2/source/text/sdatabase/dabapropgen \
))

# vim: set noet sw=4 ts=4:
