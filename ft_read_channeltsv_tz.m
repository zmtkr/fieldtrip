function [chanType, chanUnit] = ft_read_channeltsv_tz(filedir, vhdrname, data)

channelFile     = fullfile(filedir, replace(vhdrname, "eeg.vhdr", "channels.tsv"));
chaninfo        = readtable(channelFile, 'FileType', 'text', 'Delimiter', '\t');

chanType        = cell(size(data.label));
chanUnit        = chanType;

for L = 1:numel(data.label)
    idx = find(strcmp(data.label{L}, chaninfo.name));
    if ~isempty(idx)
        chanType{L} = chaninfo.type{idx};
        chanUnit{L} = chaninfo.units{idx};
    else
        chanType{L} = 'unknown';
        chanUnit{L} = 'unknown';
    end
end

end

