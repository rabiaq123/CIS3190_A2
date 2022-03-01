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
        put_line("Once you enter a valid input PGM image file, you'll have a list of options to choose from."); new_line;
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

    -- print menu user and get their response
    procedure showMenu(choice: out integer) is 
    begin
        new_line;
        put_line("Please choose from one of the following options:");
        put_line("1. Apply image inversion");
        put_line("2. Apply LOG function");
        put_line("3. Apply contrast stretching");
        put_line("4. Apply histogram equalization");
        put_line("5. Write PGM image to file");
        put_line("6. Quit");
        put("> ");
        get(choice);
        skip_line;
    end showMenu;

    -- call subprogram in accordance with user input
    procedure performAction(img_read: in img_record) is 
        choice: integer; 
        img_modified: img_record;
        min, max: integer := 0;
    begin
        img_modified := img_read;
        loop
            showMenu(choice);
            case choice is
                when 1 =>
                    imageINV(img_modified, img_read);
                when 2 =>
                    imageLOG(img_modified, img_read);
                when 3 =>
                    imageSTRETCH(img_modified, img_read, min, max);
                --when 4 =>
                --    makeHIST(img_read);
                when 5 =>
                    output_fname := getFilename(output);
                    writePGM(output_fname, img_modified);
                when 6 =>
                    put_line("Exiting program...");
                    return;
                when others =>
                    put_line("Invalid input.");
            end case;
        end loop;
    end performAction;

begin
    welcomeUser;

    -- read input file and store contents in record
    input_fname := getFilename(input);
    readPGM(img_read, input_fname, is_valid_input_file);
    if is_valid_input_file = false then
        return;
    end if;
    
    --for i in 1..img_read.rows loop
    --    put("row" & integer'image(i) & ":");
    --    for j in 1..img_read.cols loop
    --        put(integer'image(img_read.pixel(i,j)) & " ");
    --    end loop;
    --    new_line;
    --end loop;

    -- give user options for what to do with input data read
    performAction(img_read);
end image;