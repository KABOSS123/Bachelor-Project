function [dataSets, texts, NS] = splitSystems(data, text)
% This function takes a data set as input and splits it into parts marked
% by full columns of NaNs. The text input is split the in the same places.
% Output:
% dataSets - cell with length corresponding to number of elements.
% texts - cell with length corresponding to number of elements.
% NS - number of elements. 

[r, c] = size(data);
EC = zeros(1, c);

% Finds the empty columns.
for i = 1:c
    if sum(isnan(data(:,i))) == r
        EC(i) = 1;
    end
end

% Finds columns with content, saves the indices where there is 
% a change between systems, and deletes empty columns.
c = find(EC==0);
d = diff(c);
e = find(d>1);
data = data(:,c);
text = text(:,c);

% Number of systems.
NS = length(e)+1;

% Initiates a counter and a cell that can contain each system.
counter = 0;
dataSets = cell(1,NS);
texts = cell(1,NS);

% Separates systems.
for i = length(e):-1:1
    
    counter = 1+counter;
    dataSets{counter} = data(:,e(i)+1:end);
    texts{counter} = text(:,e(i)+1:end);
    data = data(:,1:e(i));
    text = text(:,1:e(i));
    
end

% Saves the remaining system, and flips the cell array to make the lineup
% match the one in excel in excel.
dataSets{end} = data;
texts{end} = text;
dataSets = fliplr(dataSets);
texts = fliplr(texts);

end







        

        
        
        
