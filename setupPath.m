function setupPath()
    path(pathdef)
    codeDir = fileparts(mfilename('fullpath'));
    path(path,codeDir);
    path(path,[codeDir '/lab']);
    path(path,[codeDir '/3rd party']);
    path(path,[codeDir '/util']);
    path(path,[codeDir '/labelingTool']);
    path(path,[codeDir '/classify']);
    path(path,[codeDir '/figures']);
    path(path,[codeDir '/gal_copy_for_ronnie']);
    path(path,[codeDir '/eli nelken']);
end