function test_ft_analysispipeline

% MEM 1gb
% WALLTIME 03:00:00
% DEPENDENCY ft_analysispipeline
% DATA private

% the style of this test script is also used in test_ft_datatype and test_bug2185

dirlist = {
  dccnpath('/project/3031000.02/test/latest')
  dccnpath('/project/3031000.02/test/20131231')
  dccnpath('/project/3031000.02/test/20130630')
  dccnpath('/project/3031000.02/test/20121231')
  dccnpath('/project/3031000.02/test/20120630')
  dccnpath('/project/3031000.02/test/20111231')
  dccnpath('/project/3031000.02/test/20110630')
  dccnpath('/project/3031000.02/test/20101231')
  dccnpath('/project/3031000.02/test/20100630')
  dccnpath('/project/3031000.02/test/20091231')
  dccnpath('/project/3031000.02/test/20090630')
  dccnpath('/project/3031000.02/test/20081231')
  dccnpath('/project/3031000.02/test/20080630')
  dccnpath('/project/3031000.02/test/20071231')
  dccnpath('/project/3031000.02/test/20070630')
  dccnpath('/project/3031000.02/test/20061231')
  dccnpath('/project/3031000.02/test/20060630')
  dccnpath('/project/3031000.02/test/20051231')
  dccnpath('/project/3031000.02/test/20050630')
  dccnpath('/project/3031000.02/test/20040623')
  dccnpath('/project/3031000.02/test/20031128')
  };

for j=1:length(dirlist)
  filelist = hcp_filelist(dirlist{j});
  
  [dummy, dummy, x] = cellfun(@fileparts, filelist, 'uniformoutput', false);
  sel = strcmp(x, '.mat');
  filelist = filelist(sel);
  clear p f x
  
  for i=1:length(filelist)
    
    % skip the large files
    d = dir(filelist{i});
    if d.bytes>50000000
      continue
    end
    
    try
      fprintf('processing data structure from %s\n', filelist{i});
      var = loadvar(filelist{i});
      disp(var)
    catch
      % some of the mat files are corrupt, this should not spoil the test
      disp(lasterr);
      continue
    end
    
    cfg = [];
    cfg.showcallinfo = 'no';
    ft_analysispipeline(cfg, var);
    set(gcf, 'Name', shortname(filelist{i}));
    drawnow
    close all
    
  end % for filelist
  
end % for dirlist
end % main function



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function str = shortname(str)
len = 50;
if length(str)>len
  begchar = length(str)-len+4;
  endchar = length(str);
  str = ['...' str(begchar:endchar)];
end
end % function shortname
