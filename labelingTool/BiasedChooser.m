classdef BiasedChooser
% Get a list of candidates. For each candidate there is an associated 
% probability of getting a desired event if we choose it.
% The chooser draws candidates with a bias towards ones that have more
% probability of generating the desired event.
    properties
        buckets
        bucketWeights
    end
    
    methods
        function obj = BiasedChooser(candidates, probs, parms)
            % Input:
            %   candidates: array of items to choose from
            %   probs: estimated prob(desired event) per candidate
            %   additional optional parameters in parms:
            %       fBias: prob(event) -> weight
            %       nBuckets
            if ~exist('parms', 'var')
                parms = make_parms();
            end
            fBias = take_from_struct(parms, 'fBias', @(p) p);
            nBuckets = take_from_struct(parms, 'nBuckets', 10);
            
            [obj.buckets, obj.bucketWeights] = obj.createBuckets(candidates, probs, fBias, nBuckets);
        end
        
        function x = drawItem(obj)
            iBucket = randsample(length(obj.buckets),1,true,obj.bucketWeights);
            bucket = obj.buckets{iBucket};
            iCandidate = ceil(rand * length(bucket));
            x = bucket(iCandidate);
        end
    end
    
    methods(Static)
        function [buckets, weights] = createBuckets(candidates, probs, fBias, nBuckets)
            [sortedProbs, idx] = sort(probs);
            sortedCandidates = candidates(idx);
            
            buckets = divideToBins(sortedCandidates, nBuckets);            
            probsPerBucket = divideToBins(sortedProbs, nBuckets);            
            meanProbs = cellfun(@mean, probsPerBucket);
            
            weights = arrayfun(fBias, meanProbs);
        end
    end
end
