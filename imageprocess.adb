-- package body

with Ada.Text_IO; use Ada.Text_IO;


-- image processing algorithms
-- subprogram imageINV(I) to perform image inversion
-- subprogram imageLOG(I) to perform logarithmic transformation
-- subprogram imageSTRETCH(I, imin, imax) to pterform contrast-stretching

package body imageprocess is
    procedure imageINV is 
    begin
        put_line("in imageINV");
    end imageINV;

    procedure imageLOG is 
    begin
        put_line("in imageLOG");
    end imageLOG;

    procedure imageSTRETCH is 
    begin
        put_line("in imageSTRETCH");
    end imageSTRETCH;

    function makeHIST(img_modified: img_record) return integer is 
    begin
        put_line("in makeHIST()");
        return 1;
    end makeHIST;
end imageprocess;