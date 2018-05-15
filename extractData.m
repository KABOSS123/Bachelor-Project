function data = extractData(data)

[r, ~] = size(data);

% Deletes row if it does not contain data.
for i = r:-1:1
    if isnan(data(i,1))
        data(i,:) = [];
    else
        break
    end
end

[r, ~] = size(data);

% Removes everything remaining that is not data.
for i = r:-1:1
    if isnan(data(i,1))
        data = data(i+1:end,:);
        break
    end
end