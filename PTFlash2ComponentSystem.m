function PTFlash2ComponentSystem(data, xl, stitle)

% set binary interaction parameters
NOSPECKIJ(1);   % no of user specified kijs
SPECKIJ(1, 1, 2, 0.023);    % check help + SPECKIJ for more details
%                     , b, c

NOSPECCROSSASSOC(1);
SPECCROSSASSOC(1, 1, 2, 3, 0.15);
%                              , crseng
%                       sch vol  
    
% finishing setup
SETUP_THERMO()  % this function has to be called when parameters changed

global Tb_exp x_exp y_exp
P = data(1,2)*10^3;
Tb_exp = data(:,1);
x_exp = data(:,3);
y_exp = data(:,4);

    % Plotdata(id_fig,xl,stitle);
    Plotdata_VLE_ConstP(xl,stitle,P,373,352.5,342.5)      % for benzene - water
                                    % Disse temps indsættes fra data sæt -
                                    % find værdier hørende til laveste og
                                    % højeste x-værdi - find derefter ud af
                                    % om der er en temp højere eller lavere
                                    % end disse værdier, da der i det
                                    % tilfælde er et azeotropt punkt
    
    % Dette er så vidt jeg forstår blot interessante beregninger
    ZFeed=[0.1,0.9];
    T=360;
    [pMoleFrac,pPhaseFrac,pPhaseType,ierr]=PTFLASH(T,P,ZFeed)
    % Gør det muligt at for brugeren at udføre disse 3 ligninger og
    % indsætte input selv
    
    % call this function when calculation is finished
    FINISHUP_THERMO();
    
end


function Plotdata_VLE_ConstP(xl,stitle,P,TLeft,TRight,Taze)
    global Tb_exp x_exp y_exp
    % VLE part
    % there are several ways to get the same figure/information
    if ((Taze < TLeft && Taze < TRight) || (Taze > TLeft && Taze > TRight))     % having an azetrope point
        [T1,x1,y1]=PTFlash_VLE_ConstP_Range(P,TLeft,Taze,1);      % the first branch     
        [T2,x2,y2]=PTFlash_VLE_ConstP_Range(P,Taze,TRight,0);     % the second branch
        T=[T1,T2];
        x=[x1,x2];
        y=[y1,y2];
    else        % if there is no azetrope point for the given temperature range
        [T,x,y]=PTFlash_VLE_ConstP_Range(P,Tmin,Tmax,1);
    end
    
    figure
    hold on
    plot(x,T,'r-',y,T,'b--')
    plot(x_exp,Tb_exp,'ro',y_exp,Tb_exp,'b*')
    xlabel(xl);
    ylabel('Temperature(K)');
    title(stitle);
    hold off
end
function [T,x,y]=PTFlash_VLE_ConstP_Range(P,TLeft,TRight,FromLeft)
    np = 20;    % for example, we use 20 points for plotting
    dT = (TRight - TLeft) / np;
    
    if (FromLeft == 1)
        
        for i = 1:np+1
            
            %Finder det sted hvor der er VLE-forhold og gemmer x- og
            %y-værdierne
            FindVLE = 0;
            T(i) = TLeft + (i-1)*dT;
            for iz=0.01:0.01:0.50
                ZFeed=[iz, 1.0-iz];
                [x(i),y(i),FindVLE]=PTFlash_VLE_ConstP_Point(T(i), P, ZFeed);
                if (FindVLE == 1) 
                    break;
                end
            end
            if (FindVLE == 0)
                for iz=0.51:0.01:0.99
                    ZFeed=[iz, 1.0-iz];
                    [x(i),y(i),FindVLE]=PTFlash_VLE_ConstP_Point(T(i), P, ZFeed);
                    if (FindVLE == 1) 
                        break;
                    end
                end
            end
        end
    else
        for i = 1:np+1
            FindVLE = 0;
            T(i) = TLeft + (i-1)*dT;
            for iz=0.99:-0.01:0.51
                ZFeed=[iz, 1.0-iz];
                [x(i),y(i),FindVLE]=PTFlash_VLE_ConstP_Point(T(i), P, ZFeed);
                if (FindVLE == 1) 
                    break;
                end
            end
            if (FindVLE == 0)
                for iz=0.50:-0.01:0.01
                    ZFeed=[iz, 1.0-iz];
                    [x(i),y(i),FindVLE]=PTFlash_VLE_ConstP_Point(T(i), P, ZFeed);
                    if (FindVLE == 1) 
                        break;
                    end
                end
            end
        end
    end
end
function [x,y,FindVLE]=PTFlash_VLE_ConstP_Point(T, P, ZFeed)
% Udregner molfraktionen i begge faser hvis det er væske og gas
% og sætter FindVLE = 1
    
    FindVLE = 0;
    [pMoleFrac,pPhaseFrac,pPhaseType,~]=PTFLASH(T,P,ZFeed);
    if (length(pPhaseFrac) == 2)    % we have two phases
        if (pPhaseType(1)*pPhaseType(2) < 0)    % we have VLE
            x = pMoleFrac(1,2);
            y = pMoleFrac(1,1);
            FindVLE = 1;
        end
    end
end
    

