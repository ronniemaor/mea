function scores = test_model(method, features, model)
  
  
  switch method
   case 'lasso'
    scores = features * model;
   otherwise
    error('Not implemented yet');
  end
end