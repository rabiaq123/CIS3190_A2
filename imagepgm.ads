-- package specification

with ada.strings.unbounded; use ada.strings.unbounded;
with imagedata; use imagedata;

-- should deal with the I/O of images stored using PGM “P2” file format
-- should contain subprograms readPGM() and writePGM()

package imagepgm is
    procedure readPGM(img_rec: in out img_record; input_fname: in unbounded_string; is_valid_file: in out boolean);
    procedure writePGM(output_fname: in unbounded_string; img_modified: in img_record);
end imagepgm;
