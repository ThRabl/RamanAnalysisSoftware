function Corrected = CorrectFluorescentBG(RawX,RawY)
MinimumShift = 450; % Minimum Raman Shift to consider = due to filters
BorderForCSR = 1800;
BorderForProtein = 2600;
DeterminedStepsize1 = 150;
DeterminedWindowsize1 = 100;
DeterminedStepsizeCSR = 20;
DeterminedWindowsizeCSR = 20;

%% Gauss window function and Stepzisze

a = 50; % Height of peak
b = 2100; % Center of Peak
c = 600; % FWHM
aW = 30; % Height of peak
bW = 2100; % Center of Peak
cW = 600; % FWHM

a2 = 250; % Height of peak
b2 = 2930; % Center of Peak
c2 = 400; % FWHM
aW2 = 250; % Height of peak
bW2 = 2930; % Center of Peak
cW2 = 400; % FWHM 400

a3 = 250; % Height of peak
b3 = 3300; % Center of Peak
c3 = 300; % FWHM
aW3 = 250; % Height of peak
bW3 = 3300; % Center of Peak
cW3 = 300; % FWHM 300

 wf = @(mz) DeterminedStepsize1 - a*exp(-(mz-b).^2./(2*c.^2)) + a2*exp(-(mz-b2).^2./(2*c2.^2)) - a3*exp(-(mz-b3).^2./(2*c3.^2));
 WS = @(mz) DeterminedStepsize1 - aW*exp(-(mz-bW).^2./(2*cW.^2)) + aW2*exp(-(mz-bW2).^2./(2*cW2.^2)) - aW3*exp(-(mz-bW3).^2./(2*cW3.^2));
YCorrected = msbackadj(RawX(RawX > MinimumShift),RawY(RawX > MinimumShift),'STEPSIZE',wf,'WindowSize',WS); % MSbackadju with function Stepzise and WindowsSize

Corrected = [RawX(RawX > MinimumShift),YCorrected];

end