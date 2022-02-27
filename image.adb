-- Rabia Qureshi
-- 1046427
-- March 4, 2022

-- Ada program to perform image processing operations on a grayscale image
-- stored in an ASCII P2 PGM format

with ada.Text_IO; use Ada.Text_IO;
--with ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with ada.strings.unbounded; use ada.strings.unbounded;
with ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;
with ada.directories; use ada.directories;
--with Ada.Exceptions; use Ada.Exceptions;
with Ada.Strings.Maps; use Ada.Strings.Maps;
with Ada.Strings; use Ada.Strings;

with imagepgm; use imagepgm;
with imageprocess; use imageprocess;

-- main wrapper program

-- allows user to interact with the imagePROCESS and imagePGM packages; reading in images,
-- manipulating them, and writing them to file

-- include subprogram getFilename() to ask user for the name of the file to be read or written. 
-- An example call might be: fn = getFilename(“r”) to obtain the filename of an image to read.


procedure image is
    type ftype is (input, output);
    type img_array is array (integer range <>, integer range <>) of integer; 
    input_fname, output_fname: unbounded_string;
    num_rows, num_cols: integer;

    -- print main program info to user
    procedure welcomeUser is 
    begin
        put_line("IMAGE PROCESSING PROGRAM"); new_line;
        put_line("Welcome! This ADA program can perform image processing operations on " &
                "any grayscale image stored in an ASCII P2 PGM format.");
        put_line("You can view your input images and the output created through " &
                "https://ij.imjoy.io/"); new_line;
    end welcomeUser;

    -- ask user for the name of the file to be read or written, and handle exceptions
    function getFilename(fileType: ftype) return unbounded_string is 
        filename: unbounded_string;
        is_valid_file: boolean := false;
        response: character;
    begin 
        while is_valid_file = false loop
            -- prompt changes depending on whether input or output filename is needed
            if fileType = input then
                put("Enter the name of the file to be read: ");
                get_line(filename);
                if (filename /= "") then
                    if exists(to_string(filename)) = true then
                        is_valid_file := true;
                    end if;
                end if;
            else 
                <<getName>>
                put("Enter the name of the file to be written to: ");
                get_line(filename);
                if (filename /= "") then
                    if exists(to_string(filename)) = true then
                        is_valid_file := false;
                    else
                        is_valid_file := true;
                    end if;
                else
                    put("Invalid output filename. ");
                    goto getName;
                end if;
            end if;
            -- loop until valid filename is entered
            exit when is_valid_file;
            -- generate error if input file does not exist
            if fileType = input then 
                put("An input file with this name does not exist. ");
            else 
                -- generate error if output file exists, and request whether it should be overwritten. 
                put_line("An output file with this name already exists. Would you like to overwrite it? (Y/N)");
                put("> ");
                loop
                    get(response);
                    skip_line; -- skip newline that will come from the previous input 
                    if response = 'Y' then
                        is_valid_file := true;
                    elsif response = 'N' then
                        is_valid_file := false;
                    else 
                        put_line("Invalid response. Enter 'Y' or 'N'."); 
                        put("> ");
                    end if;
                    exit when response = 'Y' or response = 'N';
                end loop;
            end if;
        end loop;
        return filename;
    end getFilename; 

    -- get input image dimensions to be able to store modified image in an array of that size
    procedure getDimensions(filename: in unbounded_string; n_rows: out integer; n_cols: out integer) is
        fp: file_type; -- input file pointer
        line_read: unbounded_string; -- line in file
        first: positive;
        last: natural;
        idx: natural := 1;
        whitespace : constant Character_Set := To_Set (' ');
    begin 
        put_line("in getDimensions");

        -- read second line of input file
        open(fp, in_file, to_string(filename));
            get_line(fp, line_read); -- first line (image format, will always be P2)
            get_line(fp, line_read); -- second line (image dimensions)
        close(fp);
        put_line("line read is " & line_read);

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
    end getDimensions;

begin
    -- print instructions and main information
    welcomeUser;

    -- get name of input and output files from user
    input_fname := getFilename(input);
    output_fname := getFilename(output);
    
    -- get dimensions of PGM to declare object for modified image
    getDimensions(input_fname, num_rows, num_cols);
    
    -- test
    readPGM(input_fname);
    imageINV;
    imageLOG;
    imageSTRETCH;
    writePGM(output_fname);
end image;