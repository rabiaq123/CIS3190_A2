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
    procedure readPGM(input_fname: in unbounded_string; is_valid_file: in out boolean) is 
        num_rows, num_cols: integer;
        fp: file_type; -- input file pointer

        -- get input image dimensions to be able to store modified image in an array of that size
        procedure getHeaderInfo(fp: in out file_type; is_valid_file: in out boolean; n_rows: out integer; n_cols: out integer) is
            magic_id, dimensions: unbounded_string;
            first: positive;
            last: natural;
            idx: natural := 1;
            whitespace : constant Character_Set := To_Set (' ');
        begin 
            put_line("in getHeaderInfo");

            -- read second line of input file
            get_line(fp, magic_id); -- image format, should always be P2
            get_line(fp, dimensions); -- image dimensions

            -- error handling for magic identifier
            if magic_id /= "P2" then
                put_line("Incorrect file format. The file must be in ASCII format (P2).");
                put_line("Exiting program...");
                is_valid_file := false;
            end if;

            if is_valid_file then
                -- break string containing dimensions into substrings using whitespace delimiter
                while idx in to_string(dimensions)'Range loop
                    Find_Token
                        (Source => dimensions,
                        Set     => whitespace,
                        From    => idx,
                        Test    => Outside,
                        First   => first,
                        Last    => last);
                    exit when last = 0;

                    -- store values in integer variables
                    if idx = 1 then
                        n_cols := integer'value(to_string(dimensions)(first..last));
                    else 
                        n_rows := integer'value(to_string(dimensions)(first..last));
                    end if;
                    idx := last + 1;
                end loop;
                put_line("num cols is:" & integer'image(n_cols) & " and num rows is:" & integer'image(n_rows) );
            end if;
        end getHeaderInfo;

    begin
        put_line("in readPGM");
        put_line("The input file is: " & input_fname);
        -- get header info and perform error checking
        open(fp, in_file, to_string(input_fname));
        getHeaderInfo(fp, is_valid_file, num_rows, num_cols);
        close(fp);
    end readPGM;

    procedure writePGM(output_fname: in unbounded_string ) is
    begin
        put_line("in writePGM");
        put_line("The output file is: " & output_fname);
    end writePGM;
end imagepgm;
