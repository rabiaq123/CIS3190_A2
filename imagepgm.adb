-- package body

with Ada.Text_IO; use Ada.Text_IO;

-- provide relevant error checking
-- readPGM() should take as input a filename and return a record representing the image
    -- generate an error if the wrong magic identifier is present,
    -- or if there are any other inconsistencies with the input file
-- writePGM() should take as input a record representing an image, and 
    -- write the image to file as a P2 PGM format

package body imagepgm is
    procedure readPGM is 
    begin
        put_line("in readPGM");
    end readPGM;

    procedure writePGM is
    begin
        put_line("in writePGM");
    end writePGM;
end imagepgm;
