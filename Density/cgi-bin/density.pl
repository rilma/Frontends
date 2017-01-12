#!/usr/bin/perl

print "Content-type: image/png \n\n";

&ParseForm();

sub ParseForm
{
        local($fields, $name, $value, $data);
        #Split standard input into fields
        $data=$ENV{"QUERY_STRING"};
        @fields = split(/&/, $data);
        #Split the fields into names and values, creating
        #an associative array indexed by the names
        foreach $item (@fields) {
                ($name, $value) = split(/=/, $item);
                $name = &UnescapeString($name);
                $value = &UnescapeString($value);
                $values{$name} = $value;
        }
}

#Unescape any special characters in a string
sub UnescapeString
{
        local($s) = $_[0];
        local($pos, $ascii);
        # Replace the + sign with spaces
        $s =~ s/\+/ /g;
        # Seek out and replace %xx hexadecimal escapes
        $pos = 0;
        while (($pos = index($s, "%", $pos)) != -1) {
                $ascii = hex(substr($s, $pos + 1, 2));
                substr($s, $pos, 3) = pack("c", $ascii);
        }
        $s;
}

open (IDL,"| /usr/local/bin/idl");
print IDL "density_dps, pp=100, figfilen='/dev/stdout'\n";
print IDL "exit\n";

exit 0;
