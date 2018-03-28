function Data = CorrectToSameXAxis(XCorrected,XYData)
 MaximumDistance = 8.5; %(cm^-1) 8 is maximum with 532 at lower end with grating 1
    XYData(isnan(XYData)) = 0; % Get rid of NaNs 
    %% Check for Empty Regions
    X = XYData(:,1);
    Y = XYData(:,2);
    XLim = [min(X),max(X)]; % Find min and max of current graph    
    XDiff = X(1:end-1) - X(2:end); % Get X values to see where jumps are
    JumpPosition = find(abs(XDiff) > MaximumDistance);
    JumpPosition = JumpPosition(JumpPosition > 5 & JumpPosition < length(X) - 5); % Get rid of borders if needed
    for i = 1:length(JumpPosition)
       FittingCurve = fit([X(JumpPosition(i));X(JumpPosition(i)+1)], [Y(JumpPosition(i));Y(JumpPosition(i)+1)],'poly1'); % Simple Fit between two points (Linear)
       XToAdd = [X(JumpPosition(i))+1:1:X(JumpPosition(i)+1)-1]';
       X = [X(1:JumpPosition(i));XToAdd;X(JumpPosition(i)+1:end)];
       Y = [Y(1:JumpPosition(i));FittingCurve(XToAdd);Y(JumpPosition(i)+1:end)];
       JumpPosition = JumpPosition + length(XToAdd);
    end
    XCorrectedTemp = XCorrected(XCorrected <= XLim(2) & XCorrected >= XLim(1)); % Only use min and max for spline interpolation
    SplineTemp = spline(X,Y,XCorrectedTemp');
    StartingVector = NaN(length(XCorrected(XCorrected < XLim(1))),1);
    EndVector = NaN(length(XCorrected(XCorrected > XLim(2))),1);
    SplineTemp = [StartingVector;SplineTemp;EndVector];
    Data = [XCorrected',SplineTemp];
end
    