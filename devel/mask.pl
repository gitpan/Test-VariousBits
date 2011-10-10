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

use strict;
use Module::Util::Masked;

# uncomment this to run the ### lines
use Devel::Comments;

{
  require App::MathImage::Generator;
  my @choices = App::MathImage::Generator->values_choices;
  ### @choices


  require Module::Util::Masked;
  eval 'use Test::Without::Module q{Math::Aronson}, q{Math::NumSeq::Aronson}; 1'
    or die;
  my @filenames = Module::Util::find_in_namespace('Math::NumSeq');
  ### @filenames

  @filenames = Module::Util::find_in_namespace('App::MathImage::NumSeq');
  ### @filenames

  exit 0;
}



my $path = Module::Util::find_installed('FindBin');
### $path
eval "use Module::Mask 'FindBin'";
$path = Module::Util::find_installed('FindBin');
### $path

# $path = Module::Util::find_installed('SelectSaver');
# ### $path
# eval "use Test::Without::Module 'SelectSaver'";
# my @forbidden = Test::Without::Module::get_forbidden_list();
# ### @forbidden
# $path = Module::Util::find_installed('SelectSaver');
# ### $path


$path = Module::Util::find_installed('SelectSaver');
### $path
require Module::Mask;
my $mask = Module::Mask->new ('SelectSaver');

$path = Module::Util::find_installed('SelectSaver');
### $path

push @INC, shift @INC;
### @INC

$path = Module::Util::find_installed('SelectSaver');
### $path


