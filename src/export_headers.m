function [] = export_headers(varargin)
%% EXPORT_HEADERS Export headers from TIFF images acquired with ScanImage
%
%   export_headers() will ask you to select a directory that
%   contains a number of TIFF images acquired with ScanImage, and an
%   output directory in which to save the headers as separate MAT files for
%   each TIFF image stack. Max projection files are ignored.
%
%   export_headers(directoryIN, directoryOUT) will use
%   directoryIN as the input directory and directoryOUT as the output
%   directory
%
%   Vassilis Kehayas, November 2016

%%
if isempty(varargin)
    dirIN = uigetdir('', ...
                     'SELECT INPUT DIRECTORY');
    dirOUT = uigetdir(dirIN, ...
                      'SELECT OUTPUT DIRECTORY');
else
    dirIN = varargin{1};
    dirOUT = varargin{2};
end

files = listdir(dirIN,1);

for ii = 1:length(files)

    [~, fileName, fileExt] = fileparts(files{ii});

    if ((exist(files{ii}, 'file') ~= 7) ...
        && ~isempty(strfind(fileExt,'tif')) ...
        && isempty((strfind(fileName,'max'))))
        info = imfinfo(files{ii});
        headerInfo = info(1).ImageDescription; %#ok<NASGU>
        save(fullfile(dirOUT, ['h_' fileName]), 'headerInfo')
    end

end

end
