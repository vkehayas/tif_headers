function [] = insert_headers(varargin)
%% INSERT_HEADERS Insert headers to TIFF images acquired with ScanImage
%
%   insert_headers() will ask you to select a directory that contains image
%   headers as MAT files and a directory within which to create a directory
%   called 'with_headers' to store the TIFF files with the original headers
%   inserted. Max projection files are ignored. Any existing contents in
%   the directory 'with_headers' will be deleted before storing the output.
%
%   insert_headers(headerDir, directoryOUT) will use 'headerDir' as the
%   directory containing the headers and 'directoryOUT' as the output
%   directory.
%
%   Vassilis Kehayas, November 2016

%% Choose directories
if isempty(varargin)
    headerDir = uigetdir('', ...
                         'SELECT DIRECTORY CONTAINING HEADERS');
    dirOUT = uigetdir(headerDir, ...
                      'SELECT DIRECTORY CONTAINING FILES FOR EDITING');
else
    headerDir = varargin{1};
    dirOUT = varargin{2};
end

display(['Input Directory is ' headerDir])
display(['Output Directory is ' dirOUT])

writeDirOUT = fullfile(dirOUT, 'with_headers');
if exist(writeDirOUT,'dir') ~= 7
    mkdir(writeDirOUT);
else
    delete([writeDirOUT filesep '*'])
end

%% Get headers
filesIN = listdir(headerDir, 1);
headerFiles = filesIN(~cellfun(@isempty, ...
                               strfind(filesIN, ...
                               '.mat')));

headers = cell(length(headerFiles), 1);
headerFileName = cell(length(headerFiles), 1);
for ii = 1:length(headerFiles)

    [~, headerFileName{ii}] = fileparts(headerFiles{ii});

    if ((exist(headerFiles{ii}, 'file') ~= 7) ...
        && isempty((strfind(headerFileName{ii}, 'max'))))
        load(headerFiles{ii})
        headers{ii} = headerInfo;
    end

end

%% Get TIFF files and match them to headers
tif2edit = listdir(dirOUT, 1);
counter = 0;
for jj = 1:length(tif2edit)

    [~, tifFileName, tifFileExt] = fileparts(tif2edit{jj});

    if ((exist(tif2edit{jj}, 'file') ~= 7) ...
        && ~isempty(strfind(tifFileExt,'.tif')) ...
        && isempty((strfind(tifFileName,'max'))))
        counter = counter + 1;

        if ~isempty(strfind(headerFileName{counter}, ...
                            tifFileName))
            info = imfinfo(tif2edit{jj});

            % Loop through slices
            for kk = 1 :length(info)

                temp_image = imread(tif2edit{jj}, kk, 'Info', info);
                IMAGE = uint16(temp_image);

                imwrite(IMAGE, ...
                        [writeDirOUT filesep tifFileName '.tif'], ...
                        'Description', headers{counter}, ...
                        'WriteMode', 'append', ...
                        'Compression', 'none');
            end

        else
            error('Name mismatch between header files and images')
        end

    end

end
