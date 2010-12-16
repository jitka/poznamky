#!/usr/bin/perl
use strict;
use warnings;

my ($width, $height);
while (<>) {
	last if (($width, $height) = /<page width="(.*)" height="(.*)">/);
}

print <<'SVG';
<?xml version="1.0" encoding="UTF-8" standalone="no"?>

<svg
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:cc="http://creativecommons.org/ns#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:svg="http://www.w3.org/2000/svg"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
SVG
print "width='$width' height='$height'\n";
print <<'SVG';
   id="svg"
   version="1.1"
   inkscape:version="0.48.0 r9654"
   sodipodi:docname="New document 1">
  <defs
     id="defs4" />
  <sodipodi:namedview
     id="base"
     pagecolor="#ffffff"
     bordercolor="#666666"
     borderopacity="1.0"
     inkscape:pageopacity="0.0"
     inkscape:pageshadow="2"
     inkscape:zoom="0.35"
     inkscape:cx="375"
     inkscape:cy="520"
     inkscape:document-units="px"
     inkscape:current-layer="layer1"
     showgrid="false"
     inkscape:window-width="1364"
     inkscape:window-height="766"
     inkscape:window-x="0"
     inkscape:window-y="0"
     inkscape:window-maximized="0" />
  <metadata
     id="metadata7">
    <rdf:RDF>
      <cc:Work
         rdf:about="">
        <dc:format>image/svg+xml</dc:format>
        <dc:type
           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
        <dc:title></dc:title>
      </cc:Work>
    </rdf:RDF>
  </metadata>
  <g
     inkscape:label="Layer 1"
     inkscape:groupmode="layer"
     id="layer1">
SVG

my($color, $id);
my @data;
while (<>) {
	if (/<stroke [^>]* color="([^']+)" width="([.0-9]+)">/) {
		$color = $1;
		$width = $2;
		@data = ();
	} elsif (/<\/stroke>/) {
		$id ++;
		print "<path style='fill:none;stroke:$color;stroke-width:${width}px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1' id='p$id' d='";
		my $sign = 'M';
		while(my($x, $y) = splice @data, 0, 2) {
			print "$sign $x,$y ";
			$sign = 'L';
		}
		print "'/>\n";
		undef $color;
	} elsif ($color) {
		push @data, split;
	} elsif (s/<text font="([^"]+)" size="([^"]+)" x="([^"]+)" y="([^"]+)" color="([^"]+)">//) {
		my $font = $1;
		my $width = $2;
		my $x = $3;
		my $y = $4;
		my $color = $5;
		until ($_ =~ s/<\/text>.*//) {
			$_ .= <>;
		}
		chomp;
		$id ++;
		print "<text xml:space='preserve' style='font-size:${width}px;font-style:normal;font-weight:normal;line-height:125%;letter-spacing:0px;word-spacing:0px;fill:$color;fill-opacity:1;stroke:none;font-family:$font' x='$x' y='$y' id='t$id'><tspan x='$x' y='$y' id='s$id'>$_</tspan></text>\n";
	}
}

print <<'SVG';
  </g>
</svg>
SVG
