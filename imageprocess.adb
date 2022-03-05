-- package body

with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Ada.Text_IO; use Ada.Text_IO;
with ada.strings.unbounded; use ada.strings.unbounded;
with ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;

-- image processing algorithms

package body imageprocess is

    -- perform image inversion
    procedure imageINV(img_modified: in out img_record) is 
    begin
        for i in 1..img_modified.rows loop
            for j in 1..img_modified.cols loop
                img_modified.pixel(i,j) := abs(255 - img_modified.pixel(i,j));
            end loop;
        end loop;
    end imageINV;

    -- perform logarithmic transformation
    procedure imageLOG(img_modified: in out img_record) is 
    begin
        img_modified := img_read;
        for i in 1..img_modified.rows loop
            for j in 1..img_modified.cols loop
                img_modified.pixel(i,j) := integer(log(float(img_modified.pixel(i,j))) * (255.0/(log(255.0))));
            end loop;
        end loop;
    end imageLOG;

    -- get min and max intensity values if user chooses to perform image stretching function
    procedure getIntensityValues(min: out integer; max: out integer) is 
        min_str, max_str: unbounded_string;
    begin
        put("Minimum intensity value: ");
        get_line(min_str);
        put("Maximum intensity value: ");
        get_line(max_str);
        -- convert to integer
        min := integer'value(to_string(min_str));
        max := integer'value(to_string(max_str));
    end getIntensityValues;

    -- perform contrast-stretching
    procedure imageSTRETCH(img_modified: in out img_record; min: in integer; max: in integer) is 
    begin
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

    -- call subprograms required to perform histogram equalization
    procedure imageEqualization(img_modified: in out img_record; img_read: in img_record) is 
        hist: hist_arr (1..img_read.max_gs+2);
    begin
        hist := makeHIST(img_read);
        img_modified := histEQUAL(img_read, hist);
    end imageEqualization;

    -- make histogram of image
    function makeHIST(img_read: img_record) return hist_arr is 
        hist: hist_arr(1..257);
        num_occurrences: integer;
    begin
        -- count number of times (index-1) occurs in image array, and store value in hist(index)
        for idx in 1..257 loop
            num_occurrences := 0;
            -- loop through image array and increment num occurences when applicable
            for i in 1..img_read.rows loop
                for j in 1..img_read.cols loop
                    if img_read.pixel(i,j) = (idx - 1) then
                        num_occurrences := num_occurrences + 1;
                    end if;
                end loop;
            end loop;
            hist(idx) := num_occurrences;
        end loop;
        return hist;
    end makeHIST;

    -- perform histogram equalization of image
    function histEQUAL(img_read: img_record; hist: hist_arr) return img_record is
        img: img_record := img_read;
        num_pixels: constant integer := img_read.cols * img_read.rows;
        pdf: array(1..257) of float; -- probability density function
        cumulative_hist: array(1..257) of float; -- cumulative histogram; 256-element array
    begin
        -- calculate PDF of histogram by dividing each bin in the histogram by the total number of pixels in the image
        for i in 1..257 loop
            pdf (i) := float(hist(i)) / float(num_pixels);
        end loop;
        -- each value is the cumulative value from the PDF
        for i in 1..257 loop
            if i = 1 then
                cumulative_hist(i) := pdf(i);
            else 
                cumulative_hist(i) := cumulative_hist(i-1) + pdf(i);
            end if;
        end loop;
        -- map new grayscale values using a 1:1 correspondence
        for i in 1..257 loop
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