function [WL] = getWL(d1, d2, gnum)
% getwL retrieves Water Level data from the thredds server (both locs)
%   
%   INPUTS 
%       d1-start date in matlab datenum format - ex. datenum(2015,10,2)
%       d2-end date in matlab datenum format - see above
%       gnum is the gauge number (11 only for WL)
%           1 = gauge 11 (end of pier) - all that is currently available



%
% % % % % % % % 
%% Main code 
% defining data location url (1st part)
svrloc='http://chlthredds.erdc.dren.mil/thredds/dodsC/frf';  % The prefix for the CHL thredds server
% defining 2nd part
if gnum==1;
    urlback='oceanography/waterlevel/11/11.ncml'; % Water Level 
elseif gnum==2;
    urlback='oceanography/waterlevel/11/11.ncml'; 
else
    disp 'please visit http://chlthredds.erdc.dren.mil/thredds/catalog/frf/catalog.html\n' ...
          'and browse to the gauge of interest and select proper url and add to program'
end
url=strcat(svrloc,urlback); % combining first and 2nd part of url string

% pulling down time now
time=ncread(url,'time'); % downloading time from server
tunit= ncreadatt(url,'time','units'); % reading attributes of variable time
% converting time to matlab datetime
mtime=time/(3600.0*24)+datenum(1970,1,1);
% finding index that corresponds to dates of interest
sprintf('WL record starts %s and ends %s', datestr(min(mtime)),datestr(max(mtime)))
itime=find(d1 < mtime & d2> mtime); % indicies in netCDF record of data of interest


% pulling data from server with itime index 
WL.time = mtime(itime); % record of time in matlab datetime 
WL.WL = ncread(url,'waterLevelHeight',min(itime),length(itime));  % measured water level
WL.PredictedWL = ncread(url,'predictedWaterLevelHeight',min(itime),length(itime));  % predicted WL
WL.name = ncread(url,'station_name'); % station name 
WL.lat = ncread(url,'lat'); % latitutde 
WL.lon = ncread(url, 'lon'); % lon 

end
