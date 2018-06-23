function [list, varargout] = listdir(varargin)
%% LISTDIR List directory contents
%   
%   list = listdir(Path) returns all contents of directory Path
%   fullPaths = listdir(Path, 1) returns directory contents in absolute path
%   format (Default = 0 = relative path)
%   [fullPaths, list] = listdir(Path, 2) returns both absolute paths and filenames
%   fileNames = listdir(Path, [], 1) returns only file contents of directory
%   (i.e. excludes folders). Default is 0 (i.e. return everything).
%
%   Vassilis Kehayas, January 2015


%% Parse input arguments

% Set input directory variable
Path = varargin{1};
dl = dir(Path);

% Set whether to return fullpath format or not
if nargin >= 2
    fullPath = varargin{2};
else
    fullPath = 0;
end

% Set whether to return file contents only
if nargin >= 3
    filesOnly = varargin{3};
    list = cell(1,1);
else filesOnly = 0;
    list = cell(length(dl)-2,1);
end

%% Loop through directory contents
fileCounter = 0;
temp = cell(length(dl)-2,1);
for ii = 1:length(dl)-2
    currentFullFile = fullfile(Path,dl(ii+2).name);     % Absolute file path
    
    switch filesOnly
        case 0
            if fullPath == 1
                list{ii} = currentFullFile;
            elseif fullPath == 2 && nargout >= 2
                list{ii} = currentFullFile;
                temp{ii} =  dl(ii+2).name;
            elseif fullPath == 0
                list{ii} = dl(ii+2).name;
            end
        case 1
            if exist(currentFullFile, 'file') == 2
                fileCounter = fileCounter + 1;
                if fullPath == 1
                    list{fileCounter,1} = currentFullFile;
                elseif fullPath == 2 && nargout >= 2
                    list{fileCounter,1} = currentFullFile;
                    temp{fileCounter,1} =  dl(ii+2).name;
                elseif fullPath == 0
                    list{fileCounter,1} = dl(ii+2).name;
                end
            end
    end
end

if exist('temp', 'var')
    varargout{1} = temp;
end

end
