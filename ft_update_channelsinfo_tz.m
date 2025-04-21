function [data, chantype, chanunit] = ft_update_channelsinfo_tz(cfg, data_in)


data        = data_in;
chantype    = [];
chanunit    = [];

%% data.elec update

idx = ismember(data_in.elec.label, data_in.label);

data.elec.chanpos   = data_in.elec.chanpos(idx);
data.elec.chantype  = data_in.elec.chantype(idx);
data.elec.chanunit  = data_in.elec.chanunit(idx);
data.elec.elecpos   = data_in.elec.elecpos(idx);
data.elec.label     = data_in.elec.label(idx);


%% cantype_all
if isfield(cfg, 'chantype') && isfield(cfg, 'orglabel')
    idx         = ismember(cfg.orglabel, data_in.label);
    chantype    = cfg.chantype(idx);

   
else
    warning("Not update chantype");
end

%% cantype_all
if isfield(cfg, 'chanunit') && isfield(cfg, 'orglabel')
    idx         = ismember(cfg.orglabel, data_in.label);
    chanunit    =cfg.chanunit(idx);
    
else
    warning("Not update chanunit");
end

%%
if isfield(data_in, 'hdr')
    data.hdr.chantype   = chantype;
    data.hdr.chanunit   = chanunit;
    data.hdr.nChans     = length(data_in.label);
    data.hdr.label      = data_in.label;
    data.hdr.elec       = data.elec;
end

end