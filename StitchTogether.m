function Output = StitchTogether(SignalX,SignalY)
Output = []; % Initializing Output
for i = 1:length(SignalX) % How many different spectra
    Max(i) = max(SignalX{i});
    Min(i) = min(SignalX{i});
    if ~issorted(Max) || ~issorted(Min) % Test if is sorted
        disp('Array not in right order. Wavelengths messed up. Please use ascending wavelengths for this program');
        return;
    end
end
% Test for overlap
Overlapping = Max(1:end-1)-Min(2:end); % If positive there is overlap!
if max(Overlapping > 0) % means there is overlapp between two of those
    for i = 1:length(SignalX)
        SignalY{i}(isnan(SignalY{i})) = 0;
        if i > 1 % Only from second spectrum onwards
            Overlap = min(SignalX{i})-max(SignalX{i-1});
            if Overlap < 0 % Only if negative overlap actually overlapping
                %OverlapPoints = [max(find(SignalX{i}<max(SignalX{i-1}))), min(find(SignalX{i-1}>min(SignalX{i})))]; % find overlapping points
                OverlapPoints = [max(find(SignalX{i}<=max(Output(:,1)))), min(find(Output(:,1)>=min(SignalX{i})))]; % find overlapping points
                %XCommon = [min(SignalX{i-1}(OverlapPoints(2):end)),max(SignalX{i}(1:OverlapPoints(1)))]; % Get common points
                XCommon = [min(Output(OverlapPoints(2):end,1)),max(SignalX{i}(1:OverlapPoints(1)))]; % Get common points
                XVector = linspace(XCommon(1),XCommon(2),10000); % Make vector for Spline interpolation
                Spline{1} = spline(SignalX{i},smooth(SignalY{i}),XVector); % Spline for first
                %Spline{2} = spline(SignalX{i-1},smooth(SignalY{i-1}),XVector); % Spline for second curve
                Spline{2} = spline(Output(:,1),smooth(Output(:,2)),XVector); % Spline for second curve
                
                FitCurve = median(Spline{1}-Spline{2});
                SignalY{i} = SignalY{i} - FitCurve;
                
                if Overlap < -40
                    MorePoints = 20;
                else
                    MorePoints = 0;
                end
                PointToAddNewMatrix = max(find(Output(:,1) <= SignalX{i}(round(median([1,OverlapPoints(1)])+MorePoints)))); % Find where to ascend new matrix
                MatrixToAscendPoint = min(find(SignalX{i} > SignalX{i}(round(median([1,OverlapPoints(1)])+MorePoints)))); % Find what to ascend to matrix
                Output = [Output(1:PointToAddNewMatrix,:);SignalX{i}(MatrixToAscendPoint:end),SignalY{i}(MatrixToAscendPoint:end)]; % OutputMatrix
                
            else
                if Overlapping > - 50 % Needs more maybe fit curve ?????                    
                    Shift = SignalY{i-1}(end)-SignalY{i}(1);
                    SignalY{i} = SignalY{i}+Shift;
                end
                NaNMat = []; % Initializing NaNMat between
                if i > 1 % Calculate the NaN values in between
                    Distance  = min(SignalX{i})-max(SignalX{i-1});
                    NaNMat = NaN(round(Distance/10),2);
                    Output = [Output;NaNMat];
                end
                Output = [Output;SignalX{i},SignalY{i}];
            end
        else
            Output = [Output;SignalX{i},SignalY{i}];
        end
    end
else
    if Overlapping > - 50
        Shift = SignalY{i-1}(end)-SignalY{i}(1);
        SignalY{i} = SignalY{i}+Shift;
    end
    for i = 1:length(SignalX)
        NaNMat = []; % Initializing NaNMat between
        if i > 1 % Calculate the NaN values in between
            Distance  = min(SignalX{i})-max(SignalX{i-1});
            NaNMat = NaN(round(Distance/10),2);
            Output = [Output;NaNMat];
        end
        Output = [Output;SignalX{i},SignalY{i}];
    end
end
end