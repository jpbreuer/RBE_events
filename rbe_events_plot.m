clear all;close all;

eventTimes = importdata('RBE_times.txt',' ');

eventTime = datenum(eventTimes, 'yyyy-mm-dd HH:MM:SS');
RelativeTime = ([7, 0, 0, 0] * [24*3600; 3600; 60; 1]) / 86400;

BeforeTime = eventTime - RelativeTime;
AfterTime = eventTime + RelativeTime;

startTime = cellstr(datestr(BeforeTime, 'yyyy-mm-dd HH:MM:SS'));
endTime = cellstr(datestr(AfterTime, 'yyyy-mm-dd HH:MM:SS'));

for ii = 1%:length(startTime)
    % IMF Bz
    api = 'http://iswa.gsfc.nasa.gov/IswaSystemWebApp/DataStreamServlet';
    url = sprintf([api '?format=text&quantity=B_z&resource=ACE&resourceInstance=ACE&end-time=%s&begin-time=%s'],endTime{ii},startTime{ii});
    filename = 'IMF_Bz.txt';
    outfilename = websave(filename,url);
    IMF_Bz_data = importdata('IMF_Bz.txt',' ',1);

end
    %% Solar Wind BulkSpeed
    api = 'http://iswa.gsfc.nasa.gov/IswaSystemWebApp/DataStreamServlet';
    url = sprintf([api '?format=text&quantity=BulkSpeed&resource=ACE&resourceInstance=ACE&end-time=%s&begin-time=%s'],endTime{ii},startTime{ii});
    filename = 'SW_BulkSpeed.txt';
    outfilename = websave(filename,url);
    BulkSpeed_data = importdata('SW_BulkSpeed.txt',' ',1);
    
    
    % GOES e- flux (0.8 - 2 MeV)
    api = 'http://iswa.gsfc.nasa.gov/IswaSystemWebApp/DataStreamServlet';
    url = sprintf([api '?format=text&quantity=E_8,E2_0&resource=GOES-13,GOES-13&resourceInstance=GOES-13,GOES-13&end-time=%s&begin-time=%s'],endTime{ii},startTime{ii});
    filename = 'GOES_e-_flux.txt';
    outfilename = websave(filename,url);
    E_flux_data = importdata('GOES_e-_flux.txt',' ',1);
    
    % KP
    api = 'http://iswa.gsfc.nasa.gov/IswaSystemWebApp/DataStreamServlet';
    url = sprintf([api '?format=text&quantity=KP&resource=NOAA-KP&resourceInstance=NOAA-KP&end-time=%s&begin-time=%s'],endTime{ii},startTime{ii});
    filename = 'KP_index.txt';
    outfilename = websave(filename,url);
    KP_data = importdata('KP_index.txt',' ',1);
    
    %% GOES13 Total B
    api = 'http://iswa.gsfc.nasa.gov/IswaSystemWebApp/DataStreamServlet';
    url = sprintf([api '?format=text&quantity=Hp,He,Hn,TotalField&resource=GOES-13,GOES-13,GOES-13,GOES-13&resourceInstance=GOES-13,GOES-13,GOES-13,GOES-13&end-time=%s&begin-time=%s'],endTime{ii},startTime{ii});
    filename = 'observed_mag.txt';
    outfilename = websave(filename,url);
    TotalB_data = importdata('observed_mag.txt',' ',1);
    
    Timestamp = [strcat(TotalB_data.textdata(2:end,1),{' '},TotalB_data.textdata(2:end,2))];
    Hp = TotalB_data.data(:,1);He = TotalB_data.data(:,2);Hn = TotalB_data.data(:,3);TotalField = TotalB_data.data(:,4);
    TotalB_data = TotalB_data.data;
    
    errorIndex = find(TotalField == -100000);
    TotalField(errorIndex) = NaN;
    
    startIndex = strfind(Timestamp,startTime{ii});
    endIndex = strfind(Timestamp,endTime{ii});
    startIndex = find(not(cellfun('isempty', startIndex)));
    endIndex = find(not(cellfun('isempty', endIndex)));
    
    t = datenum(Timestamp);
    dt = length(startIndex:endIndex);
    %     plotRange = linspace(0,1,dt);
    plotRange = linspace(datenum(startTime{ii}),datenum(endTime{ii}),dt);

    figure(ii);
    plot(plotRange,TotalField(startIndex:endIndex));hold on;
end
%%

    
    
    
    



%% Plot
figure(1)
subplot(5,1,1)
plot(jd_half,P_t_half);ylabel('Perp. Pressure [picoPascal]');grid minor
subplot(5,1,2)
plot(jd_half,v_half);ylabel('Solar Wind Velocity [km/s]');grid minor
subplot(5,1,3)
plot(jd_half,B_half);ylabel('Magnetic Field Intensity [T]');grid minor
subplot(5,1,4)
plot(jd_half,log(N_p_half));ylabel('P. Number Density (log) [m^3]');grid minor
subplot(5,1,5)
plot(jd_half,log(T_p_half));xlabel('Time');ylabel('Proton Temperature (log) [K]');grid minor
print -dpdf 'fulldata.pdf'