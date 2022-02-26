-- Rabia Qureshi
-- 1046427
-- March 4, 2022

-- Ada program to perform image processing operations on a grayscale image
-- stored in an ASCII P2 PGM format

with ada.Text_IO; use Ada.Text_IO;
with ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with ada.strings.unbounded; use ada.strings.unbounded;
with ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;
with imagepgm; use imagepgm;
with imageprocess; use imageprocess;

-- main wrapper program

-- allows user to interact with the imagePROCESS and imagePGM packages; reading in images,
-- manipulating them, and writing them to file

-- include subprogram getFilename() to ask user for the name of the file to be read or written. 
-- For reading, an error should be generated if the file does not exist. 
-- For writing, an error should be generated if the file does exist, and request
-- whether it should be overwritten. 
-- An example call might be: fn = getFilename(“r”) to obtain the filename of an image to read.


procedure image is
    fname : unbounded_string;
    type ftype is (input, output);

    -- print main program info to user
    procedure welcomeUser is 
    begin
        put_line("IMAGE PROCESSING PROGRAM"); new_line;
        put_line("Welcome! This ADA program can perform image processing operations on " &
                "any grayscale image stored in an ASCII P2 PGM format.");
        put_line("You can view your input images and the output the program creates through " &
                "https://ij.imjoy.io/"); new_line;
    end welcomeUser;

    -- get name of input file to process or output file to write to
    procedure getFilename(filename : out unbounded_string; fileType : in ftype) is 
    begin 
        if fileType = input then
            put("Enter the name of the file to be read: ");
        else 
            put("Enter the name of the file to be written: ");
        end if;
        -- get(filename);
    end getFilename; 

begin
    -- print instructions and main information
    welcomeUser;
    -- get name of input file from user
    getFilename(fname, input);
    put_line("The filename is: " & fname);
    -- test
    readPGM;
    writePGM;
    imageINV;
    imageLOG;
    imageSTRETCH;
end image;