 function [SignalXSort,SignalYSort] = OrderSpectra(SignalX,SignalY) % order signals ascending
        for q = 1:length(SignalX)
           Min(q) = min(SignalX{q}); % Find minima of each
        end
        [Sorted,Indices] = sort(Min); % Sort and store sorted indices    
        Counter = 1;
        for g = Indices% Use inidec and counter to sort ascending
            SignalXSort{Counter} = SignalX{g};
            SignalYSort{Counter} = SignalY{g};
            Counter = Counter + 1;
        end

    end