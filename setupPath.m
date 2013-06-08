function setupPath()
    codeDir = fileparts(mfilename('fullpath'));
    path(path,codeDir);
    path(path,[codeDir '/3rd party']);
    path(path,[codeDir '/util']);
    path(path,[codeDir '/figures']);
    path(path,[codeDir '/eli nelken']);
end