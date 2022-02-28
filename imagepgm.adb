-- package body

with Ada.Text_IO; use Ada.Text_IO;
with ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;
with Ada.Strings.Maps; use Ada.Strings.Maps;
with Ada.Strings; use Ada.Strings;

-- provide relevant error checking
-- readPGM() should take as input a filename and return a record representing the image
    -- generate an error if the wrong magic identifier is present,
    -- or if there are any other inconsistencies with the input file
-- writePGM() should take as input a record representing an image, and 
    -- write the image to file as a P2 PGM format
 
package body imagepgm is
    procedure readPGM(input_fname: in unbounded_string) is 
        num_rows, num_cols: integer;

        -- get input image dimensions to be able to store modified image in an array of that size
        procedure getHeaderInfo(filename: in unbounded_string; n_rows: out integer; n_cols: out integer) is
            fp: file_type; -- input file pointer
            line_read: unbounded_string; -- line in file
            first: positive;
            last: natural;
            idx: natural := 1;
            whitespace : constant Character_Set := To_Set (' ');
        begin 
            put_line("in getHeaderInfo");

            -- read second line of input file
            open(fp, in_file, to_string(filename));
            get_line(fp, line_read); -- first line (image format, will always be P2)
            get_line(fp, line_read); -- second line (image dimensions)
            close(fp);

            -- break string into substrings using whitespace delimiter
            while idx in to_string(line_read)'Range loop
                Find_Token
                    (Source => line_read,
                    Set     => whitespace,
                    From    => idx,
                    Test    => Outside,
                    First   => first,
                    Last    => last);
                exit when last = 0;

                -- store values in integer variables
                if idx = 1 then
                    n_cols := integer'value(to_string(line_read)(first..last));
                else 
                    n_rows := integer'value(to_string(line_read)(first..last));
                end if;
                idx := last + 1;
            end loop;
            put_line("num cols is:" & integer'image(n_cols) & " and num rows is:" & integer'image(n_rows) );
        end getHeaderInfo;

    begin
        put_line("in readPGM");
        put_line("The input file is: " & input_fname);
        -- get header info and perform error checking
        getHeaderInfo(input_fname, num_rows, num_cols);
    end readPGM;

    procedure writePGM(output_fname: in unbounded_string ) is
    begin
        put_line("in writePGM");
        put_line("The output file is: " & output_fname);
    end writePGM;
end imagepgm;
