function [AUC,Height] = CalculateAUCPeak(X,Y,Center,Range)
    AUC = trapz(X(X > min(Range) & X < max(Range)),Y(X > min(Range) & X < max(Range)));
    Height = max(Y(X > min(Range) & X < max(Range)));
end