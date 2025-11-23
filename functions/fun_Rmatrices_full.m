function [R_small, R, Riota_small, Riota] = fun_Rmatrices_full(Psi,k,p)


    H = size(Psi,3)-1; % if condition on a shorter IRF, it creates R only for the first hor-1 horizons
    
   

    R_small = sparse(k*H,k*p);
    
    Step = @(hor) Psi(:,:,hor+1)';

    if p >= 1

        for q_step = 1:p
            j_step = (q_step-1)*k+1:(q_step)*k;
            for z_step = q_step:H
                i_step = (z_step-1)*k+1:(z_step)*k;
                R_small(i_step,j_step) = Step(z_step-q_step);
            end
        end
        
    else
        disp('PROBLEM: R_small calculated, but p=0')    
        StopCodeHere

    end



    R = kron(R_small,eye(k));

    if H > p

        Riota_small = NaN(k*p);
        Riota       = NaN(k^2*p);


    elseif H == p

        Riota_small = R_small\speye(k*p);
        Riota       = R\speye(k^2*p);

    else
        disp('PROBLEM: H set below p')    
        StopCodeHere

    end
    
    
end
