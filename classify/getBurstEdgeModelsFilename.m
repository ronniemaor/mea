function fname = getBurstEdgeModelsFilename()
    classifyDir = fileparts(mfilename('fullpath'));
    fname = [classifyDir, '/burst_edge_models.mat'];
end
