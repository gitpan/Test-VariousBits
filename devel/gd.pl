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


use FindBin;
use GD;
use Test::Without::GD;
Test::Without::GD->without_png;
Test::Without::GD->without_jpeg;
#Test::Without::GD->without_gif;

GD::Image->newFromGif('/usr/share/xulrunner-1.9.1/res/arrow.gif');
GD::Image->newFromJpeg('/usr/share/doc/imagemagick/images/background.jpg');
GD::Image->newFromPng('/usr/share/xemacs-21.4.22/etc/cbx.png');
GD::Image->newFromPngData('');
