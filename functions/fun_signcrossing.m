function t = fun_signcrossing(x)

% 1. Get the signs of the vector (-1, 0, or 1)
s = sign(x);

% 2. Find where the sign changes between consecutive elements
% s(1:end-1) is the current element, s(2:end) is the next element
crossings = find(s(1:end-1) .* s(2:end) < 0);

% 3. The "first period after" the change is the second index in the pair
t = crossings + 1;

end