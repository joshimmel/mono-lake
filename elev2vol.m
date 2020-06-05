%%function to determine volume from elevation by Josh Himmelstein
function[vol]=elev2vol(elev)
c=1925.424886-elev;
b=7.44975609e-9;
a=-3.019991595e-19;
vol=(-b+(((b^2)-(4*a*c))^.5))/(2*a);
end
