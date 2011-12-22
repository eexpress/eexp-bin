#!/usr/bin/perl

$_=`mimetype $ARGV[0]`;
die "$ARGV[0] is not an html file." if ! m"text/html";
open RC,"<$ARGV[0]"; @_=<RC>; close RC;

$_=join "", grep /<body/, @_;
/bgcolor="#(.*?)"/; print "\\colorbox[HTML]{$1}{\\begin{minipage}{0.8\\textwidth}\n";
/text="#(.*?)"/; $textcolor=uc($1);

for (@_){
next if /<title/;
s/\\/\\textbackslash /g;
s/&quot;/"/g; s/&gt;/>/g;s/&lt;/</g;
s/&nbsp;/\\quad /g; s/&amp;/\\&/g; 
s/[\$\%\#\_\^\{\}\~]/\\$&/g;
#s/[\$\&\%\#\_\^\{\}\~]/\\$&/g;
s|<font color="\\#(.*?)">(.*?)</font>|"\\color[HTML]{".uc($1)."}{$2}\\color[HTML]{$textcolor}"|eg;
s"<b>(.*?)</b>"\\textbf{$1}"g;
s/<.*?>//g;
next if /^$/;
s/$/\n/g;
print;

}
print "\\end{minipage}}";

#sub colortorgb{
#my $color=shift;
#$color=~s/\\#//; my @C=map {hex} $color=~/.{2}/g;
#return "$C[0],$C[1],$C[2]";
#}

