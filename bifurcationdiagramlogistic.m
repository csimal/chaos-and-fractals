%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Script matlab permettant de représenter un diagramme de bifurcation pour l'application logistique 
%%% Auteur : Mohet Judicaël et Simal Cedric
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clc, clear all

%preorb est le nombre d'itérations qu'on ne tien pas compte
%nborb est le nombre d'orbites représentées
preorb = 500; nbrorb = 50;
x = zeros(nbrorb,1);

%Avant r=2.8, il ne se passe pas grand chose
for r = 2.8:0.001:4,
  x(1) = 0.1;
  for n = 1:preorb,
    x(1) = r*x(1)*(1 - x(1));
  end
  for n = 1:nbrorb-1,
    x(n+1) = r*x(n)*(1 - x(n));
  end
  plot(r*ones(nbrorb,1), x,'.k',  'MarkerSize',3)
  hold on;
end

xlim([2.8 4])
title('Diagramme de bifucartion de l''application logistique')
xlabel('r')
ylabel('Orbites')

saveas(gcf,"bifulogi.png")
