function [w,b] = getSvmWeights(model)
% Taken from libsvm FAQ:
% http://www.csie.ntu.edu.tw/~cjlin/libsvm/faq.html#f804
% also: http://stackoverflow.com/questions/10131385/matlab-libsvm-how-to-find-the-w-coefficients
    t = model.Parameters(2);
    assert(t == 0, 'This code only works for linear kernel');
    labels = sort(model.Label);
    assert(isequal(labels,[-1; 1]), 'This code only works for labels -1 and 1');
    w = model.SVs' * model.sv_coef;
    b = -model.rho;
    if model.Label(1) == -1
        w = -w;
        b = -b;
    end
end
