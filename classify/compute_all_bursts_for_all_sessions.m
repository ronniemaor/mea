function compute_all_bursts_for_all_sessions(parms)
    keys = getSessionKeys(parms);
    for i=1:length(keys)
        sessionKey = keys{i};
        fprintf('Computing bursts for %s\n',sessionKey)
        data = loadData(sessionKey);
        infer_all_bursts(data,parms,true);
    end
end
