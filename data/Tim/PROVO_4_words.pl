use Fcntl;

print "\t\t\tPROVO_4_DA1 program (10/01/18)\n\nThis program reads a prepared fixation file from the PROVO corpus\nand outputs UMASS style DA1 files.\n";

print "Please enter the name of your prepared fixation file:  ";
$prepfix = <STDIN>; 
chomp ($prepfix);
open (INTEXT, $prepfix) or die "Can't open datafile: $!\n";

#print "Please provide output file extension (e.g., da1): ";
#$ext = <STDIN>; 
#chomp ($ext);   
print "Please enter the filename of the output words file: ";
$cntfile = <STDIN>;
chomp ($cntfile);
sysopen(FH, $cntfile, O_WRONLY|O_CREAT) or die "Can't open output file: $!\n";
$cond = 1;
while ($dataline = <INTEXT>) 
	{
		@paraline = split(/\s\s*/, $dataline); # this splits the line up using whitespace (tab or space) as the delimiter
		push(@item, $paraline[0]);
		push(@word, $paraline[2]);
		$linenumber = $paraline[4] - 1;
		push(@line, $linenumber);
	}
$numel = $#item;
print "$numel\n";
for($x = 0; $x < $numel + 1; $x++)
	{
			if($x == 0)
			{
				print(FH "E1");
				print(FH "I$item[$x]");
				print(FH "L$line[$x]\t");
				#print(FH "$word[$x] ");
				$currentline = $line[$x];
				$currentitem = $item[$x];
			}
			if(($currentline == $line[$x]) and ($currentitem == $item[$x]))
			{
				print(FH "$word[$x] ");
			}else
			{
				print(FH "\nE1");
				print(FH "I$item[$x]");
				print(FH "L$line[$x]\t");
				print(FH "$word[$x] ");
				$currentline = $line[$x];
				$currentitem = $item[$x];
			}
	}
close (INTEXT);
close (FH);
print("all finished");
<>