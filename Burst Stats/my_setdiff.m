function C = my_setdiff(A,B, wiggle)
% MYSETDIFF Set difference of two sets of positive integers (column-wise)
% C = my_setdiff(A,B, wiggle)
% where wiggle is an integer that allows for "wiggle room" in the values of
% the matrix B
% C = A \ (B+/-wiggle) = {things in A that are not within wiggle range of B}

% 
if isempty(A)
    C = [];
    return;
elseif isempty(B)
    C = A;
    return; 
else % both non-empty
    bits = zeros(1, max(max(A), max(B)));
    bits(A) = 1;
    wig_range=[-wiggle:wiggle];
    wigmat=repmat(wig_range,length(B),1);
    B=repmat(B,1,length(wig_range))+wigmat;
    bits(B(B>0)) = 0;
    C = A(logical(bits(A)));
end