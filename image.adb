-- Rabia Qureshi
-- 1046427
-- March 4, 2022

with ada.Text_IO; use Ada.Text_IO;
with ada.strings.unbounded; use ada.strings.unbounded;
with ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;
with ada.directories; use ada.directories;
with Ada.Strings; use Ada.Strings; 
with ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with imagedata; use imagedata;
with imagepgm; use imagepgm;
with imageprocess; use imageprocess;

-- main wrapper program to read in images, manipulate them, and write them to file
-- allow user interaction with the imagePROCESS and imagePGM packages

procedure image is
    type ftype is (input, output);
    input_fname, output_fname: unbounded_string;
    is_valid_input_file, quit: boolean;

    -- print program info to user
    procedure welcomeUser is 
    begin
        put_line("IMAGE PROCESSING PROGRAM"); new_line;
        put_line("Welcome! This ADA program can perform image processing operations on " &
                "any grayscale image stored in an ASCII P2 PGM format.");
        put_line("Once you enter a valid input PGM image file, you'll have a list of options to choose from.");
    end welcomeUser;

    -- get input file name and perform error handling
    procedure handleInputFile(fname: in out unbounded_string; is_valid_file: in out boolean) is
    begin 
        -- loop until valid filename is entered
        while is_valid_file = false loop
            put("Enter the name of the file to be read: ");
            get_line(fname);
            if (fname /= "") then
                if exists(to_string(fname)) = true then
                    is_valid_file := true;
                end if;
            end if;
            -- generate error if input file does not exist
            if is_valid_file = false then
                put("An input file with this name does not exist. ");
            end if;
        end loop;
    end handleInputFile;

    -- get output file name and perform error handling
    procedure handleOutputFile(fname: in out unbounded_string; is_valid_file: in out boolean) is
        response: character;
    begin
        -- loop until valid filename is entered
        while is_valid_file = false loop
            put("Enter the name of the file to be written to: ");
            get_line(fname);
            if (fname /= "") then -- filename was entered
                if exists(to_string(fname)) = true then -- file with desired filename already exists
                    put_line("An output file with this name already exists. Would you like to overwrite it? (Y/N)");
                    put("> ");
                    loop -- loop until Y or N is entered
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
                else -- no file with desired name exists yet
                    is_valid_file := true;
                end if;
            else -- no filename was entered (pressed ENTER)
                put("Invalid output filename. ");
            end if;
        end loop;
    end handleOutputFile;

    -- ask user for the name of the file to be read or written, and handle exceptions
    function getFilename(fileType: ftype) return unbounded_string is 
        filename: unbounded_string;
        is_valid_file: boolean := false;
    begin 
        new_line; -- enter newline before any prompts for input/output filename are displayed
        if fileType = input then 
            handleInputFile(filename, is_valid_file);
        else
            handleOutputFile(filename, is_valid_file);
        end if;
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

    -- call subprogram in accordance with user input
    procedure performAction(img_read: in img_record; img_modified: in out img_record; quit: out boolean) is 
        choice: integer; 
        min, max: integer;
        is_valid_input: boolean := false;
    begin
        img_modified := img_read;
        quit := false;
        loop
            exit when is_valid_input;
            is_valid_input := true; -- reset to true so flag is only set to false when latest user input is invalid
            showMenu(choice);
            case choice is
                when 1 =>
                    imageINV(img_modified);
                when 2 =>
                    imageLOG(img_modified);
                when 3 =>
                    getIntensityValues(min, max);
                    imageSTRETCH(img_modified, min, max);
                when 4 =>
                    imageEqualization(img_modified, img_read);
                when 5 =>
                    quit := true;
                when others =>
                    is_valid_input := false;
                    put_line("Invalid input.");
            end case;
        end loop;
    end performAction;

begin
    welcomeUser;
    -- read input file and store contents in record
    is_valid_input_file := true;
    input_fname := getFilename(input);
    readPGM(img_read, input_fname, is_valid_input_file);
    -- return if input file is invalid
    if is_valid_input_file = false then
        put_line("Exiting program...");
        return;
    end if;
    -- perform user's chosen image transformation and quit if user desires 
    performAction(img_read, img_modified, quit);
    if quit then
        put_line("Exiting program...");
        return;
    end if;
    -- write to output file
    output_fname := getFilename (output);
    writePGM (output_fname, img_modified);
end image;