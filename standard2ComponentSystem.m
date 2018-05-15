function standard2ComponentSystem(data, xl, stitle)

global P Tb_exp x_exp
P = data(1,2)*10^3;
Tb_exp = data(:,1);
x_exp = data(:,3);
y_exp = data(:,4);

    % VLE part
    % there are several ways to get the same figure/information
    x = 0.0:0.01:1.0;
    Tb = zeros(length(x),1);
    Td = zeros(length(x),1);
    yb = zeros(1,length(x));
    yd = zeros(1,length(x));
    for i = 1:length(x)
        z = [x(i),1-x(i)];
        [Tbi,lnK,~] = TBUBBLE(P,z);
        Tb(i) = Tbi;
        yb(i) = exp(lnK(1))*x(i);
        [Tdi,lnK,~] = TDEW(P,z);
        Td(i) = Tdi;
        yd(i) = exp(lnK(1))*x(i);
    end
    
    figure
    hold on
    plot(x,Tb,yb,Tb)
    plot(x_exp,Tb_exp,'ro',y_exp,Tb_exp,'ro')
    xlabel(xl);
    ylabel('Temperature(K)');
    title(stitle);
    hold off
        
    % call this function when calculation is finished
    FINISHUP_THERMO();
    
end 