dKKT =  jacobian(KKT,unknowns);
if isHxxExplicit
    disp('Generating Explicit dKKT Function File......');
    matlabFunction(dKKT,...
            'File','GEN_Func_dKKT',...
            'Vars',{unknowns;p},...
            'Optimize',true);
    % for condensing
    Hxx =  jacobian(Hx,x)*deltaTau;
    matlabFunction(Hxx,...
            'File','GEN_Func_Hxx',...
            'Vars',{unknowns;p});
    disp('Done...');
else
    disp('Generating Forward Difference dKKT Function File......');
    dKKT(end-xDim+1:end,end-xDim+1:end) = 0;
    matlabFunction(dKKT,...
            'File','GEN_Func_dKKT_NoHxx',...
            'Vars',{unknowns;p},...
            'Optimize',true);
    matlabFunction(Hx*deltaTau,...
            'File','GEN_Func_Hxdt',...
            'Vars',{unknowns;p});
    disp('Done...');
end
% for condensing
disp('Generating Jacobian Function Files......');
fu  =  jacobian(f,u)*deltaTau;
fx  =  jacobian(f,x)*deltaTau;
fx_I = fx - eye(xDim);
Hux =  jacobian(Hu,x)*deltaTau;
if muDim == 0 
    KKT23  = Hu(varibleLambdaMuUXP{:}).'*deltaTau;
else
    KKT23  = [C(varibleUXP{:})*deltaTau;...
            Hu(varibleLambdaMuUXP{:}).'*deltaTau];
    Cx  =  jacobian(C,x)*deltaTau;
    matlabFunction(Cx,...
        'File','GEN_Func_Cx',...
        'Vars',{unknowns;p});
end
dKKT23_mu_u = jacobian(KKT23,[mu;u]);

matlabFunction(fu,...
    'File','GEN_Func_fu',...
    'Vars',{unknowns;p});
matlabFunction(fx,...
    'File','GEN_Func_fx',...
    'Vars',{unknowns;p});
matlabFunction(fx_I,...
    'File','GEN_Func_fx_I',...
    'Vars',{unknowns;p});
matlabFunction(Hux,...
    'File','GEN_Func_Hux',...
    'Vars',{unknowns;p});
matlabFunction(dKKT23_mu_u,...
    'File','GEN_Func_dKKT23_mu_u',...
    'Vars',{unknowns;p});
disp('Done...');