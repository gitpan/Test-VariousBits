# Copyright 2010, 2011 Kevin Ryde

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

package Module::Util::Masked;
require 5;
use strict;

use vars qw($VERSION);
$VERSION = 2;

# uncomment this to run the ### lines
#use Devel::Comments;


# BEGIN {
#   # Check that Module::Util isn't already loaded.
#   #
#   # is_valid_module_name() here is a representative func, and not one that's
#   # mangled here (so as not to risk hitting that if something goes badly
#   # wrong).  Maybe looking at %INC would be better.
#   #
#   if (Module::Util->can('is_valid_module_name')) {
#     die "Module::Util already loaded, cannot fake after imports may have grabbed its functions";
#   }
# }

use Module::Util;


sub _elem_masks_module {
  my ($elem, $module) = @_;
  ### _elem_masks_module(): $elem, $module

  ref $elem or return 0;

  if ($elem == \&Test::Without::Module::fake_module) {
    if (exists (Test::Without::Module::get_forbidden_list()->{$module})) {
      ### Test-Without-Module masks ...
      return 1;
    }
  }

  require Scalar::Util;
  if (Scalar::Util::blessed($elem)
      && $elem->isa('Module::Mask')
      && $elem->is_masked($module)) {
    ### Module-Mask masks ...
    return 1;
  }

  ### not masked ...
  return 0;
}

sub _pruned_inc {
  my $module = shift;
  my @inc = @_ ? @_ : @INC;
  ### _pruned_inc() ...

  foreach my $pos (0 .. $#inc) {
    if (_elem_masks_module($inc[$pos],$module)) {
      $#inc = $pos-1; # truncate
      if ($pos == 0) {
        return;
      }
      $#inc = $pos-1;
      last;
    }
  }
  ### pruned to: @inc
  return @inc;
}
  
{
  my $orig = \&Module::Util::find_installed;

  sub Module_Util_Masked__find_installed ($;@) {
    my $module = shift;
    ### M-U-Masked find_installed(): $module

    my @inc = _pruned_inc($module, @_)
      or return undef;  # nothing after pruned
    ### @inc
    return &$orig($module,@inc);
  };
  no warnings 'redefine';
  *Module::Util::find_installed = \&Module_Util_Masked__find_installed;
}

{
  my $orig = \&Module::Util::all_installed;

  sub Module_Util_Masked__all_installed ($;@) {
    my $module = shift;
    ### M-U-Masked all_installed(): $module

    my @inc = _pruned_inc($module, @_)
      or return;  # nothing after pruned
    return &$orig($module,_pruned_inc($module, @_));
  };
  no warnings 'redefine';
  *Module::Util::all_installed = \&Module_Util_Masked__all_installed;
}

{
  my $orig = \&Module::Util::find_in_namespace;

  sub Module_Util_Masked__find_in_namespace ($;@) {
    my $namespace = shift;
    ### M-U-Masked find_in_namespace(): $namespace

    my @masks;
    my @ret;
    foreach my $elem (@_ ? @_ : @INC) {
      if (ref $elem
          && (Scalar::Util::refaddr($elem)
              == \&Test::Without::Module::fake_module
              || (Scalar::Util::blessed($elem)
                  && $elem->isa('Module::Mask')))) {
        push @masks, $elem;
      } else {
        my @found = &$orig($namespace, $elem);
        foreach my $mask (@masks) {
          @found = grep {! _elem_masks_module($mask,$_)} @found;
        }
        push @ret, @found;
      }
    }
    ### ret inc duplicates: @ret
    my %seen;
    return grep { !$seen{$_}++ } @ret;
  };
  no warnings 'redefine';
  *Module::Util::find_in_namespace = \&Module_Util_Masked__find_in_namespace;
}

1;
__END__


# sub _module_is_masked {
#   my ($module) = @_;
#   ### _module_is_masked(): $module
# 
#   if (Test::Without::Module->can('get_forbidden_list')) {
#     my $href = Test::Without::Module::get_forbidden_list();
#     if (exists $href->{$module}) {
#       ### no, Test-Without-Module forbidden
#       return 0;
#     }
#   }
# 
#   require Scalar::Util;
#   foreach my $inc (@INC) {
#     if (Scalar::Util::blessed($inc)
#         && $inc->isa('Module::Mask')
#         && $inc->is_masked($module)) {
#       ### no, Module-Mask masked
#       return 0;
#     }
#   }
#   return 0;
# }


=for stopwords Ryde Test-VariousBits

=head1 NAME

Module::Util::Masked - mangle Module::Util to recognise module masking

=head1 SYNOPSIS

 perl -MModule::Util::Masked \
      -MTest::Without::Module=Some::Thing \
      myprog.pl ...

 perl -MModule::Util::Masked \
      -MModule::Mask::Deps \
      myprog.pl ...

 # or within a script
 use Module::Util::Masked;
 use Module::Mask;
 my $mask = Module::Mask->new ('Some::Thing');

=head1 DESCRIPTION

This module mangles L<Module::Util> functions

    find_installed()
    all_installed()
    find_in_namespace()

to have them not return modules which are "masked" by any of

    Module::Mask
    Module::Mask::Deps
    Test::Without::Module

This is meant for testing, like those masking modules are meant for testing,
to pretend some modules are not available.  Making the "find" functions in
C<Module::Util> reflect the masking helps code which checks module
availability by a find rather than just an C<eval{require...}> or similar.

=head2 Load Order

C<Module::Util::Masked> should be loaded before anything which might import
the C<Module::Util> functions, so they don't grab them before the mangling.

Usually this means loading C<Module::Util::Masked> first, or early enough,
though there's no attempt to detect or enforce that currently.  A C<-M> on
the command line is good

    perl -MModule::Util::Masked myprog.pl ...

Or from the C<ExtUtils::MakeMaker> harness the same in the usual
C<HARNESS_PERL_SWITCHES> environment variable,

    HARNESS_PERL_SWITCHES="-MModule::Util::Masked" make test

Otherwise somewhere near the start of a script,

    use Module::Util::Masked;

Nothing actually changes in C<Module::Util> until one of the above mask
modules such as C<Test::Without::Module> is loaded and asked to mask some
modules.  Then the mangled C<Module::Util> will report such modules not
found.

The mangling cannot be undone, but usually there's no need to.  If some
modules should be made visible again then ask the masking
C<Test::Without::Module> or whichever to unmask.

=head2 Implementation

C<Module::Mask> is recognised by the object it adds to C<@INC>.
C<Module::Mask::Deps> is a subclass of C<Module::Mask> and is recognised
likewise.  C<Test::Without::Module> is recognised by the C<fake_module()>
coderef it adds to C<@INC> (which is not documented as such, so is a bit
dependent on the C<Test::Without::Module> implementation).

The masking object or coderef in C<@INC> is applied at the point it appears
in the C<@INC> list.  This means any directory in C<@INC> before the mask is
unaffected, the same way it's unaffected for a C<require> etc.  The masking
modules normally put themselves at the start of C<@INC> and are thus usually
meant to act on everything.

=head1 SEE ALSO

L<Module::Util>,
L<Module::Mask>,
L<Module::Mask::Deps>,
L<Test::Without::Module>

=head1 HOME PAGE

http://user42.tuxfamily.org/test-variousbits/index.html

=head1 COPYRIGHT

Copyright 2010, 2011 Kevin Ryde

Test-VariousBits is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License as published
by the Free Software Foundation; either version 3, or (at your option) any
later version.

Test-VariousBits is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
Public License for more details.

You should have received a copy of the GNU General Public License along
with Test-VariousBits.  If not, see <http://www.gnu.org/licenses/>.

=cut
