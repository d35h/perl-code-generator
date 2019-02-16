use strict;
use warnings;
use Template;

my ($input, $template) = @ARGV;

die "Input file is not specified" unless defined($input);
die "Template file is not specified" unless defined($template);

local $/ = undef;
open my $fh, "<", $input;
close $input;

my @fields;
my @comments;
my $content = do { local $/; <$fh> };
my $message;

push @fields, [split /\s+/, $1] while $content =~ /(?<=F )(.*)/g;
push @comments, $1 while $content =~ /(?<=# )(.*)/g;
$message = $1 while $content =~ /(?<=M )(.*)/g;

my $vars = {
    fields => \@fields,
    comments => \@comments,
    message => $message,
};

my $tt = Template->new();
$tt->process($template, $vars);