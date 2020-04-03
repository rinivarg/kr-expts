close all; clear all; 
clear all; clc;
% Created: Fall 2017 / Spring 2018
% Modified: April 2, 2019.

%%% this program was written to write experimental test files, including trial
%%% session, target session, and target files. 
%%% Conditions: Unimanual (E0), Bimanual Symmetric (E1, 5 ands 15cm), Bimanual
%%% Asymmetric (E2, AL15, AR15), Bimanual Cooperative (E3, 5 and 15 cms).

%% Main Parameters of the test session

% getting current directory
fol = pwd;
% prompts asking basic info to create folder,op name files etc.
% here we have: subject ID, experiment number (0 = Unimanual (L/R; 5/15cm)
%                                              1 = Bimanual Symmetric (5/15cm)
%                                              2 = Bimanual Asymmetric (AL15/AR15)
%                                              3 = Bimanual Cooperative (5/15cm)

prompts = {'Subj ID','Experiment','# of Conditions','# Trials/Cond'};
numLines = [1 25; 1 25; 1 25; 1 25];
all = inputdlg(prompts,'Initial Setup',numLines); % number of trials

% Based on if unimanual or bimanual session files are being created,
% generating number of trials (like Kelso, we have 25 trials/condition, for
% each of the target presentations in unimanual and bimanual conditions

conds = str2double(all{3});
Ntrials = str2double(all{4});      
trials = (1:Ntrials*conds)';
Ntargets = 7;               % number of targets
targets = (0:Ntargets-1)';  % target numbers starting from 0
IDname = strcat(all{1},'_E',all{2});

if exist(IDname,'dir') == 7        
    cd(strcat(fol,'/',IDname));
else
    mkdir(IDname);
end
cd(strcat(fol,'/',IDname));
        
%% Random order of conditions. Experimental conditions include: um and bm, various target presentations
% At the end, O_EC is the matrix in which the Ntrials per conditions are shuffled 
%(4 in each um and bm) 
% check if folder name already exists, if it does, replace
% important target size and width parameters

tgtWidth = [0.03 0.03 0.03];    %might need to change this to [0.04 0.024 0.0172] so that ID matches distance manipulations
tgtDist = [0.05 0.15];
TgtPosy = 1 + tgtDist;      % TgtPosy(1)=FarTgt; TgtPosx(2)=NearTgt;
StartPosx = [0.88 1.12 1];    % StartPosx(1)=LeftHand; StartPosx(2)=RightHand; StartPosx(3)=CenterTarget
StartSize = 0.01;

if exist(strcat(IDname,'_cond_order.txt'),'file') == 2
   delete(strcat(IDname,'_cond_order.txt'));
end

cond_order = randperm(conds)';    
dlmwrite(strcat(IDname,'_cond_order.txt'),cond_order,'-append');

% Experiment 0 (Unimanual)
Expt_0 =        [0   tgtWidth(1)    4   4                    % control condition
                 2   tgtWidth(1)    4   4
                 4   4              1    tgtWidth(1)
                 4   4              3    tgtWidth(1)];
% Experiment 1  (Bimanual Symmetric)           
Expt_1 =        [0   tgtWidth(1)   1    tgtWidth(1)          % control condition
                 2   tgtWidth(1)   3    tgtWidth(1)];        % two left columns represent target number (distance for these are set as 1.06 and 1.12 in the target description
                                                             % and size of target for L hand and two right columns represent distance and size of target for R hand
             
% Experiment 2 (Bimanual Asymmetric)
Expt_2 =        [0   tgtWidth(1)   3    tgtWidth(1)
                 2   tgtWidth(1)   1    tgtWidth(1)];
             
% Experiment 3 (Bimanual Cooperative)
Expt_3 =        [5   tgtWidth(1)   5    tgtWidth(1)         % target # 5 and 6 were created on 04/02/2019 to conduct a cooperative bimanual condition with near (5) and far distances (6)
                 6   tgtWidth(1)   6    tgtWidth(1)];       % we use hand separation distance to do this, but not sure it works the way I want it to, even one hand elicits movement. Something that needs to be clarified with Bob Sainburg.
             
O_EC = [];

for i = 1:conds
    if all{2} == '0'
       O_EC = [O_EC; repmat(Expt_0(cond_order(i),:),[Ntrials,1])];
    elseif all{2} == '1'
       O_EC = [O_EC; repmat(Expt_1(cond_order(i),:),[Ntrials,1])];
    elseif all{2} == '2'
       O_EC = [O_EC; repmat(Expt_2(cond_order(i),:),[Ntrials,1])];
    else
       O_EC = [O_EC; repmat(Expt_3(cond_order(i),:),[Ntrials,1])];
    end
end
   
%% Target file
if exist(strcat(IDname,'_tgt.txt'),'file') == 2
   delete(strcat(IDname,'_tgt.txt'));
end

% info needed
tgt_1 = targets;                                                                                        % 1/ Target Number (starts at 0)

% tgtg# [0             1             2             3               4    5              6           ]    % not to be specificed in the code but for reference here

tgt_2 = [StartPosx(1)  StartPosx(2)  StartPosx(1)  StartPosx(2)    1    StartPosx(3)   StartPosx(3)];   % 2/ Start Circle X Position (m)
tgt_3 = [1             1             1             1               1    1              1];              % 3/ Start Circle Y Position (m)
tgt_4 = [StartPosx(1)  StartPosx(2)  StartPosx(1)  StartPosx(2)    8    StartPosx(3)   StartPosx(3)];   % 4/ Target X Position (m) 
tgt_5 = [TgtPosy(1)    TgtPosy(1)    TgtPosy(2)    TgtPosy(2)      8    TgtPosy(1)     TgtPosy(2)];     % 5/ Target Y Position (m)
tgt_6 = [0             0             0             0               0    0              0];              % 6/ Direction to Target (deg)     
tgt_7 = [tgtDist(1)    tgtDist(1)    tgtDist(2)    tgtDist(2)      3    tgtDist(1)     tgtDist(2)];     % 7/ Distance to Target (m)


% generation
for i = 1:Ntargets
    tgt = [tgt_1(i),tgt_2(i),tgt_3(i),tgt_4(i),...
                   tgt_5(i),tgt_6(i),tgt_7(i)];
    dlmwrite(strcat(IDname,'_tgt.txt'),tgt,'-append');
end 

%% Target session file
if exist(strcat(IDname,'_tgt_sess.txt'),'file') == 2
   delete(strcat(IDname,'_tgt_sess.txt'));
end

% info needed
for j = 1:Ntrials*conds
tgtS_1 = trials;                 % 1/ Trial
tgtS_2 = StartSize;              % 2/ Start Circle Diameter L (m)
tgtS_3 = StartSize;              % 3/ Start Circle Diameter R (m)
tgtS_4 = O_EC(j,2);              % 4/ Target Diameter L (m)
tgtS_5 = O_EC(j,4);              % 5/ Target Diameter R (m)
tgtS_6 = 4;                      % 6/ Target Jump L (Target #)
tgtS_7 = 4;                      % 7/ Target Jump R (Target #)
tgtS_8 = 0;                      % 8/ Time to Target Jump L (sec)
tgtS_9 = 0;                      % 9/ Time to Target Jump R (sec)
tgtS_10 = O_EC(j,1);             % 10/ Target L (Target #) 
tgtS_11 = O_EC(j,3);             % 11/ Target R (Target #)
tgtS_12 = 4;                     % 12/ Pop Target (Target #)
tgtS_13 = 0;                     % 13/ Target Color L (0=gray; 1=red; 2=green; 3=blue)
tgtS_14 = 0;                     % 14/ Target Color R (0=gray; 1=red; 2=green; 3=blue)
tgtS_15 = 0.8;                   % 15/ Velocity Target Low (sec)
tgtS_16 = 1;                     % 16/ Velocity Target High (sec)
tgtS_17 = 0;                     % 17/ Target Color Delay L (sec)
tgtS_18 = 0;                     % 18/ Target Color Delay R (sec)
tgtS_19 = O_EC(j,2);             % 19/ Score Diameter L (m)
tgtS_20 = O_EC(j,4);             % 20/ Score Diameter R (m)
tgtS_21 = 0;                     % 21/ Target Jump Distance L (m)
tgtS_22 = 0;                     % 22/ Target Jump Distance R (m)
tgtS_23 = 0;                     % 23/ Trace File #

% generation

    tgtS = [tgtS_1(j),tgtS_2,tgtS_3,tgtS_4,tgtS_5,...
                          tgtS_6,tgtS_7,tgtS_8,tgtS_9,tgtS_10,...
                          tgtS_11,tgtS_12,tgtS_13,tgtS_14,tgtS_15,...
                          tgtS_16,tgtS_17,tgtS_18,tgtS_19,tgtS_20,...
                          tgtS_21,tgtS_22,tgtS_23];
    tgtS_all(j,:) = tgtS;
            
end
    dlmwrite(strcat(IDname,'_tgt_sess.txt'),tgtS_all,'-append');

%% Trial session file
if exist(strcat(IDname,'_trl_sess.txt'),'file') == 2
   delete(strcat(IDname,'_trl_sess.txt'));
end

for k = 1:Ntrials*conds
% info needed
trlS_1 = trials;                 % 1/ Trial
x = randi([350,500],1,1)./1000;
trlS_2 = 0.5 + x;                % 2/ Circletime (sec)
trlS_3 = 0;                      % 3/ Cursor Perpendicular L (0.01-10)
trlS_4 = 0;                      % 4/ Cursor Perpendicular R (0.01-10)
trlS_5 = 0;                      % 5/ Cursor Jump Start Time L (sec)
trlS_6 = 0;                      % 6/ Cursor Jump End Time L (sec)
trlS_7 = 0;                      % 7/ Cursor Jump Start Time R (sec)
trlS_8 = 0;                      % 8/ Cursor Jump End Time R (sec)
trlS_9 = 0;                      % 9/ Displace Dist X L (m)
trlS_10 = 0;                     % 10/ Displace Dist Y L (m)
trlS_11 = 0;                     % 11/ Displace Dist X R (m)
trlS_12 = 0;                     % 12/ Displace Dist Y R (m)
trlS_13 = 1;                     % 13/ Do score L (1/0 = Y/N)
trlS_14 = 1;                     % 14/ Do score R (1/0 = Y/N)
trlS_15 = 4;                     % 15/ Duration (sec) -- trial duration of 3 with upper limit of foreperiod as 3 was causing the crashing during sessions. Additionally, this causes no score when person gets even slightly delayed, so changed this to 4
trlS_16 = 0;                     % 16/ Feedback L (1/0 = Y/N)
trlS_17 = 0;                     % 17/ Feedback R (1/0 = Y/N)
trlS_18 = 0;                     % 18/ Feedback Radius setting L (0=w/i; 1=between; 2=both)
trlS_19 = 0;                     % 19/ Feedback Radius setting R (0=w/i; 1=between; 2=both)
trlS_20 = 0;                     % 20/ Feedback Radius Start L (m)
trlS_21 = 1;                     % 21/ Feedback Radius End L (m)
trlS_22 = 0;                     % 22/ Feedback Radius Start R (m)
trlS_23 = 1;                     % 23/ Feedback Radius End R (m)
trlS_24 = 1;                     % 24/ Final Position Circle L (1/0 = Y/N)
trlS_25 = 1;                     % 25/ Final Position Circle R (1/0 = Y/N)
trlS_26 = 1;                     % 26/ Gain parallel L (1=veridical)
trlS_27 = 1;                     % 27/ Gain parallel R (1=veridical)
trlS_28 = 1;                     % 28/ Gain perpendicular L (1=veridical)
trlS_29 = 1;                     % 29/ Gain perpendicular R (1=veridical)

if O_EC(k,3) == 4; trlS_30 = 1; 
elseif O_EC(k,1) == 4; trlS_30 = 0;   %% we can't simply use Expt = "1" as the conditional here because that's naive to the hand, so we use the blank target "5" to check which hand it was assigned to.. this will tell us which hand is being tested.
else; trlS_30 = 2; 
end                              % 30/ Hand (0=R; 1=L; 2=B)

if  all{2} == '3'
    trlS_31 = 0.10;   
else
    trlS_31 = 0;                 % 31/ Hand Separation Dist Start (m)
end

if  all{2} == '3' 
    trlS_32 = 0.26;   
else
    trlS_32 = 1;                 % 32/ Hand Separation Dist End (m)
end

trlS_33 = 0;                     % 33/ Hand Path Display L (1/0 = Y/N)
trlS_34 = 0;                     % 34/ Hand Path Display R (1/0 = Y/N)
trlS_35 = 0;                     % 35/ Reach through Target L (1/0 = Y/N)
trlS_36 = 0;                     % 36/ Reach through Target R (1/0 = Y/N)
trlS_37 = 0;                     % 37/ Rotation L (deg)
trlS_38 = 0;                     % 38/ Rotation R (deg)
trlS_39 = 0;                     % 39/ Time to begin feedback L (sec)
trlS_40 = 1;                     % 40/ Time to end feedback L (sec)
trlS_41 = 0;                     % 41/ Time to begin feedback R (sec)
trlS_42 = 1;                     % 42/ Time to end feedback R (sec)
trlS_43 = 0;                     % 43/ Trial conditions (integer)
trlS_44 = 0;                     % 44/ Trigger 1 Delay (sec)
trlS_45 = 0;                     % 45/ Trigger 2 Delay (sec)
trlS_46 = 0;                     % 46/ "Go" Tone Delay (sec)
trlS_47 = 3;                     % 47/ Time between Trials (sec)
trlS_48 = 0;                     % 48/ Trigger one distance (m)
trlS_49 = 0;                     % 49/ Trigger two distance (m)
trlS_50 = 0.2;                   % 50/ Timing Tolerance (sec)         
trlS_51 = 0;                     % 51/ Prep time (sec) 

% generation
    trlS = [trlS_1(k),trlS_2,trlS_3,trlS_4,trlS_5,...
                          trlS_6,trlS_7,trlS_8,trlS_9,trlS_10,...
                          trlS_11,trlS_12,trlS_13,trlS_14,trlS_15,...
                          trlS_16,trlS_17,trlS_18,trlS_19,trlS_20,...
                          trlS_21,trlS_22,trlS_23,trlS_24,trlS_25,...
                          trlS_26,trlS_27,trlS_28,trlS_29,trlS_30,...
                          trlS_31,trlS_32,trlS_33,trlS_34,trlS_35,...
                          trlS_36,trlS_37,trlS_38,trlS_39,trlS_40,...
                          trlS_41,trlS_42,trlS_43,trlS_44,trlS_45,...
                          trlS_46,trlS_47,trlS_48,trlS_49,trlS_50,trlS_51];
    dlmwrite(strcat(IDname,'_trl_sess.txt'),trlS,'-append');
end

cd(fol);
