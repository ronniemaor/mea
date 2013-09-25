function fig_save(filename,doit,formats)
%
% fig_save(filename,doit,formats)
%
% doit - 1 by default. If 0, nothign is saved. Can be used to
%        control all printings in a script/function
% formats, cell array with format names. example: {'png','eps','tif'}
%
  if(nargin<2)  doit=1;end
  if(nargin<3)  formats = {'png'};end;
  if(~doit) return ; end; 
  
  % Print png file 
  if(length(strmatch('png',formats))>0)
    try
      png_filename = [filename '.png'];
      print(png_filename,'-dpng');
      fprintf('saved "%s" successfully.\n',png_filename);
    catch 
      
      [pathstr, name] = fileparts(filename);
      if(exist(pathstr,'dir')==0)
	fprintf('\nDirectory %s does not exist! Couldnt save "%s".\n',pathstr,png_filename);
      else
	fprintf('\nCouldnt save "%s".\n',png_filename);
      end
    end 
  end
  
  % Print eps file 
  if(length(strmatch('eps',formats))>0)
    eps_filename = [filename '.eps'];
    print('-depsc2',eps_filename);
    fprintf('saved "%s" successfully.\n',eps_filename);
  end

  % Print tiff file 
  if(length(strmatch('tiff',formats))>0)
    tif_filename = [filename '.tif'];
    print('-dtiff',tif_filename);
    fprintf('saved "%s" successfully.\n',tif_filename);
  end

  % Print jpg file 
  if(length(strmatch('jpg',formats))>0)
    jpg_filename = [filename '.jpg'];
    print('-djpeg',jpg_filename);
    fprintf('saved "%s" successfully.\n',jpg_filename);
  end

  % Print gif file 
  if(length(strmatch('gif',formats))>0)
    gif_filename = [filename '.gif'];
    print('-djpeg',gif_filename);
    fprintf('saved "%s" successfully.\n',gif_filename);
  end
end