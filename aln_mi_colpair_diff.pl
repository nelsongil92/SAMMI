#!/usr/bin/perl

# takes difference between mutual information values of identical column pairs
# intended for use to compare MI between an alignment and its column-shuffled version

@ARGV == 2 or die("Usage: [aln_mi_mat] [aln_colshuffle_mi_mat]\n");

my $aln_mi_mat            = $ARGV[0];
my $aln_mi_mat_colshuffle = $ARGV[1];

my @colpairs;
my @mi_mat;
my @mi_mat_colshuffle;

open( ALN_MI_MAT, $aln_mi_mat ) or die("Can't open $aln_mi_mat\n");
while ( my $line = <ALN_MI_MAT> ) {
    my @buf = split( /\s+/, $line );
    push @colpairs, $buf[1];
    push @mi_mat,   $buf[4];

}
close ALN_MI_MAT;

open( ALN_MI_MAT_COLSHUFFLE, $aln_mi_mat_colshuffle )
  or die("Can't open $aln_mi_mat_colshuffle\n");
while ( my $line = <ALN_MI_MAT_COLSHUFFLE> ) {
    my @buf = split( /\s+/, $line );
    push @mi_mat_colshuffle, $buf[4];

}
close ALN_MI_MAT_COLSHUFFLE;

for ( my $i = 0 ; $i < scalar(@mi_mat) ; $i++ ) {

    my $diff = $mi_mat[$i] - $mi_mat_colshuffle[$i];
    if ( $diff < 0 ) { $diff = 0; }
    print "ColPair $colpairs[$i] MI_Diff = $diff bits\n";

}

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

