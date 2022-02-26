-- Rabia Qureshi
-- 1046427
-- March 4, 2022

-- Ada program to perform image processing operations on a grayscale image
-- stored in an ASCII P2 PGM format

-- main wrapper program

-- allows user to interact with the imagePROCESS and imagePGM packages; reading in images,
-- manipulating them, and writing them to file

-- include subprogram getFilename() to ask user for the name of the file to be read or written. 
-- For reading, an error should be generated if the file does not exist. 
-- For writing, an error should be generated if the file does exist, and request
-- whether it should be overwritten. 
-- An example call might be: fn = getFilename(“r”) to obtain the filename of an image to read.
