-- package specification

with ada.strings.unbounded; use ada.strings.unbounded;
with ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;

-- should deal with the I/O of images stored using the PGM “P2” file format
-- subprograms this package needs to contain: readPGM() and writePGM()

package imagepgm is
    procedure readPGM(input_fname: in unbounded_string);
    procedure writePGM(output_fname: in unbounded_string);
end imagepgm;
