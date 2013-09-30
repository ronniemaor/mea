function models = trainBurstEdges(dataname, parms)

    if ~exist('dataname', 'var')
        dataname = 'bac10a';
    end

    
    % Load the data
    data = loadData(dataname);
  
    % Load labels 
    labelsData = loadLabels(data.sessionKey, 'merged-yuval');
    labelsData = remove_nans_from_labels_data(labelsData);
    labelsData = remove_duplicates_from_labels_data(labelsData);

    % Shift begin times that have <=1 spikes
    n_active = times_to_num_active_units(data, parms, parms.estimate_bin_sec);  
    beg_labels_in_sec = tighten_burst_start_end_labels(n_active, labelsData.burstStartTimes, true, parms);
    end_labels_in_sec = tighten_burst_start_end_labels(n_active, labelsData.burstEndTimes, false, parms);

    default_f_list = { 'r+1', 'r+2', 'r-1', 'r-2', 'n0' , 'n-1', ...
                       'n-2', 'n+1', 'n+2' };
    [f_list, parms] = take_from_struct(parms, 'f_list', default_f_list);

    % Train and Test
    [beg_features, beg_labels] = build_train_set(n_active, beg_labels_in_sec, true, parms);
    [beg_best_model, beg_AUC] = train_and_test(beg_features, beg_labels, parms);
    fprintf('Computed model for burst beginnings. AUC=%g\n', beg_AUC);        
    [end_features, end_labels] = build_train_set(n_active, end_labels_in_sec, false, parms);
    [end_best_model, end_AUC] = train_and_test(end_features, end_labels, parms);
    fprintf('Computed model for burst endings. AUC=%g\n', end_AUC);
    
    models = make_parms('beg_model', beg_best_model, 'end_model', end_best_model, 'f_list', f_list');
    save(getBurstEdgeModelsFilename(), '-struct', 'models');
end
