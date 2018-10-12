use Fcntl;

print "\t\t\tPROVOcount program (09/01/18)\n\nThis program reads a prepared text file and creates a line by line count file\nfor paragraph analyses.\n";

print "Please enter the name of your prepared text file:  ";
$preptext = <STDIN>; 
chomp ($preptext);
open (INTEXT, $preptext) or die "Can't open datafile: $!\n";
print "Please enter the filename of the output count file: ";
$cntfile = <STDIN>;
chomp ($cntfile);
sysopen(FH, $cntfile, O_WRONLY|O_CREAT) or die "Can't open output file: $!\n";
$cond = 1;
while ($line = <INTEXT>) 
	{
		@paraline = split(/\s\s*/, $line); # this splits the line up using whitespace (tab or space) as the delimiter
		#$numel = $#paraline; # gets the total number of elements on the line -- I don't know if this is needed or not
		#$conditem = $paraline[0]; # this is the condition/item identifier but there are no conditions in the PROVO corpus
		#@conditionitem = split(/I/,$conditem);
		#@itemcatch = split(/L/,$conditionitem[1]);
		$linenumber = ($paraline[4]-1);
		push(@linenum, $linenumber);
		push(@item, $paraline[0]);
		push(@word, $paraline[2]);
		push(@wordNline, $paraline[3]);
		push(@IAleft, $paraline[5]);
		push(@IAright, $paraline[6]);
		push(@IAtop, $paraline[7]);
		push(@IAbottom, $paraline[8]);
		$xoffset = 170;
		#$itemtype = substr($cond, 0, 1);
		#substr($cond, 0, 1) = " ";       # delete first character
		#print(FH "\t$item\t$cond\t$line\t$numel\t");
		#print("$paraline[6]\n");
	}
$numel = $#linenum;
for($y = 0; $y < $numel + 1; $y++)
{
	if($wordNline[$y+1]<=$wordNline[$y])
	{
		$item2 = $item[$y];
		$linenum2 = $linenum[$y];
		$numwordsonline[$item2][$linenum2] = $wordNline[$y];
	}
}
for($x = 0; $x < $numel + 1; $x++)
	{
		if($x == 0)
			{
				$item3 = $item[$x];
				$linenum3 = $linenum[$x];
				print(FH "\t$item[$x]\t$cond\t$linenum[$x]\t$numwordsonline[$item3][$linenum3]\t$xoffset");
				$currentline = $linenum[$x];
				$currentitem = $item[$x];
			}
		if(($currentline == $linenum[$x]) and ($currentitem == $item[$x]))
			{
				print(FH "\t$IAright[$x]");
			}else
			{
				$item3 = $item[$x];
				$linenum3 = $linenum[$x];
				print(FH "\n\t$item[$x]\t$cond\t$linenum[$x]\t$numwordsonline[$item3][$linenum3]\t$xoffset\t$IAright[$x]");
				$currentline = $linenum[$x];
				$currentitem = $item[$x];
			}
		}
close (INTEXT);
close (FH);
print("all finished");
<>