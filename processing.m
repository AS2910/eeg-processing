close all;
clear all;
% Set Folder Path where all the clean data is contained
folder_path = ""; %Include address to main path
folder_names = dir(folder_path);
% Load EEGLab
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
Fs = ; %Enter the Sampling Frequency
% iterate through each person
for i=1:size(folder_names)
    folderName = folder_names(i).name;
    if(strcmp(folderName,'.')==1)
        continue
    end
    if(strcmp(folderName,'..')==1)
        continue
    end
    disp(folderName);    
    file_path = dir(folder_path+folderName+"\");
    % iterate through each video in the folder
    for j=1:size(file_path)
        fileName = file_path(j).name;
        if(strcmp(fileName,'.')==1)
            continue
        end
        if(strcmp(fileName,'..')==1)
            continue
        end
        disp(fileName);
        % Loading the data and the channel locs
        close all;
        % The whole block is under try and catch to avoid any errors which
        may result in the whole script being stopped.
        try
            [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
            try    
                EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',char(folder_path+folderName+"\"+fileName),'srate',Fs,'pnts',0,'xmin',0,'chanlocs',chann_locs_address);% add channel location address
            catch
                continue;
            end

            % High Pass Filter, to remove the DC Offset
            EEG = pop_eegfiltnew(EEG, 'locutoff',1,'plotfreqz',1);
            EEG_init = EEG;
            initial_channels = {EEG.chanlocs.labels};

            %removing bad channels
    %without correlation
    %         EEG = clean_artifacts(EEG, 'FlatlineCriterion',5,'ChannelCriterion','off','LineNoiseCriterion',4,'Highpass','off','BurstCriterion','off','WindowCriterion','off','BurstRejection','on','Distance','Euclidian');
    %With correlation
            EEG = clean_artifacts(EEG, 'FlatlineCriterion',5,'ChannelCriterion',0.8,'LineNoiseCriterion',4,'Highpass','off','BurstCriterion','off','WindowCriterion','off','BurstRejection','on','Distance','Euclidian');

            channels_left_after_rejection = {EEG.chanlocs.labels};
            rejected_channels = setdiff(initial_channels,channels_left_after_rejection);

            %saving the filtered dataset
            EEG = pop_saveset( EEG, 'filename',char(fileName(1:end-4)+"_filtered.set"),'filepath',char(folder_path+folderName+"\filtered_ica\"));

            %Wavelet-Enhanced ICA
            %W-ICA Using http://www.mat.ucm.es/~vmakarov/Supplementary/wICAexample/TestExample.html
            %Download W-ICA From the above site and to path
            [weight, sphere] = runica(EEG.data, 'verbose', 'on');
            Data = EEG.data;
            W = weight*sphere;    % EEGLAB --> W unmixing matrix
            icaEEG = W*Data;      % EEGLAB --> U = W.X activations
            [icaEEG2, opt]= RemoveStrongArtifacts(icaEEG, (1:4), 1.25, Fs);
            Data_wICA = W\icaEEG2;
            EEG.data = Data_wICA;

            % Independent Component Analysis 
            EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','on');

            %Using MARA to reject ICs
    %         [~,EEG,~]=processMARA ( EEG,EEG,EEG );
            [~,EEG,~]  = processMARA(ALLEEG,EEG,CURRENTSET);
            EEG.reject.gcompreject = zeros(size(EEG.reject.gcompreject)); 
            EEG.reject.gcompreject(EEG.reject.MARAinfo.posterior_artefactprob > 0.5) = 1;
            EEG.setname='wavcleanedEEG_ICA_MARA';
            EEG = eeg_checkset( EEG );
            artifact_ICs=find(EEG.reject.gcompreject == 1);
            EEG = pop_subcomp( EEG, artifact_ICs, 0);
            EEG.setname='wavcleanedEEG_ICA_MARA_rej'; 
            EEG = pop_saveset( EEG, 'filename',char(fileName(1:end-4)+"_filtered_ica_mara.set"),'filepath',char(folder_path+folderName+"\filtered_ica\"));
            
            %extracting indexes of initial channels for interpolation
            chan_indexes_init = [];
            for i=1:length(rejected_channels)
                chan_indexes_init = [chan_indexes_init, find(initial_channels ==string(rejected_channels{i}))];
            end
            
            %interpolation of channels
            EEG = pop_interp(EEG, EEG_init.chanlocs(chan_indexes_init), 'spherical');
            
            %re-referencing the channels - Avg references
            EEG = pop_reref( EEG, []);      
            EEG = pop_saveset( EEG, 'filename',char(fileName(1:end-4)+"_final.set"),'filepath',char(folder_path+folderName+"\filtered_ica\"));
        catch
                continue
        end
    
    end
    
end
        