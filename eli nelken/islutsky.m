unitar=struct;
ar=zeros(76,12*60*100,3);
if exist('ten_uM')
    uM=ten_uM;
else
    uM=one_uM;
end
%%
for iper=1:3
    unitnum=0;
    for ii=1:60,
        if ~isempty(uM{iper,ii})
            elec=uM{iper,ii}(1,1);
            units=unique(uM{iper,ii}(:,2));
            for iu=1:length(units)
                unitnum=unitnum+1;
                unitar(unitnum,iper).elec=elec;
                unitar(unitnum,iper).unit=units(iu);
                inds=find(uM{iper,ii}(:,2)==units(iu));
                times=uM{iper,ii}(inds,3);
                times=ceil(times*100);
                times=times(times<=12*60*100);
                ar(unitnum,times,iper)=1;
            end
        end
    end
end
ar=ar(1:unitnum,:,:);
%%
win=hamming(11);
win=win/sum(win);
popr=filtfilt(win,1,squeeze(sum(ar,1)));
%%
sur=ar;
psur=popr;
for ii=1:3,
    sur(:,:,ii)=ar(:,randperm(size(ar,2)),ii);
    psur(:,ii)=filtfilt(win,1,squeeze(sum(sur(:,:,ii))));
    figure(ii);
    plot([popr(:,ii) psur(:,ii)]);
    ax(ii)=gca;
end
linkaxes(ax);
%%
for ii=1:3,
    [pks,locs]=findpeaks(popr(:,ii));
    [spks,slocs]=findpeaks(psur(:,ii));
    thr=prctile(spks,99);
    [n,a]=hist([pks(pks>thr)' spks(spks>thr)'],10);
    n=hist(pks(pks>thr),a);
    n=n/length(pks);
    sn=hist(spks(spks>thr),a);
    sn=sn/length(spks);
    figure(ii);
    bar(a,[n(:) sn(:)]);
end
%%
for ii=1:size(ar,1)
for iper=1:3
    plot(-100:100,xcorr(ar(ii,:,iper),100));
    hold all
end
title(ii)
axis([-100 100 0 50])
pause
hold off
end