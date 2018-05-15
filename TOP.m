function PV = TOP(comp)
% The function TOP (Table of parameters) creates a cell array containing
% the names of the components, their Cas-NOs and their parameters. 
% Call: TOP(comp)

% Reads the parameter tables from excel, concatenates them and converts the
% new table into a cell array.
T1 = readtable('Data.xlsx','sheet','Params1');
T2 = readtable('Data.xlsx','sheet','Params2');

T = horzcat(T1,T2(:,3:end));
T = table2cell(T);

% Finds the row in which the component is located and saves the entire row.
PV = cell(length(comp),11);

for i = 1:length(comp)
    [r, ~] = find(strcmp(comp(i),T));
    PV(i,:) = T(r,:);
end

end

