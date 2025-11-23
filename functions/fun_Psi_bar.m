function Psi_bar = fun_Psi_bar(H,param_a, param_b, param_c)

k = size(param_b,1);

Psi_bar = NaN(k,k,H+1);
type_GaussBasis = 'Adjusted 1'; 

for i = 1:k
    for j = 1:k

        if param_a(i,j) == 0

            Psi_bar(i,j,:) = zeros(H+1,1);

        else

            param_GaussBasis = [param_a(i,j), param_b(i,j), param_c(i,j)];
    
            for h = 0:H
                % % % Psi_bar(i,j,h+1) = zFC_GaussBasis_03(h, param_GaussBasis, type_GaussBasis); 
                Psi_bar(i,j,h+1) = fun_GaussBasis(h, param_GaussBasis, type_GaussBasis);

            end

        end
               
    end
end


end