-- package body

with Ada.Text_IO; use Ada.Text_IO;
with ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;
with Ada.Strings.Maps; use Ada.Strings.Maps;
with Ada.Strings; use Ada.Strings;
 
package body imagepgm is

    -- take filename as input and return a record representing the image
    -- include error checking for magic identifier and other inconsistencies with the input file
    procedure readPGM(img_rec: in out img_record; input_fname: in unbounded_string; is_valid_file: in out boolean) is 
        fp: file_type;

        -- get input image dimensions to be able to store modified image in an array of that size
        procedure getHeaderInfo(fp: in out file_type; is_valid_file: in out boolean; img_rec: in out img_record) is
            magic_id, dimensions, max_gs_str: unbounded_string;
            first: positive;
            last: natural;
            idx: natural := 1;
            whitespace : constant Character_Set := To_Set (' ');
        begin 
            -- get header from file, line-by-line 
            get_line(fp, magic_id);
            get_line(fp, dimensions);
            get_line(fp, max_gs_str);

            -- error handling for magic identifier
            if magic_id /= "P2" then
                is_valid_file := false;
                put_line("Incorrect file format. The file must be in ASCII format (P2).");
            end if;
            if is_valid_file then
                -- break string containing dimensions into substrings using whitespace delimiter
                -- resource used: https://learn.adacore.com/courses/intro-to-ada/chapters/standard_library_strings.html#string-operations
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
                        img_rec.cols := integer'value(to_string(dimensions)(first..last));
                    else 
                        img_rec.rows := integer'value(to_string(dimensions)(first..last));
                    end if;
                    idx := last + 1;
                end loop;

                -- store grayscale value as integer
                img_rec.max_gs := integer'value(to_string(max_gs_str));
            end if;
        end getHeaderInfo;

        -- store image in image record
        procedure getImagePixels(fp: in out file_type; is_valid_file: in out boolean; img_rec: in out img_record) is 
            line_of_data: unbounded_string;
            first: positive;
            last: natural;
            str_idx: natural := 1;
            whitespace : constant Character_Set := To_Set (' ');
            row_idx, col_idx: integer := 0;
        begin
            -- get data (image) from file, line-by-line
            loop
                exit when end_of_file(fp) or is_valid_file = false;
                get_line(fp, line_of_data);
                row_idx := row_idx + 1; -- every loop iteration represents a row of image data
                -- reset column and string indices once all current line data is read
                col_idx := 1; 
                str_idx := 1;
                -- break line of image data into substrings using whitespace delimiter
                -- resource used: https://learn.adacore.com/courses/intro-to-ada/chapters/standard_library_strings.html#string-operations
                while str_idx in To_String (line_of_data)'Range loop
                    Find_Token
                        (Source => line_of_data,
                        Set     => whitespace,
                        From    => str_idx,
                        Test    => Outside,
                        First   => first,
                        Last    => last);
                    exit when last = 0;
                    -- store values in integer variables
                    img_rec.pixel(row_idx, col_idx) := integer'value(to_string(line_of_data)(first..last));
                    -- error handling for invalid image data
                    if img_rec.pixel(row_idx, col_idx) > img_rec.max_gs or img_rec.pixel(row_idx, col_idx) < 0 then
                        is_valid_file := false;
                        put_line("Incorrect image contents; your image pixels must be within the range 0 -" & integer'image(img_rec.max_gs) & ".");
                    end if;
                    col_idx := col_idx + 1;
                    str_idx := last + 1;
                end loop;
            end loop;
        end getImagePixels;

    begin
        -- store PGM file contents
        open(fp, in_file, to_string(input_fname));
        getHeaderInfo(fp, is_valid_file, img_rec);
        getImagePixels(fp, is_valid_file, img_rec);
        close(fp);
    end readPGM;

    -- take image record as input, and write the image to file as a P2 PGM format
    procedure writePGM(output_fname: in unbounded_string; img_modified: in img_record) is
        fp: file_type;
    begin
        put_line("You can view your input images and the output created through https://ij.imjoy.io/.");
        create(fp, out_file, to_string(output_fname));
        set_output(fp);
        put_line("P2");
        put_line(integer'image(img_modified.cols) & integer'image(img_modified.rows));
        put_line(integer'image(img_modified.max_gs));
        for i in 1..img_modified.rows loop
            for j in 1..img_modified.cols loop
                put(integer'image(img_modified.pixel(i,j)));
            end loop;
            new_line;
        end loop;
        set_output(standard_output);
        close(fp);
    end writePGM;
end imagepgm;
