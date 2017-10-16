#!/usr/bin/perl

# perl aln_fasta_return_length.pl 1GFC.A.sl.40.su.99.fl.30.ll.30.pu.50.out.aln 1GFC:A
#

use strict;
use warnings;
use Data::Dumper;

@ARGV == 2 or die("Usage: [alignment] [query_pdb_id]");

my $alignment    = $ARGV[0];
my $query_pdb_id = $ARGV[1];

my @seqids;
my @sequence_fragments;
my @sequences;

# READ IN FASTA ALIGNMENT

open( ALIGNMENT, $alignment ) or die("Can't open $alignment\n");
while ( my $line = <ALIGNMENT> ) {

    chomp $line;

    if ( $line =~ /^>/ ) {
        $line =~ s/^>//;
        my @buf = split( /\s+/, $line );
        push @seqids, $buf[0];

        my $sequence_joined = join( "", @sequence_fragments );
        push @sequences, $sequence_joined;
        @sequence_fragments = ();

    }

    else {
        push @sequence_fragments, $line;
    }
}

# needed for last sequence
my $sequence_joined = join( "", @sequence_fragments );
push @sequences, $sequence_joined;
@sequence_fragments = ();

close ALIGNMENT;

shift(@sequences);    # first element is blank, so remove it

my %fasta_sequences;
@fasta_sequences{@seqids} = @sequences;

my $aln_length = length( $fasta_sequences{$query_pdb_id} );
print "$aln_length";

=for
LICENSE AND COPYRIGHT

Copyright (C) 2015 Fiserlab Members 

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

