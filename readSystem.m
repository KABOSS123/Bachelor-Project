function [data, comp, usePTFlash] = readSystem()

choice1 = menu('Which type of system would you like to read?',...
    'Base system', 'User system', 'Custom system');

% Switches between three different actions depending on choice1.
switch choice1
    
    case 1
        choice2 = menu('Choose system',...
            'Methanol - Water','Methanol - Benzene',...
            'Methanol - Ethanol','Benzene - Water',...
            'Ethanol - Benzene - Water');
        
        % Reads the chosen system and saves text and numbers seperately.
        if choice2 == 1
            [data, text] = xlsread('Data','O:R');
            usePTFlash = 0;
        elseif choice2 == 2
            [data, text] = xlsread('Data','V:Y');
            usePTFlash = 0;
        elseif choice2 == 3
            [data, text] = xlsread('Data','AC:AF');
            usePTFlash = 0;
        elseif choice2 == 4
            [data, text] = xlsread('Data','AJ:AM');
            usePTFlash = 1;
        elseif choice2 == 5
            [data, text] = xlsread('Data','C:H');
            usePTFlash = 1;
        elseif choice2 == 0
        data = 'exit'; comp = 'exit'; usePTFlash = 'exit';
        end
        
        
        % Finds the Cas-NOs and saves them in a cell array called comp.
        % Extracts the dataset from the matrix read by 'xlsread'.
        if choice2 ~=0
            comp = getComps(text);
            data = extractData(data);
        end
        
    case 2
        % Reads all of the user systems.
        [data, text] = xlsread('Data','UserSystem');
        
        % Splits the user systems.
        [dataSets, texts, NS] = splitSystems(data, text);
        
        % Initialises a cell that will keeps the options for the menu, and
        % one that keeps
        options = cell(1,NS);
        comp = cell(1,NS);
        
        for i = 1:NS
            [comp{i}, names] = getComps(texts{i}); 
            if length(names) == 2
                    options{i} = [names{1}, ' and ', lower(names{2})];
            elseif length(names) == 3
                    options{i} = [names{1}, ', ', lower(names{2}),...
                        ' and ', lower(names{3})];
            end  
        end
        
        choice3 = menu('Choose system', options);
        
        if choice3 ~= 0
            comp = comp{choice3};
            data = extractData(dataSets{choice3});
            usePTFlash = 1;
        else
            data = 'exit'; comp = 'exit'; usePTFlash = 'exit';
        end
        
    case 0
        data = 'exit'; comp = 'exit'; usePTFlash = 'exit';
        
end

end