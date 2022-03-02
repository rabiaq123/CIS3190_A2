-- package body

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

-- image processing algorithms
-- subprogram imageINV(I) to perform image inversion
-- subprogram imageLOG(I) to perform logarithmic transformation
-- subprogram imageSTRETCH(I, imin, imax) to perform contrast-stretching

package body imageprocess is

    -- perform image inversion
    procedure imageINV(img_modified: in out img_record) is 
    begin
        put_line("in imageINV");
        for i in 1..img_modified.rows loop
            for j in 1..img_modified.cols loop
                img_modified.pixel(i,j) := abs(255 - img_modified.pixel(i,j));
            end loop;
        end loop;
    end imageINV;

    -- perform logarithmic transformation
    procedure imageLOG(img_modified: in out img_record) is 
    begin
        put_line("in imageLOG");
        img_modified := img_read;
        for i in 1..img_modified.rows loop
            for j in 1..img_modified.cols loop
                img_modified.pixel(i,j) := integer(log(float(img_modified.pixel(i,j))) * (255.0/(log(255.0))));
            end loop;
        end loop;

    end imageLOG;

    -- perform contrast-stretching
    procedure imageSTRETCH(img_modified: in out img_record; min: in integer; max: in integer) is 
    begin
        put_line("in imageSTRETCH");
        for i in 1..img_modified.rows loop
            for j in 1..img_modified.cols loop
                img_modified.pixel(i,j) := 255 * (img_modified.pixel(i,j) - min) / (max - min);
            end loop;
        end loop;        
    end imageSTRETCH;

    -- make histogram of image
    function makeHIST(img_read: img_record) return hist_arr is 
        hist: hist_arr(1..img_read.max_gs+1);
        num_occurrences: integer;
    begin
        put_line("in makeHIST()");
        -- count number of times (index-1) occurs in image array, and store value in hist(index)
        for hist_idx in 1..img_read.max_gs+1 loop
            num_occurrences := 0;
            -- loop through image array and increment num occurences when applicable
            for i in 1..img_read.rows loop
                for j in 1..img_read.cols loop
                    if img_read.pixel(i,j) = (hist_idx - 1) then
                        num_occurrences := num_occurrences + 1;
                    end if;
                end loop;
            end loop;
            hist(hist_idx) := num_occurrences;
        end loop;
        return hist;
    end makeHIST;
end imageprocess;