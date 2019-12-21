%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Script matlab permettant de calculer l'exposant de Lyapunov pour l'application logistique
%%% Auteur : Mohet Judicaël et Simal Cedric
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc, clear all

X = 0.202;
r=2.8;

span = 0:0.0001:1;

x0 =0.9;
x1=0*span; x2=0*span;
x1(1) = logistic(x0,r);
x2(1) = log(norm(derlogi(x0,r)));

for i = 1:length(span)-1
    x1(i+1) = logistic(x1(i),r);
    x2(i+1) = log(norm(derlogi(x1(i),r)));
end

sum(x2) / length(span)


function x = logistic(y,r)
    x = r*y*(1-y);
end
function x = logistic2(y,r)
    x = r*r*y*(1-y)*(1 - r*y * (1-y))
end
function x = derlogi(x,r)
    x = 4 * (1 - 2 * x);
end