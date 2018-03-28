function BGCorrectedSpectrum = ScanFolderAndMerge(varargin)% (FolderName,SubfolderName,Wavelength,OverallBGFolder)
CurrentDir = pwd; % Remeber current directory
FolderName = varargin{1};
SubfolderName = varargin{2};
Wavelength = varargin{3};

if iscell(Wavelength) % Check if only wavelengtsh to consider
    if length(Wavelength) == 2
        WavelengthsToConsider = Wavelength{2};
        Wavelength = Wavelength{1};
    else
        Acc = Wavelength{3};
        WavelengthsToConsider = Wavelength{2};
        Wavelength = Wavelength{1};
        
    end
else
    WavelengthsToConsider = [];
end


%% Move files if wrong
cd([FolderName,filesep,SubfolderName]);
Image1 = dir('*BackGroundWithLaser.mat');
Image2 = dir('*_Cell.mat');
if ~isempty(Image1)
    if exist('PhaseImage') == 7 % if it is a folder
        disp(['Error Phase Image does not exis in: ',FolderName,filesep,SubfolderName]);
    else
        movefile(Image1.name,'PhaseImages')
    end
end

if ~isempty(Image2)
    if exist('PhaseImage') == 7 % if it is a folder
        disp(['Error Phase Image does not exis in: ',FolderName,filesep,SubfolderName]);
    else
        movefile(Image2.name,'PhaseImages')
    end
end
cd([CurrentDir]);

%%

if length(varargin)  == 4
    OverallBGFolder = varargin{4}; % Get overall BG folder
    cd([OverallBGFolder]);
    if ~isempty(WavelengthsToConsider) % Consider only given Wavelengths
        for q = 1:length(WavelengthsToConsider)
            Backgrounds(q) = dir(['*Background',num2str(WavelengthsToConsider(q)),'*']);
        end
    else
        Backgrounds = dir('*Background*'); % Get all BG names
    end
    cd([CurrentDir]);
else
    cd([FolderName,filesep,SubfolderName]); %Jump into folder with measurements
    BackgroundsApparent = dir('*Background*');
    if ~isempty(WavelengthsToConsider) && ~isempty(BackgroundsApparent)
        for q = 1:length(WavelengthsToConsider)
            Backgrounds(q) = dir(['*Background',num2str(WavelengthsToConsider(q)),'*']);
        end
    else
        Backgrounds = dir('*Background*'); % Get all BG names
    end
    OverallBGFolder = ([FolderName,filesep,SubfolderName]);
    cd([CurrentDir]);
end
cd([FolderName,filesep,SubfolderName]);
if ~isempty(WavelengthsToConsider)
    for q = 1:length(WavelengthsToConsider)
        Signals(q) = dir(['*Signal',num2str(WavelengthsToConsider(q)),'*']);
    end
else
    Signals = dir('*Signal*'); % Get all Signal names
end

cd([CurrentDir]);

if ~(length(Signals) == length(Backgrounds)) && ~isempty(Backgrounds) % If not same length of BG and Signal there and BG acquired at all.
    disp(['Not all Signals apparent check folder: ',FolderName,filesep,SubfolderName])
    BGCorrectedSpectrum = [];
    return;
end

for i = 1:length(Signals)
    cd([FolderName,filesep,SubfolderName]);
    SignalTemp = load(Signals(i).name); % Load signals ionto variable
    cd([CurrentDir]);
    SignalX{i} = (1./Wavelength - 1./SignalTemp.MatrixSignal(:,1))*10^7;
    if ~isempty(Backgrounds)
        cd([OverallBGFolder]);
        if mod(i,length(Backgrounds)) == 0
            CounterBG = length(Backgrounds);
        else
            CounterBG = mod(i,length(Backgrounds));
        end
        Background = load(Backgrounds(CounterBG).name); % load BG into variable(if existent) and repeat if more signals acquired (might be wrong)
        cd([CurrentDir]);
        [MatrixSignalCleaned,MatrixBGCleaned] = CleanCosmicRayV2(SignalTemp.MatrixSignal(:,2:end),Background.MatrixBG(:,2:end)); % Clean CosmicRay
        if isnan(MatrixSignalCleaned)
            waitfor(msgbox(['Please check the measurement in: ',10,[FolderName,filesep,SubfolderName],10, 'delete if corrupted']))
        end
        SignalY{i} = nanmedian(MatrixSignalCleaned,2)-nanmedian(MatrixBGCleaned,2); % Get Median of cleaned signal minus BG
    else
        [MatrixSignalCleaned] = CleanCosmicRayV2(SignalTemp.MatrixSignal(:,2:end)); % Clean Cosmic Rays.
        %% Test for 1 measurement
        if exist('Acc')
            SignalY1 = nanmedian(MatrixSignalCleaned(SignalX{i}<2050,:),2); % Get median of cleaned signal
            SignalY3 = nanmedian(MatrixSignalCleaned(SignalX{i}>2150,:),2); % Get median of cleaned signal
            SignalY2 = nansum(MatrixSignalCleaned(SignalX{i}>=2050 & SignalX{i} <=2150,:),2)/Acc; % Get median of cleaned signal
            SignalY{i} = [SignalY1;SignalY2;SignalY3];
        else
            %%
            SignalY{i} = nanmedian(MatrixSignalCleaned,2); % Get median of cleaned signal
        end
    end
end

[SignalX,SignalY] = OrderSpectra(SignalX,SignalY); % Order if for any reason not in order
Spectrum = StitchTogether(SignalX,SignalY); % STitch spectra together to make one large spectrum out of it for BG correction

%% Just a trY !!!!!!
Spectrum(:,2) = smooth(Spectrum(:,2)); % Test if smoothing is good.
if max(Spectrum(Spectrum(:,1)>1061 & Spectrum(:,1)<1065,2)) < 0
    %BGCorrectedSpectrum = [];
    BGCorrectedSpectrum = CorrectFluorescentBG(Spectrum(:,1),Spectrum(:,2));
else
    BGCorrectedSpectrum = CorrectFluorescentBG(Spectrum(:,1),Spectrum(:,2));
end


cd(CurrentDir); % Jump back to directory at start
end