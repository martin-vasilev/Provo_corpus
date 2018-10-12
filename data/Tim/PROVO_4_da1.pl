use Fcntl;

print "\t\t\tPROVO_4_DA1 program (10/01/18)\n\nThis program reads a prepared fixation file from the PROVO corpus\nand outputs UMASS style DA1 files.\n";

print "Please provide the extra PROVO word file: ";
$PROVO = <STDIN>;
chomp ($PROVO);
open (PData, $PROVO) or die "Can't open PROVO file: $!\n";
while ($PROVOdata = <PData>) 
	{
		@Provoline = split(/\s\s*/, $PROVOdata); # this splits the line up using whitespace (tab or space) as the delimiter
		push(@item2, $Provoline[0]);
		push(@numword, $Provoline[1]);
		push(@word, $Provoline[2]);
		push(@numwordline, $Provoline[3]);
		push(@linenum, $Provoline[4]);
		push(@x1, $Provoline[5]);
		push(@x2, $Provoline[6]);
		push(@y1, $Provoline[7]);
		push(@y2, $Provoline[8]);
	}
print "Please enter the name of your prepared fixation file:  ";
$prepfix = <STDIN>; 
chomp ($prepfix);
open (INTEXT, $prepfix) or die "Can't open datafile: $!\n";

#print "Please provide output file extension (e.g., da1): ";
#$ext = <STDIN>; 
#chomp ($ext);   
#print "Please enter the filename of the output count file: ";
#$cntfile = <STDIN>;
#chomp ($cntfile);
#sysopen(FH, $cntfile, O_WRONLY|O_CREAT) or die "Can't open output file: $!\n";
$cond = 1;
$counter = -1;
while ($line = <INTEXT>) 
	{
		@paraline = split(/\s\s*/, $line); # this splits the line up using whitespace (tab or space) as the delimiter
		#$numel = $#paraline; # gets the total number of elements on the line -- I don't know if this is needed or not
		#$conditem = $paraline[0]; # this is the condition/item identifier but there are no conditions in the PROVO corpus
		#@conditionitem = split(/I/,$conditem);
		#@itemcatch = split(/L/,$conditionitem[1]);
		$counter = $counter + 1;
		$oneback = $counter - 1;
		push(@subnum, $paraline[0]);
		push(@item, $paraline[1]);
		push(@blink, $paraline[2]);
		push(@blinkNext, $paraline[3]);
		push(@fixdur, $paraline[4]);
		push(@fixnum, $paraline[5]);
		if(($paraline[5] == 1) and ($counter > 0))
		{
		$subject = $subnum[$oneback];
		$itemnum = $item[$oneback];
		$fixcount[$subject][$itemnum] = $fixnum[$oneback];
		#print "$subject\t$itemnum\t$fixcount[$subject][$itemnum]\n";
		}
		$linepos = -1;
		for($z = 0; $z < $#x1 + 1; $z++)
		{ 
			if(($paraline[6] >= $x1[$z]) and ($paraline[6] < $x2[$z]))
			{
				if(($paraline[7] >= $y1[$z]) and ($paraline[7] < $y2[$z]))
				{
					$linepos = $linenum[$z] - 1;
					$z = $#x1 + 1;
				}
			}
		}
		push(@Ypos, $linepos);
		push(@Xpos, $paraline[6]);
		$startime = $paraline[9] - 1;
		push(@fixstart, $startime);
		push(@fixend, $paraline[8]);
		push(@sacstart, $paraline[11]);
		push(@sacend, $paraline[10]);
		#$xoffset = 170;
		#$itemtype = substr($cond, 0, 1);
		#substr($cond, 0, 1) = " ";       # delete first character
		#print(FH "\t$item\t$cond\t$line\t$numel\t");
		#print("$paraline[6]\n");
	}
$numel = $#subnum;
$numel2 = $#Ypos;
$trialnum = 1;
print "$numel\t$numel2\n";
for($x = 0; $x < $numel + 1; $x++)
	{
			if($x == 0)
			{
				$subject = $subnum[$x];
				$itemnum = $item[$x];
				$da1file = "${subnum[$x]}.da1";
				print "$da1file\n";
				sysopen(FH, $da1file, O_WRONLY|O_CREAT) or die "Can't open output file: $!\n";
				print(FH "$trialnum\t$cond\t$item[$x]\tNA\tNA\tNA\tNA\t$fixcount[$subject][$itemnum]");
				$currentsub = $subnum[$x];
				$currentitem = $item[$x];
			}
			if(($currentsub eq $subnum[$x]) and ($currentitem == $item[$x]))
			{
				print(FH "\t$Xpos[$x]\t$Ypos[$x]\t$fixstart[$x]\t$fixend[$x]\t$blink[$x]");
			}elsif($currentsub eq $subnum[$x])
			{
				$trialnum++;
				#print "$trailnum\n";
				if($trialnum < 56)
				{
				$subject = $subnum[$x];
				$itemnum = $item[$x];
				print(FH "\n$trialnum\t$cond\t$item[$x]\tNA\tNA\tNA\tNA\t$fixcount[$subject][$itemnum]\t$Xpos[$x]\t$Ypos[$x]\t$fixstart[$x]\t$fixend[$x]\t$blink[$x]");
				$currentsub = $subnum[$x];
				$currentitem = $item[$x];
				}
			}else
			{
				close (FH);
				$trialnum = 1;
				$da1file = "${subnum[$x]}.da1";
				print "$da1file\n";
				sysopen(FH, $da1file, O_WRONLY|O_CREAT) or die "Can't open output file: $!\n";
				$subject = $subnum[$x];
				$itemnum = $item[$x];
				print(FH "$trialnum\t$cond\t$item[$x]\tNA\tNA\tNA\tNA\t$fixcount[$subject][$itemnum]");
				$currentsub = $subnum[$x];
				$currentitem = $item[$x];
			}
	}
close (INTEXT);
close (FH);
print("all finished");
<>