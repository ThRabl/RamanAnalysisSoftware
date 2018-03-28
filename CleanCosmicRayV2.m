function [MatrixSignalCleaned,MatrixBGCleaned] = CleanCosmicRayV2(varargin)
%% This programm removes cosmic rays from multiple acquisitions
%
DeleteDistance = 5;% What distance around cosmic ray is removed (pixels)
TimesMedian = 20; % How far away can the detection be from the median.
if isempty(varargin{1}) % If corrupted file show
    disp('Corrupted file: No signal in matrix, please delete this measurement');
    MatrixSignalCleaned = NaN;
    MatrixBGCleaned = NaN;
    return;
end
if length(varargin{1}(1,:)) > 2
    MatrixSignalCleaned = ReturnCleaned(varargin{1});
else
    MatrixSignalCleaned = varargin{1}; % Maybe should look for different way of handling siongle shot measurements
end

if length(varargin) == 2 
    if length(varargin{2}(1,:)) > 2
        MatrixBGCleaned = ReturnCleaned(varargin{2});
    else
        MatrixBGCleaned = varargin{2}; % Again might want to change
    end
else
    MatrixBGCleaned = [];
end
function CleanedMatrix = ReturnCleaned(MatrixY)

    AcceptableDifference = TimesMedian*nanmedian(mad(MatrixY(:,2:end)')'); % Absolute Allowed Difference to median times 5
    for i = 1:length(MatrixY(1,:)) % Scan through all measurements
        DifferenceToOthers = MatrixY(:,i) - nanmedian(MatrixY(:,[1:i-1 i+1:end]),2); % Calculate the actual difference to all other measurements median of current acquisition
        [pos,val] = find(DifferenceToOthers >= AcceptableDifference); % Find all differences that are out of the ordinary
        posRay = [];
        for g = 1:length(pos) % scan through all found positions to get a matrix for deletion setup
            posRay = [posRay;[pos(g)-DeleteDistance:pos(g)]';[pos(g):pos(g)+DeleteDistance]'];
        end
        posRay(posRay < 1) = 1; % Nothing smaller than 1
        posRay(posRay > 1024) = 1024; % nothing bigger than the Matrixsize 1024
        MatrixY(posRay,i) = NaN; % Delete around cosmic ray.
    end
    CleanedMatrix = MatrixY;
end
end
