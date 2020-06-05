%%clear the previous workspace
clear

%% give user choice of a deterministic model (using averages of inflows and outflows) or a 
%% stochastic model (allowing for noise in the inflows and outflows)
pick=input('Input 1 to perform deterministic model, Input 2 to perform stochastic model:   ');

%% begin if else statement to chose which model to run (if 1 then deterministic model)
if pick==1;

%% convert initial elevation to elev_init in meters
elev=.3048*input('Input initial elevation of Mono Lake in feet:'   );

%% use elev2vol function to turn elev_init into a volume
vol=elev2vol(elev);

%%use monolakeelev function to convert vol into area of mono lake
area=vol2area(vol);

%% time step for simulation, in years
dt=1;

%%read in data on mono lake inputs and outputs
Q_in = xlsread('vorster_1937_1983.xls');

elev_recorded=((Q_in(:,2))*.3048);

%% create individual variable for rivers in cubic meters per year from Q_in matrix
river=((Q_in(:,7))*1000*1233.48);

%% create variable which is average of rivers contributions
riv=mean(river);

%% create individual variable for precipitation in meters per year from Q_in matrix
precip=((Q_in(:,8))*.3048);

%% create initial diversions, when lake level is below 6380 feet
diversions=0;

%% create variable which is average of precipitation
p=mean(precip);

%% create individual variable for evaporation in meters per year from Q_in matrix
evapotrans=((Q_in(:,9))*.3048);

%% create variable which is average of evapotrans
et=mean(evapotrans);

%% convert precipitation in meters to a volume in cubic meters based on the area which it falls over
P=p*vol2area(vol);
%% convert precipitation in meters to a volume in cubic meters based on the area which it falls over
ET=et*vol2area(vol);

%% set maximum time for 30 years - the amount of years the loop will run (thus ending in 2024)
time_max=30;

%% number of iterations based on total time and dt
imax=time_max/dt;

time=1994;

%% define quantity_record term
quantity_record=[time riv P ET diversions vol elev];

%% time loop for calculations until imax is achieved
for i=2:imax
    time=time+1;

%% calculate precipitation value with new volume
P=p*vol2area(vol);
%% calculate evapotrans value with new volume
ET=et*vol2area(vol);  
    
    %% loop to determine amount of water allowed for diversions to LA based on elevation
if elev<1943.71
    diversions=0;
    elseif elev<1944.624
    diversions=(5550660);
    elseif elev<1948.2816
    diversions=(19735680);
end

%% calculate the change in volume by calling on predefined variables per iteration
    del_vol=(riv)+(P)-(ET)-(diversions);
    vol=del_vol+vol;
    
%% convert new volume into an elevation for comparison with recorder data
    elev=1925.424886+(7.44975609e-9*vol)+(-3.019991595e-19*(vol^2));
    
%% record time, river inflow, precipitation inflow, diversions, volume, area, elevation
    quantity_record = [quantity_record; time riv P ET diversions vol elev];
end

%% loop has finished, now move into graphing data 
figure(1)
clf

%% read in data on observed lake elevation from 1850-2015
Observed_in = xlsread('mono_elevation_1850_2015.xls');
%% set variable for observed lake elevation 
Observed = (Observed_in(:,2));

%% create variable used for goal elevation
goal=[1948.2816;1948.216:47];
%%create a graph comparing elevation of Mono Lake to projected years
subplot(1,1,1)
%% plot time versus modeled elevation
plot(quantity_record(:,1),(quantity_record(:,7)/.3048),'-ok')
hold on
%% plot observed lake levels 
plot (Observed_in(145:166),(Observed(145:166)),'-','LineWidth',2)
%% plot lake level needed
plot(quantity_record(:,1), (goal/.3048),'-og')
xlabel('time(years)')
ylabel('elevation(feet)')
title ('Projected elevation of Mono Lake with respect to time (blue is observed, green is goal elevation)')

%% if user does not choose 1, use stochastic model
else
    
%% run inner loops for 20 times (500 takes > 2 hours (model is slow))to measure variation in stochastic model  
for x=1:500 'FinalModel.m';
%% convert initial elevation to elev_init in meters
elev=.3048*6374;

%% use elev2vol function to turn elev_init into a volume
vol=elev2vol(elev);

%% use monolakeelev function to convert vol into area of mono lake
area=vol2area(vol);

%% time step for simulation, in years
dt=1;

%%read in data on mono lake inputs and outputs
Q_in = xlsread('vorster_1937_1983.xls');

%% read in data on observed lake elevation from 1850-2015
Observed_in = xlsread('mono_elevation_1850_2015.xls');
%% set variable for observed lake elevation 
Observed = (Observed_in(:,2));

%% call in the recorded elevation
elev_recorded=((Q_in(:,2))*.3048);

%% create individual variable for rivers in cubic meters per year from Q_in matrix
river=((Q_in(:,7))*1000*1233.48);

%% create variable which is average and standard dev of rivers contributions
avg_Riv=mean(river);
std_Riv=std(river);
riv=normrnd(avg_Riv,std_Riv);

%% create individual variable for precipitation in meters per year from Q_in matrix
precip=((Q_in(:,8))*.3048);

%% create variables which are average and standard dev of precipation
avg_P=mean(precip);
std_P=std(precip);

%% create initial diversions for when lake level is below 6380 feet
diversions=0;

%% create individual variable for evaporation in meters per year from Q_in matrix
evapotrans=((Q_in(:,9))*.3048);

%% create variable which is average of evapotrans
avg_ET=mean(evapotrans);
%%  and one for its standard deviation
std_ET=std(evapotrans);

%% convert randomized precipitation in meters to a volume in cubic meters based on the area which it falls over
P=normrnd(avg_P,std_P)*vol2area(vol);

%% convert randomized evapotrans in meters to a volume in cubic meters based on the area which it falls over
ET=normrnd(avg_P,std_P)*vol2area(vol);

%% the maximum amount of time the loop will inner loop will run for
time_max=30;

%% number of iterations based on total time and dt
imax=time_max/dt;

%% input a starting time
time=1994;

%%  preallocate quantity_record variable to improve speed (not active)
% quantity_record=zeros(40,7);

%% define quantity_record term and size
quantity_record=[time riv P ET diversions vol elev];

% %% define sum_record term 
% sum_record=[quantity_record; time riv P ET diversions vol elev];
% elev1=0;
% time1=0;

%% time loop for calculations until imax is achieved

%% The inner loop with iterations being 1 year at a time. These iterations are recorded in quantity_record
%% and then plotted once the 30 iterations have run (but ultimately once the 500 iterations have run)
for i=2:imax
    time=time+1;

%% randomize river inflow
riv=normrnd(avg_Riv,std_Riv);

%% randomize precipitation and convert it to cubic meters
P=normrnd(avg_P,std_P)*vol2area(vol);

%% randomize evapotrans and convert it to cubic meters
ET=normrnd(avg_ET,std_ET)*vol2area(vol);

%% loop to determine amount of water allowed for diversions to LA based on original legislation

%% use divers function, which houses a switch, to determine the quantity of diversions allowed
        if elev<(6392*.3048);
        sign=1;
        elseif elev>(6392*.3048);
        sign=-1;
        end
    
    %Calculating Diversion based on Elevation (meters)
    diversions=divers(elev,sign);
    
%% calculate the change in volume by calling on predefined variables per iteration
    del_vol=(riv)+(P)-(ET)-(diversions);
    vol=del_vol+vol;
    
%% convert new volume into an elevation for comparison with recorded data
    elev=1925.424886+(7.44975609e-9*vol)+(-3.019991595e-19*(vol^2));


%% record time, inflows and outflows, volume, and elevation
    quantity_record = [quantity_record; time riv P ET diversions vol elev];

%% loop has finished, now move into graphing data 
% figure(1)
% clf

%% create a horizontal line at the goal elevation 
goal=[1948.2816;1948.216:47];
%% create a graph comparing elevation of Mono Lake to projected years
% subplot(1,1,1)

%% plot time versus modeled elevation
plot(quantity_record(:,1),(quantity_record(:,7)/.3048),'-')
hold on

%% plot observed lake levels 
plot (Observed_in(145:166),(Observed(145:166)),'-','LineWidth',2)
hold on

%% plot lake level needed
plot(quantity_record(:,1), (goal/.3048),'-')
xlabel('time(years)')
ylabel('elevation(feet)')
title ('Projected elevation of Mono Lake with respect to time')
hold on 
end
end
end
