-- package specification

with imagedata; use imagedata;


-- should include a record structure to hold the image (array and dimensions).
-- includes a series of image processing algorithms, implemented as subprograms

package imageprocess is
    procedure imageINV;
    procedure imageLOG;
    procedure imageSTRETCH;
    function makeHIST(img_modified: img_record) return integer; 
end imageprocess;