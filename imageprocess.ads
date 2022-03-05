-- package specification

with imagedata; use imagedata;

-- should include a record structure to hold the image (array and dimensions).
-- includes a series of image processing algorithms, implemented as subprograms

package imageprocess is
    procedure imageINV(img_modified: in out img_record);
    procedure imageLOG(img_modified: in out img_record);
    -- image stretch-related subprograms
    procedure getIntensityValues(min: out integer; max: out integer);
    procedure imageSTRETCH(img_modified: in out img_record; min: in integer; max: in integer);
    -- histogram-related subprograms
    procedure imageEqualization(img_modified: in out img_record; img_read: in img_record);
    function makeHIST(img_read: in img_record) return hist_arr; 
    function histEQUAL(img_read: in img_record; hist: in hist_arr) return img_record; 
end imageprocess;
