package imagedata is
    -- image storing
    type img_array is array (1..500, 1..500) of integer;
    type img_record is
        record
            pixel: img_array; 
            rows: integer;
            cols: integer;
            max_gs: integer;
        end record;
    img_read, img_modified: img_record;
    -- histogram
    type hist_arr is array (integer range <>) of integer;
end imagedata;