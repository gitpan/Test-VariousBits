#!/usr/bin/perl -w

# Copyright 2011 Kevin Ryde

# This file is part of Test-VariousBits.
#
# Test-VariousBits is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published
# by the Free Software Foundation; either version 3, or (at your option) any
# later version.
#
# Test-VariousBits is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
# Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with Test-VariousBits.  If not, see <http://www.gnu.org/licenses/>.

## no critic (RequireUseStrict, RequireUseWarnings)
use Test::Without::Shm ();

use Test;
plan tests => 3;
ok (1, 1, 'Test::Without::Shm load as first thing');


#------------------------------------------------------------------------------
# mode()

ok (Test::Without::Shm->mode, 'normal');
Test::Without::Shm->mode('nomem');
ok (Test::Without::Shm->mode, 'nomem');

exit 0;
