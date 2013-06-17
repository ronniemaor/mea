function [fid] = safeopen(filename,permissions)
%
% fid = safeopen(filename,permissions)
%
% Open a file and looks for the problem if fails.
%
%

  % Set default permissions 
  if(exist('permissions','var')==0)
    if(exist(filename,'file')==0), permissions = 'w';end;
    if(exist(filename,'file')==2), permissions = 'r';end;
  end

  [fid,msg] = fopen(filename,permissions);
  if(fid>0), return;end;
  
  % Try to figure out what the problem was 
  fprintf('\n\nFailed opening filename="%s"\n',filename);
  fprintf('error msg="%s"\n',msg);
  
  [path,name,ext] = fileparts(filename);
  if(exist(path,'dir')~=7)
    fprintf('\nTHE PROBLEM: Directory "%s" does not exist\n',path);
  end
  if(permissions(1)=='r' | exist(name,'file')==0)
    fprintf('\nTHE PROBLEM: File "%s%s" does not exist.\n\n',name, ext);
    fprintf('               In directory %s.\n\n',path); 
  end  
    
  error('File could not be opened');

return
