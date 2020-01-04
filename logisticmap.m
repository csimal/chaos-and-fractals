%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Script matlab permettant de représenter les orbites de l'applciation logistique et ces composées 
%%% Auteur : Mohet Judicaël et Simal Cedric
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc, clear all

X = 0;
r=4;


%%%Sensibilité CI
span = 0:0.0001:1;

x01 =1e-3;
x02=2*1e-3;
x1=0*span; x2=0*span;
x1(1) = logistic(x01,r);
x2(1) = logistic(x02,r);

for i = 1:length(span)-1
    x1(i+1) = logistic(x1(i),r);
    x2(i+1) = logistic(x2(i),r);
end

figure
plot(span(1:100),x1(1:100),span(1:100),x2(1:100))
title('Orbites de l''application logistique')
xlabel('temps')
ylabel('Orbites')
legend({'$x_0 = 0.001$','$x_0 = 0.002$'},'Interpreter','latex')
saveas(gcf,"orbite_logistique.png")


%Plot logistique et compmosées
r = 3.5;
syms x;
f = r*x*(1-x);
T2 =compose(f,f);
T4 = compose(f,compose(f,compose(f,f)));

%logistique
figure
fplot(f,[0, 1],'k')
hold on 
plot(span,span,'r')
title('Graphique de $T_r$ avec $r = 4$','Interpreter','latex')
xlabel('$x$','Interpreter','latex')
ylabel('$T_r(x)$','Interpreter','latex')

saveas(gcf,"logistic35.png")

%composée 2
figure 
fplot(T2,[0,1],'k')
hold on
plot(span,span,'r')
title('Graphique de $T^2_r$ avec $r = 3.5$','Interpreter','latex')
xlabel('$x$','Interpreter','latex')
ylabel('$T^2_r(x)$','Interpreter','latex')

saveas(gcf,"2logistic35.png")

%composée 4
figure 
fplot(T4,[0,1],'k')
hold on
plot(span,span,'r')
title('Graphique de $T^4_r$ avec $r = 3.5$','Interpreter','latex')
xlabel('$x$','Interpreter','latex')
ylabel('$T^4_r(x)$','Interpreter','latex')

saveas(gcf,"4logistic35.png")


function x = logistic(y,r)
    x = r*y*(1-y);
end
function x = logistic2(y,r)
    x = r*r*y*(1-y)*(1 - r*y * (1-y))
end
function x = derlogi(x,r)
    x = 4 * (1 - 2 * x);
end

