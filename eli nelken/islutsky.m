unitar=struct; % unitnum x iper, fields = elec, unit. never read.
ar=zeros(76,12*60*100,3); % spike train: unit X time X iper
if exist('ten_uM')
    uM=ten_uM;
else
    uM=one_uM;
end

%%
% construct spike trains from the spike times => ar
% also store some metadata (not used later) => unitar
%
% Original data structure seems to be:
%   cell(3 times,60 electrodes)
%   I assume 3 times are baseline, shortly after baclofen, after recovery
%   Each cell contains array of unit spikes with 3 columns:
%     1) electrode number (same for rows of this cell)
%     2) unit number (only unique within electrode)
%     3) spike time [sec]
for iper=1:3
    unitnum=0;
    for ii=1:60,
        if ~isempty(uM{iper,ii})
            elec=uM{iper,ii}(1,1);
            units=unique(uM{iper,ii}(:,2)); % units for this electrode
            for iu=1:length(units)
                unitnum=unitnum+1; % globally unique unit number
                unitar(unitnum,iper).elec=elec;
                unitar(unitnum,iper).unit=units(iu);
                inds=find(uM{iper,ii}(:,2)==units(iu)); % rows for current unit
                times=uM{iper,ii}(inds,3); % times for current unit
                times=ceil(times*100); % 10 msec bins
                times=times(times<=12*60*100); % take only first 12 minutes
                ar(unitnum,times,iper)=1; % mark a spike
            end
        end
    end
end
ar=ar(1:unitnum,:,:); % remove extra space allocated for more units

%%
% total network activity, smoothed with 10 bin window (100 msec)
win=hamming(11);
win=win/sum(win);
popr=filtfilt(win,1,squeeze(sum(ar,1))); % filters all iper in parallel

%%
sur=ar; % initialization is just for size. data is overwritten.
psur=popr; % initialization is just for size. data is overwritten.
for ii=1:3,
    sur(:,:,ii)=ar(:,randperm(size(ar,2)),ii); % random shuffle of time bins (same for all units)
    psur(:,ii)=filtfilt(win,1,squeeze(sum(sur(:,:,ii)))); % smoothed total network activity on shuffled data
    figure(ii);
    plot([popr(:,ii) psur(:,ii)]); % correlation scatter plot between original and shuffled rates. why?
    ax(ii)=gca;
end
linkaxes(ax); % good to know!

%%
% show distribution of large "network spikes" - regular train vs shuffled
for ii=1:3,
    [pks,locs]=findpeaks(popr(:,ii)); % network spikes of original train
    [spks,slocs]=findpeaks(psur(:,ii)); % network spikes for shuffled train (what does this mean?)
    thr=prctile(spks,99); % take common threshold from shuffled data (why? probably because it's lower)
    [n,a]=hist([pks(pks>thr)' spks(spks>thr)'],10);
    n=hist(pks(pks>thr),a); % why do it again? we have the data already in n(:,1)
    n=n/length(pks); % normalize to probability
    sn=hist(spks(spks>thr),a);
    sn=sn/length(spks);
    figure(ii);
    bar(a,[n(:) sn(:)]); % plot the two distributions (of very high value network spikes, regular vs shuffled)
end

%%
% auto-correlations. 
% For each unit show correlations for the 3 time points
for ii=1:size(ar,1) % go over all units
    for iper=1:3
        plot(-100:100,xcorr(ar(ii,:,iper),100)); % auto-correlation, +/- 1 second (100 bins)
        hold all
    end
    title(ii)
    axis([-100 100 0 50])
    pause
    hold off
end