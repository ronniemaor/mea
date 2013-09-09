function [best_model, AUC, FPRs, TPRs, THRESHs] = train_and_test(features, ...
						  labels, parms)
%
  method = take_from_struct(parms, 'method', 'lasso');
  seed = take_from_struct(parms, 'seed', 1);  
  do_plot = take_from_struct(parms, 'do_plot', false);
  if do_plot
    figure(2); clf; hold on;
    clrs = set_colors;    
  end

  
  for i_fold = 1:5 
    fprintf('i_fold = %d\n', i_fold);
    % Split, train and test
    [trn_features, tst_features, trn_labels, tst_labels] = ...
	split_data(features, labels, seed, i_fold);
    
    % Regulrized Logistic regression
    switch method
     case 'lassoglm', 
      [beta, stats] = lassoglm(trn_features, trn_labels, 'binomial', 'CV', ...
			       5, 'NumLambda', 20, 'Standardize', true);
      best_model  = beta(:, stats.Index1SE);
      
     case 'lasso'
      [beta, stats] = lasso(trn_features, trn_labels, 'CV', 5, ...
			    'NumLambda', 20, 'Standardize', true);
      best_model  = beta(:, stats.Index1SE);
    
     case 'cart'
      % tree = ClassificationTree.fit(trn_features, trn_labels, 'kfold', 5);
     
     otherwise
      error('invalid method = %s\n', method);
    end

    % Score the model on the test sampels 
    tst_scores = test_model(method, tst_features, best_model);
    
    
    [FPRs{i_fold}, TPRs{i_fold}, THRESHs{i_fold}, AUCs(i_fold)] = ...
	perfcurve(tst_labels, tst_scores, 1);
    if do_plot
      plot(FPRs{i_fold}, TPRs{i_fold}, 'Color', clrs{i_fold}, ...
	   'Linewidth', 3);
      xlabel('False positive rate', 'Fontsize', 20);
      ylabel('True positive rate', 'Fontsize', 20);      
      set(gca, 'Fontsize', 18)
    end
  end
  AUC = mean(AUCs);
end
