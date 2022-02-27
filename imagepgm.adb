-- package body

with Ada.Text_IO; use Ada.Text_IO;
with ada.strings.unbounded; use ada.strings.unbounded;
with ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;

-- provide relevant error checking
-- readPGM() should take as input a filename and return a record representing the image
    -- generate an error if the wrong magic identifier is present,
    -- or if there are any other inconsistencies with the input file
-- writePGM() should take as input a record representing an image, and 
    -- write the image to file as a P2 PGM format

package body imagepgm is
    procedure readPGM(input_fname: in unbounded_string) is 
    begin
        put_line("in readPGM");
        put_line("The input file is: " & input_fname);
    end readPGM;

    procedure writePGM(output_fname: in unbounded_string ) is
    begin
        put_line("in writePGM");
        put_line("The output file is: " & output_fname);
    end writePGM;
end imagepgm;
