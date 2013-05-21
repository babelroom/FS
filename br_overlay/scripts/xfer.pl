#!/usr/bin/perl

$|++;
print "pid: $$\n";

# ---
%vars = ();
foreach(<>) {
    chomp;
    next if not /^([^:]*):\s*(.*)$/;
    $vars{$1} = $2;
}

# ---
print "1=============: Origin K/V Pairs\n";
foreach my $k (keys %vars) {
    print "$k: $vars{$k}\n";
}

# ---
use Amazon::S3;

# ---
$s3 = undef;
$b = undef;
$result = undef;
sub err
{
    print "Msg: an error occurred $!\n";
    if (defined $b) {
        print "b_err: $b->err\n";
        print "b_errstr: $b->errstr\n";
        }
    exit -1;
}

# ---
$s3 = Amazon::S3->new({
        aws_access_key_id     => $vars{AWSAccessKeyId},
        aws_secret_access_key => $vars{AWSSecretAccessKey}
    });
err if not defined $s3; # don't expect an error from here
$b = $s3->bucket($vars{Bucket});
err if not defined $b;  # don't expect an error from here

# ---
$fullpath = $vars{Path};
$fullpath .= '/' . $vars{File};
$result = $b->add_key_filename(
    $vars{Key}, $fullpath,{
        content_type => $vars{'Content-Type'},
    });
err if not defined $result;
$result = $b->set_acl({
    key => $vars{Key},
    acl_short => 'public-read',
    });
err if not defined $result;
$result = $b->head_key($vars{Key});
err if not defined $result;
print "2=============: K/V Pairs from s3\n";
foreach my $k (keys %$result) {
    print "$k: $result->{$k}\n";
}

# --- done
print "3=============: Done\n";
print "Done: done\n";

