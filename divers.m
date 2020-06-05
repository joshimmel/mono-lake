%% Function to determine allowed diversions by Josh Himmelstein
function [diversion]=divers(elevation,sign)
if sign>0;
    if elevation<(6377*.3048);
        diversion=0;
    elseif  elevation<(6380*0.3048);
        diversion=(4500*1233.48);
    elseif elevation<(6392*0.3048);
        diversion=(16000*1233.48);
    end
else sign<0;
    if elevation>(6392*.3048);
        diversion=(31000*1233.48);
    elseif elevation<(6391*.3048);
        diversion=(10000*1233.48);
    elseif elevation<(6388*.3048);
        diversion=0;
    end
end
end 
