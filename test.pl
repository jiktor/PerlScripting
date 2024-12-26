#!\Strawberry\perl\bin\
use strict;
use warnings;

my $regex = qr/^(?<date>[0-9]{4}-[0-9]{2}-[0-9]{2})\s(?<timestamp>[0-9]{2}:[0-9]{2}:[0-9]{2})\s(?<name>[a-zA-Z]{2,})\s(?<command>.+)$/;
my $log_fh;
my $structure = {}; 

open ($log_fh, '<', 'log.txt') or die "log file couldn't be open";

while(my $line = <$log_fh>){
    print "line: " . $line;
    if ($line =~ $regex){
        print "matched";

        push(@{$structure -> {$+{name}} -> {$+{command}} -> {$+{date}}}, $+{timestamp});

    }else{
        die "the lline didn't match";
    }
}
#this code is for debugging reasons
use Data::Dumper;
print Dumper($structure);

my $exit = 0;
while(!$exit){
    print " Enter a number to choose what do you  want to do with the log file:\n 1: See the most commonly used commands:";
    $exit = <STDIN>;
    chomp($exit);

    if($exit eq "1"){
        my $occurances = {};

        foreach my $name(keys %$structure){  #foreach name
            foreach my $command(keys %{$structure -> {$name}}){     #foreach command
                foreach my $date(keys %{$structure -> {$name} -> {$command}}){ #foreach date
                    if($command =~ /^(?<com>command\s+\w+|\w+)/){
                        $occurances -> {$+{com}} += @{$structure -> {$name} -> {$command} -> {$date}};
                    }else{
                        die "couldn't match regex";
                    }
                }
            }
        }

        print "Printing the most commonly used commands based on the log file: \n";
        foreach my $command (sort { $occurances->{$b} <=> $occurances->{$a} } keys %$occurances) {
            print "$command: $occurances->{$command}\n";
        }
    }
    elsif($exit eq "2"){

    }
    elsif($exit eq "0"){
        $exit = 1;
    }
}
