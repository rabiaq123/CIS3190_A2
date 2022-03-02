-- Rabia Qureshi
-- 1046427
-- March 4, 2022

with ada.Text_IO; use Ada.Text_IO;
with Ada.IO_Exceptions; use Ada.IO_Exceptions;
with ada.strings.unbounded; use ada.strings.unbounded;
with ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;
with ada.directories; use ada.directories;
with Ada.Strings; use Ada.Strings; 
with ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with imagepgm; use imagepgm;
with imageprocess; use imageprocess;
with imagedata; use imagedata;


-- main wrapper program
-- allow user to interact with the imagePROCESS and imagePGM packages; reading in images,
-- manipulating them, and writing them to file

procedure image is
    type ftype is (input, output);
    input_fname, output_fname: unbounded_string;
    is_valid_input_file: boolean := true;

    -- print program info to user
    procedure welcomeUser is 
    begin
        put_line("IMAGE PROCESSING PROGRAM"); new_line;
        put_line("Welcome! This ADA program can perform image processing operations on " &
                "any grayscale image stored in an ASCII P2 PGM format.");
        put_line("Once you enter a valid input PGM image file, you'll have a list of options to choose from.");
    end welcomeUser;

    -- ask user for the name of the file to be read or written, and handle exceptions
    function getFilename(fileType: ftype) return unbounded_string is 
        filename: unbounded_string;
        is_valid_file: boolean := false;
        response: character;
    begin 
        new_line;
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

    -- print menu user and get their response
    procedure showMenu(choice: out integer) is 
    begin
        new_line;
        put_line("Please choose from one of the following options:");
        put_line("1. Apply image inversion");
        put_line("2. Apply LOG function");
        put_line("3. Apply contrast stretching");
        put_line("4. Apply histogram equalization");
        put_line("5. Quit");
        put("> ");
        get(choice);
        skip_line;
    end showMenu;

    -- get min and max intensity values if user chooses to perform image stretching function
    procedure getIntensityValues(min: out integer; max: out integer) is 
        min_str, max_str: unbounded_string;
    begin
        put("Minimum intensity value: ");
        get_line(min_str);
        put("Maximum intensity value: ");
        get_line(max_str);
        -- convert to integer
        min := integer'value(to_string(min_str));
        max := integer'value(to_string(max_str));
    end getIntensityValues;

    -- perform histogram equalization
    procedure imageEqualization(img_modified: in out img_record; img_read: in img_record) is 
        hist: hist_arr (1..img_read.max_gs+1);
    begin
        hist := makeHIST(img_read);
        Put_Line ("the histogram array is: ");
        -- max_gs+1 because array start index is 1 (not 0)
        -- for i in 1..img_modified.max_gs+1 loop
        --     put_line(integer'image(i-1) & ":" & integer'image(hist(i)));
        -- end loop;
        -- perform histogram equalization

    end imageEqualization;

    -- call subprogram in accordance with user input
    procedure performAction(img_read: in img_record; img_modified: in out img_record) is 
        choice: integer; 
        min, max: integer;
        is_valid_input: boolean := false;
    begin
        img_modified := img_read;
        loop
            exit when is_valid_input;
            is_valid_input := true; -- reset to true so flag is only set to false when latest user input is invalid
            showMenu(choice);
            case choice is
                when 1 =>
                    imageINV(img_modified);
                when 2 =>
                    imageLOG (img_modified);
                when 3 =>
                    getIntensityValues(min, max);
                    imageSTRETCH(img_modified, min, max);
                when 4 =>
                    imageEqualization(img_modified, img_read);
                when 5 =>
                    put_line("Exiting program...");
                    return;
                when others =>
                    put_line("Invalid input.");
                    is_valid_input := false;
            end case;
        end loop;
    end performAction;

begin
    welcomeUser;
    -- read input file and store contents in record
    input_fname := getFilename(input);
    readPGM(img_read, input_fname, is_valid_input_file);
    -- return if input file is invalid
    if is_valid_input_file = false then
        return;
    end if;
    -- give user options for what to do with input data read
    performAction(img_read, img_modified);
    -- write to output file
    output_fname := getFilename (output);
    writePGM (output_fname, img_modified);

    --for i in 1..img_read.rows loop
    --    put("row" & integer'image(i) & ":");
    --    for j in 1..img_read.cols loop
    --        put(integer'image(img_read.pixel(i,j)) & " ");
    --    end loop;
    --    new_line;
    --end loop;
end image;