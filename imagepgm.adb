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
        num_rows, num_cols, max_gs: integer;
        fp: file_type; -- input file pointer
        type img_array is array (1..500, 1..500) of integer; 
        og_img: img_array;

        -- get input image dimensions to be able to store modified image in an array of that size
        procedure getHeaderInfo(fp: in out file_type; is_valid_file: in out boolean; n_rows: out integer; n_cols: out integer; max_gs: out integer) is
            magic_id, dimensions, max_gs_str: unbounded_string;
            first: positive;
            last: natural;
            idx: natural := 1;
            whitespace : constant Character_Set := To_Set (' ');
        begin 
            put_line("in getHeaderInfo");

            -- get header from file, line-by-line 
            get_line(fp, magic_id);
            get_line(fp, dimensions);
            get_line(fp, max_gs_str);

            -- error handling for magic identifier
            if magic_id /= "P2" then
                is_valid_file := false;
                put_line("Incorrect file format. The file must be in ASCII format (P2).");
                put_line("Exiting program...");
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

                -- store grayscale value as integer
                max_gs := integer'value(to_string(max_gs_str));
            end if;
        end getHeaderInfo;

        -- store image in integer array
        procedure getImagePixels(fp: in out file_type; img: out img_array) is 
            line_of_data: unbounded_string;
            first: positive;
            last: natural;
            str_idx: natural := 1;
            whitespace : constant Character_Set := To_Set (' ');
            row_idx, col_idx: integer := 0;
        begin
            put_line("in getImagePixels");
            -- get data (image) from file, line-by-line
            loop
                exit when end_of_file(fp);
                get_line(fp, line_of_data);

                row_idx := row_idx + 1; -- every loop iteration represents a row of image data
                col_idx := 1; -- reset column index once all current line data is read
                str_idx := 1; -- reset string index once all current line data is read
                -- break line of image data into substrings using whitespace delimiter
                while str_idx in to_string(line_of_data)'Range loop
                    Find_Token
                        (Source => line_of_data,
                        Set     => whitespace,
                        From    => str_idx,
                        Test    => Outside,
                        First   => first,
                        Last    => last);
                    exit when last = 0;
                    -- store values in integer variables
                    put_line("test " & to_string(line_of_data)(first..last));
                    img(row_idx, col_idx) := integer'value(to_string(line_of_data)(first..last));
                    col_idx := col_idx + 1;
                    str_idx := last + 1;
                end loop;
                put_line("The line read in was: " & line_of_data);
            end loop;
        end getImagePixels;

    begin
        put_line("in readPGM");
        put_line("The input file is: " & input_fname);
        open(fp, in_file, to_string(input_fname));
        
        -- get header info and perform error checking
        getHeaderInfo(fp, is_valid_file, num_rows, num_cols, max_gs);

        -- store image in integer array
        getImagePixels(fp, og_img);
        put_line("The image is:");
        for i in 1..num_rows loop
            put_line("line" & integer'image(i) & ":");
            for j in 1..num_cols loop
                put(integer'image(og_img(i,j)) & " ");
            end loop;
            new_line;
        end loop;
        
        close(fp);
    end readPGM;

    procedure writePGM(output_fname: in unbounded_string) is
    begin
        put_line("in writePGM");
        put_line("The output file is: " & output_fname);
    end writePGM;
end imagepgm;
