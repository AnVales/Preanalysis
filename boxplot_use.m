% load carsmall
% boxplot(MPG,Origin)

x = linspace(0,10,50);
y1 = sin(x);
boxplot(x,y1)
str = ' Frecuency ($$Hz$$) '; h=xlabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=60;
str = ' G'' ($$Pa$$) '; h=ylabel(str,'Interpreter','latex'); s=h.FontSize; h.FontSize=60;
ax = gca;
ax.FontSize = 25;

hold on

y2 = sin(x/2);
plot(x,y2)

y3 = 2*sin(x);
scatter(x,y3) 

hold off