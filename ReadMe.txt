The files provided here are for a specific Raman spectroscopic system described in the PhD. thesis of T. Rabl: "Spontaneous raman spectroscopy: Exploring applicability in drug discovery and the medical sciences". 

The programs are as follows: 

-CleanCosmicRayV2: 
is a recursive algorithm that scans through the spectra to see extraordinary spikes and removes those. It takes up to two input matrices where 
    Input1 = Signal to clean, where columns are measurements, and rows are Raman shifts/wavelengths. 
    Input2 = Background to clean, where columns are measurements, and rows are Raman shifts/wavelengths. 
The program returns both matrices in cleaned form. The spikes are replaced by NaN values
----------------------------------------------------------------------------------

-ScanFolderAndMerge:
   Is a algorithm that scans through given folders and merges the signals contained in those folders to one overall spectrum. It takes up to 3 inputs:
    Input1 = The overall folder name
    Input2 = how many wavelengths are to merge (in case different acquisitons are made)
    Input3 = Exact wavelengths that should be considered
It returns the merged spectrum from within the folder. In case backgroiund acquisitions are within the same folder also a background subtraction is done. Otherwise only a polynomial fluorescence correction is performed via "CorrectFluorescentBG" (described below). Note: Only really usefull with the exact same folder structure
----------------------------------------------------------------------------------

-CorrectFluorescentBG:
    Is a program that deducts the fluorescence background from the Raman signal. It uses the msbackadj funktion from Matlab with various input parameters for the window function and stepfunction to optimise usability. It takes 2 Inputs:
    Input1 = The X matrix as 1 column matrix (must be already Raman shift!)
    Input2 = The Y matrix as 1 coplumn with Raman intensities (Should be merged before using the algorithm, not the other way around.)
It returns a corrected Y matrix. X is not returned.
---------------------------------------------------------------------------------

-OrderSpectra:
    Is a program that orders spectra according to their Raman shift, necessary imultiple acquisitions are taken for one full Raman spectrum (e.g. 1200lines/mm grating needs 5 spectra to acquire full Raman shift from 500-3000 [1/cm]). This is to assure proper sorting before stitching together. It takes two inputs:
    Input1 = Cell matrix containing all the X Shifts for each individually acquired position of the diffraction grating as column rows.
    IUnput2 = corresponding Cell matrix with the Y values for the individuall positions of the diffraction grating
It returns the sorted form of the cell matrix
---------------------------------------------------------------------------------

-StitchTogether:
Stitches together the sorted spectra. This requires the spectra to be ascending (e.g. 840nm; 860nm; 900nm)
It takes two inputs:
    Input1 = Sorted cell matrix containing the X Raman shifts
    Input2 = Sorted cell matrix containing the Y intensities
It outputs a data Matrix where column1 = Raman shifts and Column2 = Intensities. Stitched together from the multiple other acquisitions
--------------------------------------------------------------------------------

-CorrectToSameXAxis: 
Corrects the merged spectra to a common X-Axis. Usefull for plotting and comparing of spectra. It takes two inputs:
    Input1 = Xaxis to correct to as a 1 column matrix
    Input2 = XY matrix of the measurement that should be corrected to the same axis (Column1 = X-Raman Shift, COlumn2 = Y-Raman Amplitude)
It outputs The X corrected XY matrix. 
--------------------------------------------------------------------------------

-NormaliseSpectra:
    Normalises the spectra according to the input. It takes three inputs:
    Input1 = SpectrumX Axis (Raman Shift)
    Input2 = SpectrumY Axis (Raman Amplidute)
    Input3 = NormalisationMethod with the following values:
         1-Normalisation to toal AUC of the Spectrum
         2-Normalisation to the maxmimum peak of the spectrum
         3-Normalisation to the maximum of the peak between 1350 and 1600 1/cm

It returns the Normalised Raman amplitude
-------------------------------------------------------------------------------

-CalculateAUCPeak:
   Calculkates the AUC of a specific range.
    Takes as input the XY matrix (RamanShift/RamanAmplitude) and the peak range and outputs the AUC of this peak







 


