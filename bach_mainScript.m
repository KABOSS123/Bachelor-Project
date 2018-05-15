function bach_mainScript()
clc;
clear all;
close all;
format long g;


[data, comp, usePTFlash] = readSystem();

while ~strcmp(data,'exit')
        
    % choose a model
    CHOOSEAMODEL(4);    % 1-CPA, 2-SRK, 3-PR, 4-PC-SAFT, default/others eCPA

    % set number of components
    NC = length(comp);
    NOPURECOMP(NC);
    
    % Creates cell array containing the parameter values of the components
    % and the component names. 
    PV = TOP(comp);
    
    % set critical properties
    % This is mainly used to initialize PT Flash calculation, if you do not
    % have exact values, you may just put some estiamates.
    Tc1 = PV{1, 3}; Pc1 = PV{1, 4}; Om1 = PV{1, 5};
    Tc2 = PV{2, 3}; Pc2 = PV{2, 4}; Om2 = PV{2, 5};
    
    %        idx,  Tc[K]  Pc[Pa] Omega
    CRITPROPS(1,   Tc1,   Pc1,   Om1);
    CRITPROPS(2,   Tc2,   Pc2,   Om2);
   
    % set pc-saft 'physical' parameters
    m1 = PV{1, 6}; sigma1 = PV{1, 7}; eps1 = PV{1, 8};
    m2 = PV{2, 6}; sigma2 = PV{2, 7}; eps2 = PV{2, 8};
        
    %         idx   m[-]  sigma(A)  eps [K]
    SAFTPARAMS(1,   m1,   sigma1,   eps1);
    SAFTPARAMS(2,   m2,   sigma2,   eps2);
    
    % set association parameters
    sc_pc1 = PV{1, 9}; vhb_pc1 = PV{1, 10}; ehb_pc1 = PV{1, 11};
    sc_pc2 = PV{2, 9}; vhb_pc2 = PV{2, 10}; ehb_pc2 = PV{2, 11};
        
    %           idx  scheme    ass vol    ass eng
    ASSOCPARAMS(1,   sc_pc1,   vhb_pc1,   ehb_pc1);
    ASSOCPARAMS(2,   sc_pc2,   vhb_pc2,   ehb_pc2);
    
    % Assigns parameters for the third parameters in case there is one. 
    if length(comp) == 3
        
        Tc3 = PV{3, 3}; Pc3 = PV{3, 4}; Om3 = PV{3, 5}; 
        CRITPROPS(3,   Tc3,   Pc3,   Om3);
        
        m3 = PV{3, 6}; sigma3 = PV{3, 7}; eps3 = PV{3, 8};
        SAFTPARAMS(3,   m3,   sigma3,   eps3);
        
        sc_pc3 = PV{3, 9}; vhb_pc3 = PV{3, 10}; ehb_pc3 = PV{3, 11};
        ASSOCPARAMS(3,   sc_pc3,   vhb_pc3,   ehb_pc3);
        
    end
    
    if length(comp) == 3
        xl = ['Mole fraction of ', lower(PV{1,1})];
        stitle = ['TXY diagram of ', lower(PV{1,1}), ', ', lower(PV{2,1}), ' and ', lower(PV{3,1})];
    else
        xl = ['Mole fraction of ', lower(PV{1,1})];
        stitle = ['TXY diagram of ', lower(PV{1,1}), ' and ', lower(PV{2,1})];
    end

    if usePTFlash == 1
        
        PTFlash2ComponentSystem(data, xl, stitle)
        
    else
        
        % finishing setup
        SETUP_THERMO()  % this function has to be called when parameters changed
        
        standard2ComponentSystem(data, xl, stitle) 
        
    end

    [data, comp, usePTFlash] = readSystem();
end

end