function [psi, psi_0, psi_F] = fun_psi_vectors(Psi,k)

    p = size(Psi,3)-1; % if condition on a shorter IRF, it creates R only for the first hor-1 horizons

    ksqr = k^2;

    psi = NaN*ones(ksqr*(p+1),1);
    psi(1:ksqr) = reshape(Psi(:,:,1),ksqr,1);
    if p >= 1
        for q_step = 1:p
            psi((q_step)*ksqr+1:(q_step+1)*ksqr) = reshape(Psi(:,:,q_step+1),ksqr,1);
        end
    end
    
    psi_0 = psi(1:ksqr);    
    psi_F = psi(ksqr+1:end);

end