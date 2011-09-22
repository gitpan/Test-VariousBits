#!/usr/bin/perl

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

require 5;
use strict;
use ExtUtils::MakeMaker;
use lib 'inc';
use MyMakeMakerExtras;

MyMakeMakerExtras::WriteMakefile
  (NAME         => 'Test-VariousBits',
   ABSTRACT     => 'Various test helpers.',
   VERSION_FROM => 'lib/Test/Without/Shm.pm',
   PREREQ_PM    => {
                    'vars' => 0,

                    # for own testing ...
                    'Test' => 0,
                   },
   AUTHOR       => 'Kevin Ryde <user42@zip.com.au>',
   LICENSE      => 'gpl',
   SIGN         => 1,
   # probably anything
   MIN_PERL_VERSION => '5',

   META_MERGE =>
   { resources =>
     { homepage => 'http://user42.tuxfamily.org/test-variousbits/index.html',
     },
     optional_features =>
     { maximum_interoperation =>
       { description => 'Have maximum inter-operation with other modules.',
         requires => { 'Sub::Delete' => 0,
                     },
       },
       maximum_tests =>
       { description => 'Have "make test" do as much as possible.',
         requires => { 'IPC::SysV' => 0,
                     },
       },
       maximum_devel =>
       { description => 'Stuff used variously for development.',
         requires => { 'base'         => 0,
                       'Data::Dumper' => 0,
                       'File::Spec'   => 0,
                       'Scalar::Util' => 0,
                     },
       },
     },
   },
  );
