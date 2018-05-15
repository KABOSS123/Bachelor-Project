function [comp, names] = getComps(text)

l = length(text(:,4));

for i = 4:l
    
    if contains(text{i,4},'-')
        comp{i-3} = text{i,4};
        names{i-3} = text{i,2};
    else
        break
    end
    
end

end