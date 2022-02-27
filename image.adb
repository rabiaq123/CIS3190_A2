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
    type ftype is (input, output);
    inputFile, outputFile : unbounded_string;

    -- print main program info to user
    procedure welcomeUser is 
    begin
        put_line("IMAGE PROCESSING PROGRAM"); new_line;
        put_line("Welcome! This ADA program can perform image processing operations on " &
                "any grayscale image stored in an ASCII P2 PGM format.");
        put_line("You can view your input images and the output the program creates through " &
                "https://ij.imjoy.io/"); new_line;
    end welcomeUser;

    -- get name of input file to process or output file to write to and handle exceptions
    function getFilename(fileType: ftype) return unbounded_string is 
        filename: unbounded_string;
    begin 
        if fileType = input then
            put("Enter the name of the file to be read: ");
        else 
            put("Enter the name of the file to be written to: ");
        end if;
        get_line(filename);
        return filename;
    end getFilename; 

begin
    -- print instructions and main information
    welcomeUser;
    -- get name of input and output files from user
    inputFile := getFilename(input);
    put_line("The input filename is: " & inputFile);
    outputFile := getFilename(output);
    put_line("The output filename is: " & outputFile);
    -- test
    readPGM(inputFile);
    writePGM(outputFile);
    imageINV;
    imageLOG;
    imageSTRETCH;
end image;