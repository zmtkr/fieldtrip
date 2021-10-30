function trl = mytrialfun_S1S2(cfg)

% this function requires the following fields to be specified
% cfg.dataset
% cfg.trialdef.eventtype
% cfg.trialdef.eventvalue
% cfg.trialdef.prestim
% cfg.trialdef.poststim

hdr   = ft_read_header(cfg.dataset);
event = ft_read_event(cfg.dataset);

trl = [];


for i=1:length(event)
    if strcmp(event(i).type, cfg.trialdef.eventtype)
      % it is a trigger, see whether it has the right value
      if strcmpi(event(i).value, cfg.trialdef.eventvalue(1))
            % add this to the trl definition
            begsample     = event(i).sample;
      elseif strcmpi(event(i).value, cfg.trialdef.eventvalue(2))
          endsample   = event(i).sample;
      end
    end
end

offset = 0;

  
trl = round([begsample endsample offset]) ;
  



