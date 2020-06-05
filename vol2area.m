%% function to determine area from input volume by Josh Himmelstein
function[area]=vol2area(volume)
e=-3.6381824e-30;
d=6.252318302e-20;
c=-4.025416492e-10;
b=1.169424406;
a=-1104742655;
area=(a+(b*(volume))+(c*(volume^2))+(d*(volume^3))+(e*(volume^4)));
end
