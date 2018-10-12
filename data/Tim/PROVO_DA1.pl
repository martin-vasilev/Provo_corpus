use Fcntl;

print "\t\t\tPROVO_4_DA1 program (10/01/18)\n\nThis program reads a prepared fixation file from the PROVO corpus\nand outputs UMASS style DA1 files.\n";

print "Please enter the name of your prepared fixation file:  ";
$prepfix = <STDIN>; 
chomp ($prepfix);
open (INTEXT, $prepfix) or die "Can't open datafile: $!\n";
#print "Please enter the filename of the output count file: ";
#$cntfile = <STDIN>;
#chomp ($cntfile);
sysopen(FH, $cntfile, O_WRONLY|O_CREAT) or die "Can't open output file: $!\n";
$cond = 1;
while ($line = <INTEXT>) 
	{
		@paraline = split(/\s\s*/, $line); # this splits the line up using whitespace (tab or space) as the delimiter
		#$numel = $#paraline; # gets the total number of elements on the line -- I don't know if this is needed or not
		#$conditem = $paraline[0]; # this is the condition/item identifier but there are no conditions in the PROVO corpus
		#@conditionitem = split(/I/,$conditem);
		#@itemcatch = split(/L/,$conditionitem[1]);
		push(@subnum, $paraline[0]);
		push(@item, $paraline[6]);
		push(@blink, $paraline[1]);
		push(@fixdur, $paraline[2]);
		push(@fixnum, $paraline[3]);
		push(@Xpos, $paraline[4]);
		push(@IAtop, $paraline[7]);
		push(@IAbottom, $paraline[8]);
		$xoffset = 170;
		#$itemtype = substr($cond, 0, 1);
		#substr($cond, 0, 1) = " ";       # delete first character
		#print(FH "\t$item\t$cond\t$line\t$numel\t");
		#print("$paraline[6]\n");
	}
$numel = $#linenum;
for($x = 0; $x < $numel + 1; $x++)
	{
		if($x == 0)
			{
				print(FH "\t$item[$x]\t$cond\t$linenum[$x]\t$numel\t$xoffset");
				$currentline = $linenum[$x];
				$currentitem = $item[$x];
			}
		if(($currentline == $linenum[$x]) and ($currentitem == $item[$x]))
			{
				print(FH "\t$IAright[$x]");
			}else
			{
				print(FH "\n\t$item[$x]\t$cond\t$linenum[$x]\t$numel\t$xoffset\t$IAright[$x]");
				$currentline = $linenum[$x];
				$currentitem = $item[$x];
			}
		}
close (INTEXT);
close (FH);
print("all finished");
<>