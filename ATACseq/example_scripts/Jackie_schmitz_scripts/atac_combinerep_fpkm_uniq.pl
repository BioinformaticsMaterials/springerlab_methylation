#! /usr/bin/perl -w
# combine 100bp atacseq counts for rep 1 and rep 2 for each genotype and tissue
# atac_rep_combine.pl
# 18_Jan_2017
# Jaclyn_Noshay

use warnings;
use strict;
use Getopt::Std;

#set soft coded files
my $usage = "\n0 -i in -o out\n";
our ($opt_i, $opt_o, $opt_h);
getopts("i:o:h") || die "$usage";

#check that all files are defined
if ( (!(defined $opt_i)) || (!(defined $opt_o)) || (defined $opt_h) ) {
  print "$usage";
}

#read in files 
open (my $in_fh, '<', $opt_i) || die;
open (my $out_fh, '>', $opt_o) || die;

my ($x207_Leaf2, $x207_Root2, $B73_Leaf2, $B73_Root2, $PHJ89_Leaf2, $W22_Leaf2, $W22_Root2);

print $out_fh "binid\t207_Leaf\t207_Root\tB73_Leaf\tB73_Root\tPHJ89_Leaf\tW22_Leaf\tW22_Root\n";

my $header = <$in_fh>;
while (my $line = <$in_fh>) {
  chomp $line;
  my ($binid, $x207_Leaf, $x207_Root, $B73_Leaf, $B73_Root, $PHJ89_Leaf, $W22_Leaf, $W22_Root) = split ("\t", $line);

  if (!($x207_Leaf eq "N/A")) {
    $x207_Leaf2 = ($x207_Leaf / ((655894 + 13225233)/2)) * 10000000;
  }
  else {
    $x207_Leaf2 = 'N/A';
  }
  
  if (!($x207_Root eq "N/A")) {
    $x207_Root2 = ($x207_Root / ((14345026 + 12634918)/2)) * 10000000;
  }
  else {
    $x207_Root2 = 'N/A';
  }
  
  if (!($B73_Leaf eq "N/A")) {
    $B73_Leaf2 = ($B73_Leaf / ((12197384 + 11475564)/2)) * 10000000;
  }
  else {
    $B73_Leaf2 = 'N/A';
  }
  
  if (!($B73_Root eq "N/A")) {
    $B73_Root2 = ($B73_Root / ((22785968 + 8837209)/2)) * 10000000;
  }
  else {
    $B73_Root2 = 'N/A';
  }
  
  if (!($PHJ89_Leaf eq "N/A")) {
    $PHJ89_Leaf2 = ($PHJ89_Leaf / (8837209)) * 10000000;
  }
  else {
    $PHJ89_Leaf2 = 'N/A';
  }
  
  if (!($W22_Leaf eq "N/A")) {
    $W22_Leaf2 = ($W22_Leaf / ((2958291 + 3327143)/2)) * 10000000;
  }
  else {
    $W22_Leaf2 = 'N/A';
  }
  
  if (!($W22_Root eq "N/A")) {
    $W22_Root2 = ($W22_Root / (7448706)) * 10000000;
  }
  else {
    $W22_Root2 = 'N/A';
  }
  
  #print $out_fh "$binid\t$x207_Leaf\t$x207_Root\t$B73_Leaf\t$B73_Root\t$PHJ89_Leaf\t$W22_Leaf\t$W22_Root\n";
  print $out_fh "$binid\t$x207_Leaf2\t$x207_Root2\t$B73_Leaf2\t$B73_Root2\t$PHJ89_Leaf2\t$W22_Leaf2\t$W22_Root2\n";
  
}

close $in_fh;
close $out_fh;
exit;

  
    
