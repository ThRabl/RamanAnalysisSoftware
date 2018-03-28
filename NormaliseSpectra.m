function NormalisedSpectrum = NormaliseSpectra(SpectrumX, SpectrumY, NormalisationMethod)
% This function normalises the spectrum to certain features. Default is AUC
% option 1
if iscell(NormalisationMethod)
   MinAndMaxForNormalisation = NormalisationMethod{2};
   NormalisationMethod = NormalisationMethod{1}; 
end
        switch NormalisationMethod
            case 1 % AUC normalisation
                if exist('MinAndMaxForNormalisation')
                    NormalisedSpectrum = [SpectrumX,SpectrumY./trapz(SpectrumX(SpectrumX<max(MinAndMaxForNormalisation) & SpectrumX>min(MinAndMaxForNormalisation)),...
                        SpectrumY(SpectrumX<max(MinAndMaxForNormalisation) & SpectrumX>min(MinAndMaxForNormalisation)))];
                else
                    NormalisedSpectrum = [SpectrumX,SpectrumY./trapz(SpectrumX,SpectrumY)];
                end
            case 2 % Maximum Normalisation
                NormalisedSpectrum =  [SpectrumX,SpectrumY./max(SpectrumY)];
            case 3 % Normalised to Peak around 1400
                NormalisedSpectrum =  [SpectrumX,SpectrumY./max(SpectrumY(SpectrumX < 1600 & SpectrumX > 1350))];
            case 4
                NormalisedSpectrum = [SpectrumX,SpectrumY]; % No Normalisation
            otherwise                
                disp('No normalisation method supplied');
                return;
        end
    end
