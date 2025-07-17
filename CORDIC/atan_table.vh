// Q1.6 fixed-point atan(2^-i) values for i = 0 to 6
`define ATAN_TABLE_SIZE 7

`define ATAN_TABLE { \
    8'sd50, \  // atan(2^-0) = 0.785398 ≈ 50 (Q1.6) \
    8'sd30, \  // atan(2^-1) = 0.463648 ≈ 30 \
    8'sd16, \  // atan(2^-2) = 0.244978 ≈ 16 \
    8'sd8,  \  // atan(2^-3) = 0.124355 ≈ 8 \
    8'sd4,  \  // atan(2^-4) = 0.062418 ≈ 4 \
    8'sd2,  \  // atan(2^-5) = 0.031240 ≈ 2 \
    8'sd1   \  // atan(2^-6) = 0.015624 ≈ 1 \
}
