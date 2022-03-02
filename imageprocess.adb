-- package body

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

-- image processing algorithms
-- subprogram imageINV(I) to perform image inversion
-- subprogram imageLOG(I) to perform logarithmic transformation
-- subprogram imageSTRETCH(I, imin, imax) to perform contrast-stretching

package body imageprocess is

    -- perform image inversion
    procedure imageINV(img_modified: in out img_record; img_read: in img_record) is 
    begin
        put_line("in imageINV");
        img_modified := img_read;
        for i in 1..img_modified.rows loop
            for j in 1..img_modified.cols loop
                img_modified.pixel(i,j) := abs(255 - img_read.pixel(i,j));
            end loop;
        end loop;
    end imageINV;

    -- perfrom logarithmic transformation
    procedure imageLOG(img_modified: in out img_record; img_read: in img_record) is 
    begin
        put_line("in imageLOG");
        img_modified := img_read;
        for i in 1..img_modified.rows loop
            for j in 1..img_modified.cols loop
                img_modified.pixel(i,j) := integer(log(float(img_read.pixel(i,j))) * (255.0/(log(255.0))));
            end loop;
        end loop;

    end imageLOG;

    -- perform contrast-stretching
    procedure imageSTRETCH(img_modified: in out img_record; img_read: in img_record; min: in integer; max: in integer) is 
    begin
        put_line("in imageSTRETCH");
        img_modified := img_read;
        for i in 1..img_modified.rows loop
            for j in 1..img_modified.cols loop
                img_modified.pixel(i,j) := 255 * ((img_read.pixel(i,j) - min) / (max - min));
            end loop;
        end loop;        
    end imageSTRETCH;

    function makeHIST(img_read: img_record) return integer is 
    begin
        put_line("in makeHIST()");
        return 1;
    end makeHIST;
end imageprocess;