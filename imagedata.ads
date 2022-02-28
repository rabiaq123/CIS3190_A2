package imagedata is
    type img_array is array (1..500, 1..500) of integer;
    type img_record is
        record
            pixel: img_array; 
            rows: integer;
            cols: integer;
        end record;
    img_read, img_modified: img_record;
end imagedata;