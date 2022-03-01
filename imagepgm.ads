-- package specification

with ada.strings.unbounded; use ada.strings.unbounded;
with imagedata; use imagedata;


-- should deal with the I/O of images stored using the PGM “P2” file format
-- subprograms this package needs to contain: readPGM() and writePGM()

package imagepgm is
    procedure readPGM(img_read: in out img_record; input_fname: in unbounded_string; is_valid_file: in out boolean);
    procedure writePGM(output_fname: in unbounded_string; img_modified: in img_record);
end imagepgm;
