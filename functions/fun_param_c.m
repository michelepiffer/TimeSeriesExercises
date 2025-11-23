function param_c = fun_param_c(param_a, param_b, param_hl, param_pf, Option_c)

k = size(param_b,1);

param_c = NaN(k,k); 
for i = 1:k
    for j = 1:k

        a  = param_a(i,j);
        b  = param_b(i,j);
        hl = param_hl(i,j);
        pf = param_pf(i,j);


        if b == 0

            %%% If b=0, set c so that the IRF reaches half of the impact/peak effect (i.e. a/2) at the pre-specified period "param_hl"
            assert(hl > b)
            assert( floor(hl) ==  ceil(hl) ) % check it is an integer
            param_c(i,j) = hl/sqrt(-log(1/2));


        elseif b > 0

            if strcmp(Option_c, 'control_peak_effect')    

                %%% if b>0, set c to ensure that the peak effect (i.e. the value at h=b) is a multiple "param_pf" of the impact effect "param_a"
                assert( pf > 1 )
                assert( isnan(pf) == 0)

                % % % param_c(i,j) = b/sqrt(log(pf*param_a(i,j)) - log(param_a(i,j)));
                param_c(i,j) = b/sqrt(log(pf));

            elseif strcmp(Option_c, 'control_half_life')    

                %%% if b>0, set c so that after h=b the IRF reaches half of the impact effect (i.e. a/2) at the pre-specified period "param_hl"
                assert(hl > 2*b)
                assert( isnan(hl) == 0)

                param_c(i,j) = sqrt(  ((hl-b)^2 -b^2)/(-log(1/2)) );

            else
                StopCodeHere
            end
        
        else
            StopCodeHere
        end
    end
end


end