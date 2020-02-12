#!env perl

use strict;

my @STACK = ();
my @PROGRAM = ();
my $PC = 0;

my @JEFFTYPES;

sub jpop {
    die "STACK HAS BEEN JEFFED @ $PC"
	unless (scalar @STACK);

    pop @STACK;
}

sub jpush {
    my $val = shift;
    push @STACK, $val;
}

sub getjeff {
    my $v = shift;
    
    if ($v > scalar @JEFFTYPES) {
	die "JEFFY LOOKUP FAILED @ $PC";
    }

    return @JEFFTYPES[$v];
    
}

my %OPERATORS;

my %OPERATORS = (
    jeff => sub {
	jpush(jpop() + jpop());
    },
    JEFF => sub {
	print jpop(), "\n";
    },
    geoff => sub {
	jeffset(jpop(), jpop());
    },
    GEOFF => sub {
	jeffget(jpop());
    },
    jeffy => sub {
	my $o = getjeff(jpop());
	&{ $OPERATORS{ $o } }();
    },
    jeffrey => sub {
	print getjeff(jpop()), "\n";
    },
    jiggly => sub {
	$PC = jpop();
    },
    jeffro => sub {
	if (jpop() > 0) {
	    $PC += 2;
	}
    },
    jefferson => sub {
	my $v = jpop();
	jpush($v);
	jpush($v);
    },
    jeffjeff => sub {
	my $v = jpop();
	my $t = jpop();
	jpush($v);
	jpush($t);
    },
    );

@JEFFTYPES = sort keys %OPERATORS;


while (<STDIN>)
{
    chomp;
    my @tokens = split(/\s+/);
    foreach my $token (@tokens) {
	push @PROGRAM, $token;
    }
}

while ($PC >= 0 && $PC < (scalar @PROGRAM))
{
    my $token = $PROGRAM[$PC];
    if ($token =~ /^-*[0-9]+$/) {
	push @STACK, $token;
	$PC++;
    }
    elsif (exists $OPERATORS{$token}) {
	my $tpc = $PC;
	&{ $OPERATORS{$token} }();

	unless ($tpc != $PC) {
	    $PC++;
	}
    }
    else {
	die "UNKNOWN JEFF @ $PC: $token";
    }
}

print "\nJEFF DONE.\n";
