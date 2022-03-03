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
                -- keep pixel value within bounds
                if (img_modified.pixel(i,j) > 255) then
                    img_modified.pixel(i,j) := max;
                elsif (img_modified.pixel(i,j) < 0) then
                    img_modified.pixel(i,j) := 0;
                end if;
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

    -- perform histogram equalization of image
    function histEQUAL(img_read: img_record; hist: hist_arr) return img_record is
        img: img_record := img_read;
        num_pixels: constant integer := img_read.cols * img_read.rows;
        pdf: array(1..hist'length) of float; -- probability density function
        cumulative_hist: array(1..256) of float; -- cumulative histogram; 256-element array
    begin
        -- calculate PDF of histogram by dividing each bin in the histogram by the total number of pixels in the image
        for i in 1..hist'length loop
            pdf(i) :=  float(hist(i) / num_pixels);
            --Put_Line (integer'image(i) & ":" & float'image(pdf(i)));
            --Put_Line (integer'image(i) & ":" & integer'image(hist(i)));
        end loop;
        --Put_Line ("this was fine");
        -- each value is the cumulative value from the PDF
        for i in 1..256 loop
            if i = 1 then
                cumulative_hist(i) := pdf(i);
                --Put_Line ("here");
            else 
                cumulative_hist(i) := cumulative_hist(i-1) + pdf(i);
                --Put_Line (integer'image(i) & ":" & float'image(cumulative_hist(i)));
            end if;
        end loop;
        -- map new grayscale values using a 1:1 correspondence
        for i in 1..256 loop
            for j in 1..img_read.rows loop
                for k in 1..img_read.cols loop
                    if img_read.pixel(j,k) = i-1 then
                        img.pixel(j,k) := integer(cumulative_hist(i) * 255.0);
                    end if;
                end loop;
            end loop;
        end loop;
        return img;
    end histEQUAL;
end imageprocess;