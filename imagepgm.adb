-- package body

with Ada.Text_IO; use Ada.Text_IO;
with ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;
with Ada.Strings.Maps; use Ada.Strings.Maps;
with Ada.Strings; use Ada.Strings;

 
package body imagepgm is

    -- take filename as input and return a record representing the image
    -- include error checking for magic identifier and other inconsistencies with the input file
    procedure readPGM(img_read: in out img_record; input_fname: in unbounded_string; is_valid_file: in out boolean) is 
        fp: file_type;
        num_rows, num_cols, max_gs: integer;
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
                -- reset column and string indices once all current line data is read
                col_idx := 1; 
                str_idx := 1;
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
                    img(row_idx, col_idx) := integer'value(to_string(line_of_data)(first..last));
                    col_idx := col_idx + 1;
                    str_idx := last + 1;
                end loop;
            end loop;
        end getImagePixels;

        -- store image file data in record
        procedure storeInRecord(img_read: in out img_record; num_cols: in integer; num_rows: in integer; og_img: in img_array) is 
        begin
            put_line("in storeInRecord");
            img_read.cols := num_cols;
            img_read.rows := num_rows;
            for i in 1..num_rows loop
                for j in 1..num_cols loop
                    img_read.pixel(i,j) := og_img(i,j);
                end loop;
            end loop;
        end storeInRecord;

    begin
        put_line("in readPGM");
        -- store PGM file contents
        open(fp, in_file, to_string(input_fname));
        getHeaderInfo(fp, is_valid_file, num_rows, num_cols, max_gs);
        getImagePixels(fp, og_img);
        close(fp);
        -- store values in record
        storeInRecord(img_read, num_cols, num_rows, og_img);
    end readPGM;

    -- take image record as input, and write the image to file as a P2 PGM format
    procedure writePGM(output_fname: in unbounded_string) is
    begin
        put_line("in writePGM");
        put_line("You can view your input images and the output created through https://ij.imjoy.io/");
    end writePGM;
end imagepgm;
